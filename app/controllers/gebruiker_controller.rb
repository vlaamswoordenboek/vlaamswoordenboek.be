class GebruikerController < ApplicationController
  before_action :find_user, only: [:show, :reactions, :edits]

  def index
    @title = "Gebruikers"
    @topeditors = User.connection.select_all "select count(updated_by) as c, updated_by from definition_versions group by updated_by order by c desc limit 10;"
    @activeeditors = User.connection.select_all "select count(updated_by) as c, updated_by from definition_versions where updated_at > '#{1.week.ago.to_s(:db)}' group by updated_by order by c desc limit 10;"
    @topreactors = User.connection.select_all "select count(created_by) as c, created_by from reactions group by created_by order by c desc limit 10;"
    @recentusers = User.order('id DESC').limit(5)
  end

  def show
    @title = @user.login
    @reactions = Reaction.where(created_by: @user.id).order('created_at DESC').limit(5)
    @definition_versions = DefinitionVersion.where(updated_by: @user.id).order('updated_at DESC').limit(5)
  end

  def reactions
    @title = 'Reacties van ' + @user.login
    @reactions = Reaction.where(created_by: @user.id).
                 order('created_at DESC').
                 paginate(page: params['page'] || 1, per_page: 5)
  end

  def edits
    @title = 'Wijzigingen door ' + @user.login
    @definition_versions = DefinitionVersion.where(updated_by: @user.id).
                           order('updated_at DESC').
                           paginate(page: params['page'] || 1, per_page: 5)
  end

  private

  def find_user
    @user = User.find_by(login: params[:id])
  end
end
