class ForumController < ApplicationController

  before_action :login_required, :only => [ :creeeronderwerp, :reageer ]

  def index
    @title = "Forums"
    @forums = Forum.find( :all )
  end

  def forum
    @forum = Forum.find( params[:id] )
    @title = 'Forum &#187; ' + @forum.title
  end

  def onderwerp
    @forumtopic = Forumtopic.find( params[:id] )
    @title = @forumtopic.title
    @trail =
      '<a href="/forum">Forum</a> &#187; ' +
      '<a href="/forum/forum/' + @forumtopic.forum.id.to_s + '">' + @forumtopic.forum.title + '</a> &#187; ' +
      @forumtopic.title
  end

  def nieuwonderwerp
    @forumtopic = Forumtopic.new
    @title = 'Start een nieuw forum onderwerp'
  end

  def creeeronderwerp
    @forumtopic = Forumtopic.new(params[:forumtopic])
    @forumtopic.user = current_user
    if @forumtopic.save
      flash[:notice] = 'Uw nieuwe discussieonderwerp werd succesvol bewaard. Bedankt voor uw bijdrage!'
      redirect_to :action => 'onderwerp', :id => @forumtopic
    else
      render :action => 'nieuw'
    end
  end

  def reageer
    @forumtopic = Forumtopic.find( params[:id] )
    @comment = Comment.new(params[:comment])
    @comment.resource = @forumtopic
    @comment.user = current_user
    if @comment.save
      flash[:notice] = 'Uw reactie werd succesvol bewaard. Bedankt voor uw bijdrage!'
      redirect_to :action => 'onderwerp', :id => @forumtopic
    else
      flash[:notice] = 'Er was een probleem bij het bewaren van uw reactie.'
      render :action => 'onderwerp', :id => @forumtopic
    end
  end

end
