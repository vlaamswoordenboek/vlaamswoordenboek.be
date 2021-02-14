class DefinitiesController < ApplicationController

  before_filter :login_required, :only => [ :reageer, :creeer, :nieuw, :bewerk, :update, :verwijder ]

  def title
    @title = @definition.word
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :creeer, :update ],
         :redirect_to => { :action => :index }

  def random_sample(n = 1, positiverating = false )
    if( positiverating )
      Definition.find(Definition.find_by_sql("select id from definitions where positivevotes > 100 order by random() limit #{n}").map { |q| q.id })
    else
      Definition.find(Definition.find_by_sql("select id from definitions order by random() limit #{n}").map { |q| q.id })
    end
  end

  def get_recent_gewijzigd(n = 10, offset = 0)
    @recent_gewijzigd = DefinitionVersion.find :all, :limit => n, :order => 'updated_at DESC', :offset => offset
  end

  def get_recent_toegevoegd(n = 10, offset = 0)
    @recent_toegevoegd = Definition.find :all, :limit => n, :order => 'id DESC', :offset => offset
  end

  def get_recent_reactions( n = 10, offset = 0 )
    @recent_reactions = Reaction.find :all, :limit => n, :order => 'created_at DESC', :offset => offset
  end

  def get_top(n = 20, offset = 0)
    @definitions = Definition.find :all, :limit => n, :order => 'positivevotes DESC', :limit => n, :offset => offset
  end

  def recent_gewijzigd_block
    unless read_fragment( :controller => "definities", :part => "recent_gewijzigd_block" )
      get_recent_gewijzigd( 5 )
    end
  end

  def recent_toegevoegd_block
    unless read_fragment( :controller => "definities", :part => "recent_toegevoegd_block" )
      get_recent_toegevoegd( 5 )
    end
  end

  def recent_reactions_block
    unless read_fragment( :controller => "definities", :part => "recent_reactions_block" )
      get_recent_reactions( 5 )
    end
  end

  def recent_blocks
    recent_toegevoegd_block
    recent_gewijzigd_block
    recent_reactions_block
  end

  def recent
    @offset = 0
    if params[:offset]
    	@offset = params[:offset]
    end
    @title = "Recente toevoegingen"
    get_recent_toegevoegd( 20, @offset )
    @definitions = @recent_toegevoegd
    recent_blocks
  end

  def wijzigingen
    @offset = 0
    if params[:offset]
    	@offset = params[:offset]
    end
    @title = "Recente wijzigingen"
    get_recent_gewijzigd( 20, @offset )
    @definition_versions = @recent_gewijzigd
    recent_blocks
  end

  def reacties
    @offset = 0
    if params[:offset]
    	@offset = params[:offset]
    end
    @title = "Recente reacties"
    get_recent_reactions( 20, @offset )
    @reactions = @recent_reactions
    recent_blocks
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

  def index
    @title = "Welkom bij het Vlaams woordenboek"
    @definitions = random_sample( 5, true )
    @wotd = Wotd.find :first, :conditions => "date <= '#{Date.today}'", :order => 'date DESC'
    recent_blocks
  end

  def random
    @title = "Een willekeurige selectie"
    @definitions = random_sample( 10 )
    @definitions.sort!{ |a,b| b.positivevotes <=> a.positivevotes }
    recent_blocks
  end

  def top
    @offset = 0
    if params[:offset]
    	@offset = params[:offset]
    end
    @title = "Top woorden"
    get_top( 20, @offset )
    recent_blocks
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
    recent_blocks
  end

  def term
    @term = params[:id]
    @definitions = Definition.find(:all, :conditions => { :word => @term })
    @definitions.sort!{ |a,b| b.positivevotes <=> a.positivevotes }
    @title = @term
    recent_blocks
  end

  def zoek
    if params[:definition]
      @zoekquery = params[:definition][:word]
      #@definitions = Definition.find_by_contents( @zoekquery )
      @definitions = Definition.search( @zoekquery )
      @definition = Definition.new # gebruiken om in form nieuwe definitie toe te voegen
      @title = "Zoekresultaten voor '#{@zoekquery}'"
      recent_blocks
    else
      redirect_to :action => 'index'
    end
  end

  def toon
    @definition = Definition.find(params[:id])
    title
    recent_blocks
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
  end

  def geschiedenis
    @definition = Definition.find(params[:id])
    @definition_versions = @definition.versions.reverse
    title
    recent_blocks
  end

  def woordvandedag
    @offset = 0
    if params[:offset]
      @offset = params[:offset]
    end
    @title = "Vlaams woord van de dag"
    @wotds = Wotd.find :all, :conditions => "date <= '#{Date.today}'", :limit => 10, :order => 'date DESC', :offset => @offset
    if logged_in? && current_user.admin?
      @upcoming_wotds = Wotd.find :all, :conditions => "date > '#{Date.today}'", :order => 'date ASC'
    end
    recent_blocks
  end

  def woordvandedag_rss
    woordvandedag
    @feed_title = "Vlaams woord van de dag"
    @feed_url = "http://" + request.host_with_port + "/definities/woordvandedag"
    @feed_description = "Vlaams woord van de dag"
    response.headers['Content-Type'] = 'application/rss+xml'
    render :action => 'woordvandedag_rss', :layout => false
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

  def nieuw
    @definition = Definition.new
    @title = "Voeg een nieuwe definitie toe"
    recent_blocks
  end

  def creeer
    @definition = Definition.new(params[:definition])
    @definition.updated_by = self.current_user.id
    @definition.rating = 0;
    if @definition.save
      flash[:notice] = 'Uw nieuwe term werd succesvol in onze databank bewaard. Bedankt voor uw bijdrage!'
      expire_fragments_upon_save
      redirect_to :action => 'term', :id => @definition.word
    else
      recent_blocks
      render :action => 'nieuw'
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
      recent_blocks
      render :action => 'toon', :id => @definition
    end
  end

  def bewerk
    @definition = Definition.find(params[:id])
    title
    recent_blocks
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
      recent_blocks
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

end
