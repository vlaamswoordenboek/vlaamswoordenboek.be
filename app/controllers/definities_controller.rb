class DefinitiesController < ApplicationController

  before_action :login_required, :only => [ :reageer, :creeer, :nieuw, :bewerk, :update, :verwijder ]
  before_action :recent_blocks, except: [:recent_rss, :wijzigingen_rss]
  after_action :set_title_from_definition, only: [:show]

  def index
    @title = "Welkom bij het Vlaams woordenboek"
    @random_definitions = Definition.random_sample(count: 5, needs_positive_rating: true)
  end

  def woordvandedag
    @title = "Vlaams woord van de dag"

    @offset = params[:offset] || 0
    @wotds = Wotd.all.past.limit(10).offset(@offset)
    if logged_in? && current_user.admin?
      @upcoming_wotds = Wotd.find :all, :conditions => "date > '#{Date.today}'", :order => 'date ASC'
    end

    respond_to do |format|
      format.html {}
      format.xml do
        @feed_title = "Vlaams woord van de dag"
        @feed_url = "http://" + request.host_with_port + "/definities/woordvandedag"
        @feed_description = "Vlaams woord van de dag"
        response.headers['Content-Type'] = 'application/rss+xml'
        render 'woordvandedag', layout: false
      end
    end
  end

  def show
    @definition = Definition.find(params[:id])

    if logged_in? && current_user.admin?
      @wotds = Wotd.find( :all, :conditions => "definition_id = '#{@definition.id}'" );
      @wotd_dates = []
      date = Date.today
      for i in (1..50)
        datestr = date.strftime("%Y-%m-%d")
        wotd = Wotd.find_by_date( datestr )
        if !wotd
          @wotd_dates << datestr;
        end
        date = date + 1
      end
    end

    render 'toon'
  end

  alias :toon :show

  def term
    @term = params[:term]
    @definitions = Definition.where(word: @term).order(positivevotes: :desc)

    @title = @term
  end

  def random
    @title = "Een willekeurige selectie"
    @random_definitions = Definition.random_sample(count: 10).order(:positivevotes)
  end

  def recent
    @offset = 0
    if params[:offset]
      @offset = params[:offset]
    end
    @title = "Recente toevoegingen"
    @recent_definitions = Definition.recent(count: 20, offset: @offset)
  end

  def top
    @offset = 0
    if params[:offset]
      @offset = params[:offset]
    end
    @title = "Top woorden"

    @top_definitions = Definition.top(count: 20, offset: @offset)
  end

  def new
    @definition = Definition.new
    @title = "Voeg een nieuwe definitie toe"
  end

  def create
    @definition = Definition.new(new_definition_params)
    @definition.updated_by = self.current_user.id
    @definition.rating = 0;
    if @definition.save
      flash[:notice] = 'Uw nieuwe term werd succesvol in onze databank bewaard. Bedankt voor uw bijdrage!'
      expire_fragments_upon_save
      redirect_to term_definitions_path(@definition.word)
    else
      render 'new'
    end
  end

  private
  def set_title_from_definition
    @title = @definition.word
  end

  def recent_gewijzigd_block
    unless read_fragment( :controller => "definities", :part => "recent_gewijzigd_block" )
      @recent_gewijzigd = DefinitionVersion.recent(count: 5)
    end
  end

  def recent_toegevoegd_block
    unless read_fragment( :controller => "definities", :part => "recent_toegevoegd_block" )
      @recent_toegevoegd = Definition.recent(count: 5)
    end
  end

  def recent_reactions_block
    unless read_fragment( :controller => "definities", :part => "recent_reactions_block" )
      @recent_reactions = Reaction.recent(count: 5)
    end
  end

  def recent_blocks
    recent_toegevoegd_block
    recent_gewijzigd_block
    recent_reactions_block
  end

  def wijzigingen
    @offset = 0
    if params[:offset]
    	@offset = params[:offset]
    end
    @title = "Recente wijzigingen"
    get_recent_gewijzigd( 20, @offset )
    @definition_versions = @recent_gewijzigd
  end

  def reacties
    @offset = 0
    if params[:offset]
    	@offset = params[:offset]
    end
    @title = "Recente reacties"
    get_recent_reactions( 20, @offset )
    @reactions = @recent_reactions
  end

  def recent_rss
    get_recent_toegevoegd( 10 )
    @feed_title = "Vlaams woordenboek: Recente toevoegingen"
    @feed_url = "http://" + request.host_with_port
    @feed_description = "Recent toegevoegde woorden aan het Vlaams Woordenboek"
    response.headers['Content-Type'] = 'application/rss+xml'
    render :action => 'recent_rss', :layout => false
  end

  def wijzigingen_rss
    get_recent_gewijzigd( 10 )
    @feed_title = "Vlaams woordenboek: Recente wijzigingen"
    @feed_url = "http://" + request.host_with_port
    @feed_description = "Recent toegevoegde woorden aan het Vlaams Woordenboek"
    response.headers['Content-Type'] = 'application/rss+xml'
    render :action => 'wijzigingen_rss', :layout => false
  end

  def begintmet
    @begin = params[:id]
    unless read_fragment( :controller => 'definities', :action =>'begintmet', :id => @begin, :part => 'lijst' )
      @langer = []
      for letter in 'a'..'z'
        if Definition.find( :first, :conditions => "word like '#{@begin}#{letter}%'")
          @langer << @begin+letter
        end
      end
      query = "select distinct word"
      query << " from definitions"
      query << " where word like '#{@begin}%'"
      query << " order by word asc"
      @words = Definition.find_by_sql(query)
    end
    @title = "Woorden die beginnen met '" + @begin +"'"
  end

  def zoek
    if params[:definition]
      @zoekquery = params[:definition][:word]
      #@definitions = Definition.find_by_contents( @zoekquery )
      @definitions = Definition.search( @zoekquery )
      @definition = Definition.new # gebruiken om in form nieuwe definitie toe te voegen
      @title = "Zoekresultaten voor '#{@zoekquery}'"
    else
      redirect_to :action => 'index'
    end
  end

  def geschiedenis
    @definition = Definition.find(params[:id])
    @definition_versions = @definition.versions.reverse
    title
  end

  def wotd
    if logged_in? && current_user.admin?
      @definition = Definition.find( params[:id] )
      @wotd = Wotd.new( params[:wotd] )
      @wotd.definition_id = params[:id]
      if @wotd.save
        flash[:notice] = 'Definitie bewaard voor WOTD'
      end
    end
    redirect_to :action => 'toon', :id => @definition
  end

  def expire_fragments_upon_save

    expire_fragment( :controller => 'definities', :part => 'recent_toegevoegd_block' )
    expire_fragment( :controller => 'definities', :part => 'recent_gewijzigd_block' )
    str = @definition.word
    for i in (0..str.length-1)
      expire_fragment( :controller => 'definities', :action => 'begintmet', :id => str[0..i], :part => 'lijst' )
    end

  end

  def reageer
    @definition = Definition.find(params[:id])
    @reaction = Reaction.new(params[:reaction])
    @reaction.definition = @definition
    @reaction.created_by = self.current_user.id
    if @reaction.save
      flash[:notice] = 'Bedankt voor uw reactie!'
      expire_fragment( :controller => 'definities', :part => 'recent_reactions_block' )
      redirect_to :action => 'toon', :id => @definition
    else
      render :action => 'toon', :id => @definition
    end
  end

  def bewerk
    @definition = Definition.find(params[:id])
    title
  end

  def update
    @definition = Definition.find(params[:id])
    title
    params[:definition][:updated_by] = self.current_user.id
    if @definition.update_attributes(params[:definition])
      flash[:notice] = 'Uw aanpassing werd succesvol in onze databank bewaard. Bedankt voor uw bijdrage.'
      expire_fragments_upon_save
      redirect_to :action => 'term', :id => @definition.word
    else
      render :action => 'bewerk'
    end
  end

  def verwijder
    @definition = Definition.find(params[:id])
    if( self.current_user.admin? )
      @definition.destroy
      flash[:notice] = 'Uw beschrijving werd verwijderd.'
      expire_fragments_upon_save
      redirect_to :action => 'term', :id => @definition.word
    else
      flash[:notice] = 'Woorden kunnen niet worden verwijderd'
      redirect_to :action => 'term', :id => @definition.word
    end
  end

  def verwijder_reactie
    @reaction = Reaction.find(params[:id])
    if( self.current_user.admin? )
      @reaction.destroy
      flash[:notice] = 'Uw reactie werd verwijderd.'
      expire_fragment( :controller => 'definities', :part => 'recent_reactions_block' )
      redirect_to :action => 'toon', :id => @reaction.definition.id
    else
      flash[:notice] = 'Woorden kunnen niet worden verwijderd'
      redirect_to :action => 'toon', :id => @reaction.definition.id
    end
  end

  def get_voter
    if cookies[:voter]
      return Voter.find( cookies[:voter] )
    else
      current_voter = Voter.create
      cookies[:voter] = { :value => current_voter.id.to_s, :expires => 1.year.from_now }
      return current_voter
    end
  end

  def thumbsup
    @definition = Definition.find(params[:id])
    @voter = get_voter
    @vote = Vote.find(:first, :conditions => ["voter_id = ? and definition_id = ?", @voter.id, @definition.id])
    if @vote
      # This cookie holder already voted, we'll ignore his request
    else
      @vote = Vote.create( :definition => @definition, :voter => @voter, :value => 1 )
      @definition.positivevotes += 1
      @definition.rating = @definition.positivevotes - @definition.negativevotes
      @definition.save_without_revision!
    end
    redirect_to :controller => 'definities', :action => 'toon', :id => @definition unless request.xhr?
  end

  def thumbsdown
    @definition = Definition.find(params[:id])
    @voter = get_voter
    @vote = Vote.find(:first, :conditions => ["voter_id = ? and definition_id = ?", @voter.id, @definition.id])
    if @vote
      # This cookie holder already voted, we'll ignore his request
    else
      @vote = Vote.create( :definition => @definition, :voter => @voter, :value => -1 )
      @definition.negativevotes += 1
      @definition.rating = @definition.positivevotes - @definition.negativevotes
      @definition.save_without_revision!
      redirect_to :controller => 'definities', :action => 'toon', :id => @definition unless request.xhr?
    end
  end

  def new_definition_params
    params.require(:definition).permit(
      :word,
      :properties,
      :description,
      :regio,
      :example
    )
  end
end
