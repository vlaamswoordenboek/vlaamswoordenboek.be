class DefinitiesController < ApplicationController
  before_action :login_required, :only => [:new, :create, :edit, :update, :destroy, :add_reaction, :delete_reaction, :new_wotd]

  before_action :find_definition, only: [:toon, :show, :edit, :update, :history, :destroy, :add_reaction, :thumbsup, :new_wotd]
  before_action :set_title_from_definition, only: [:show, :edit, :update, :history, :add_reaction]

  before_action :find_or_init_voter, only: [:thumbsup]

  include AutoComplete
  auto_complete_for :definition, :q, search_column: 'word'

  def index
    @title = "Welkom bij het Vlaams woordenboek"
    @random_definitions = Definition.preload(:created_by, :last_edited_by, :wotds).random_sample(count: 5, needs_positive_rating: true)
  end

  def search
    unless params[:definition] && params[:definition][:q]
      redirect_to root_path
      return
    end

    @q = params[:definition][:q]
    @definitions = Definition.preload(:created_by, :last_edited_by, :wotds).search @q
    @title = "Zoekresultaten voor '#{@q}'"
  end

  def prefix
    @begin = params[:prefix]
    unless read_fragment(:controller => 'definities', :action => 'prefix', :prefix => @begin, :part => 'lijst')

      prefixes_to_check = ('a'..'z').map { |letter| "\"#{@begin}#{letter}\"" }
      @langer_counts = Definition.
        joins("JOIN JSON_TABLE('[#{prefixes_to_check.join(',')}]', '$[*]' COLUMNS(prefix VARCHAR(255) PATH '$')) prefixes ON definitions.word LIKE CONCAT(prefixes.prefix, '%')").
        order('prefixes.prefix').
        group('prefixes.prefix').
        count

      @words = Definition.where('word LIKE ?', "#{@begin}%").
               order(word: :asc).
               preload(:created_by, :last_edited_by, :wotds).
               distinct.
               pluck(:word)
    end
    @title = "Woorden die beginnen met '" + @begin + "'"
  end

  def woordvandedag
    @title = "Vlaams woord van de dag"

    @offset = params[:offset].to_i || 0
    @wotds = Wotd.all.past.preload(definition: [:created_by, :last_edited_by, :wotds]).limit(20).offset(@offset)
    if logged_in? && current_user.admin?
      @upcoming_wotds = Wotd.where("date > ?", Date.today).order('date ASC')
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
    if logged_in? && current_user.admin?
      @wotds = Wotd.where(definition: @definition)
      @wotd_dates = []

      (Date.today..(Date.today+50)).each do |date|
        datestr = date.strftime("%Y-%m-%d")
        wotd = Wotd.find_by(date: datestr)
        if !wotd
          @wotd_dates << datestr
        end
      end
    end

    render 'toon'
  end

  alias :toon :show

  def term
    @term = params[:term]
    @definitions = Definition.where(word: @term).preload(:created_by, :last_edited_by, :wotds).order(positivevotes: :desc)

    @title = @term
  end

  def random
    @title = "Een willekeurige selectie"
    @random_definitions = Definition.random_sample(count: 10).preload(:created_by, :last_edited_by, :wotds).order(:positivevotes)
  end

  def recent
    @offset = 0
    if params[:offset]
      @offset = params[:offset]
    end
    @title = "Recente toevoegingen"
    @recent_definitions = Definition.preload(:created_by, :last_edited_by, :wotds).recent(count: 20, offset: @offset)
  end

  def wijzigingen
    @offset = 0
    if params[:offset]
      @offset = params[:offset]
    end
    @title = "Recente wijzigingen"
    @definition_versions = DefinitionVersion.recent(count: 20, offset: @offset)
  end

  def reacties
    @offset = 0
    if params[:offset]
      @offset = params[:offset]
    end
    @title = "Recente reacties"
    @reactions = Reaction.recent(count: 20, offset: @offset)
  end

  def top
    @offset = 0
    if params[:offset]
      @offset = params[:offset]
    end
    @title = "Top woorden"

    @top_definitions = Definition.preload(:created_by, :last_edited_by, :wotds).top(count: 20, offset: @offset)
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
      redirect_to term_definitions_path(@definition.word)
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    @definition.updated_by = self.current_user.id
    if @definition.update(edit_definition_params)
      flash[:notice] = 'Uw aanpassing werd succesvol in onze databank bewaard. Bedankt voor uw bijdrage.'
      redirect_to term_definitions_path(term: @definition.word)
    else
      render 'edit'
    end
  end

  def destroy
    if self.current_user.admin?
      @definition.destroy
      flash[:notice] = 'Uw beschrijving werd verwijderd.'
    else
      flash[:notice] = 'Woorden kunnen niet worden verwijderd'
    end
    redirect_to term_definitions_path(term: @definition.word)
  end

  def history
    @definition_versions = @definition.versions.reverse
  end

  def thumbsup
    unless Vote.where(definition_id: @definition, voter_id: @voter.id).exists?
      @vote = Vote.create(:definition => @definition, :voter => @voter, :value => 1)
      @definition.increment!(:positivevotes)
    end

    respond_to do |format|
      format.js { render 'thumbsup' }
      format.html { redirect_to definition_path(@definition) }
    end
  end

  def add_reaction
    @reaction = Reaction.new(reaction_params)
    @reaction.definition = @definition
    @reaction.created_by = self.current_user.id
    if @reaction.save
      flash[:notice] = 'Bedankt voor uw reactie!'
      redirect_to definition_path(@definition)
    else
      render 'toon'
    end
  end

  def delete_reactie
    @reaction = Reaction.find(params[:reaction_id])
    if self.current_user.admin?
      @reaction.destroy
      flash[:notice] = 'Uw reactie werd verwijderd.'
    else
      flash[:notice] = 'Reacties kunnen niet worden verwijderd'
    end
    redirect_to definition_path(@reaction.definition)
  end

  def new_wotd
    if logged_in? && current_user.admin?
      @wotd = Wotd.new(date: params[:date], definition: @definition)
      if @wotd.save
        flash[:notice] = 'Definitie bewaard voor WOTD'
      end
    end
    redirect_to definition_path(@definition)
  end

  def recent_rss
    @definitions = Definition.recent(count: 10)
    @feed_title = "Vlaams woordenboek: Recente toevoegingen"
    @feed_url = "http://" + request.host_with_port
    @feed_description = "Recent toegevoegde woorden aan het Vlaams Woordenboek"
    response.headers['Content-Type'] = 'application/rss+xml'
    render 'recent'
  end

  def wijzigingen_rss
    @definition_versions = DefinitionVersion.recent(count: 10)
    @feed_title = "Vlaams woordenboek: Recente wijzigingen"
    @feed_url = "http://" + request.host_with_port
    @feed_description = "Recent toegevoegde woorden aan het Vlaams Woordenboek"
    response.headers['Content-Type'] = 'application/rss+xml'
    render 'recent_changes'
  end

  private

  def set_title_from_definition
    @title = @definition.word
  end

  def find_definition
    @definition = Definition.find(params[:id])
  end

  def find_or_init_voter
    @voter ||= if cookies[:voter]
                 Voter.find cookies[:voter]
               else
                 current_voter = Voter.create!
                 cookies[:voter] = { :value => current_voter.id.to_s, :expires => 1.year.from_now }
                 current_voter
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

  def edit_definition_params
    params.require(:definition).permit(
      :word,
      :properties,
      :description,
      :regio,
      :example
    )
  end

  def reaction_params
    params.require(:reaction).permit(
      :title,
      :body
    )
  end
end
