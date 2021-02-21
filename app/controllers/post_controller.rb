class PostController < ApplicationController
  before_action :login_required
  include AutoComplete
  auto_complete_for :user, :login

  def index
    @title = "Postvak: Binnengekomen berichten"
    @messages = Message.where(receiver: current_user).order(created_at: :desc)
  end

  def outbox
    @title = "Postvak: Uitgaande berichten"
    @messages = Message.where(sender: current_user).order(created_at: :desc)
  end

  def show
    @message = Message.find params[:id]
    if current_user != @message.sender && current_user != @message.receiver
      redirect_to posts_path
    end
    if current_user == @message.receiver
      @message.read = true
      @message.save!
    end
    @title = @message.title
  end

  def new
    @title = "Nieuw bericht"
    @message = Message.new
    @message.sender = current_user
    @message.receiver = User.find_by(login: params[:id])&.id
  end

  def create
    @message = Message.new(message_params)
    @message.sender = self.current_user
    receiver = User.find_by(login: params[:message][:receiver_login])
    if receiver
      @message.receiver = receiver
      if @message.save
        flash[:notice] = 'Uw nieuw bericht werd succesvol verzonden.'
        redirect_to outbox_posts_path
      else
        render 'new'
      end
    else
      flash[:notice] = 'Het bericht is niet verzonden, omdat uw bestemmeling (' + params[:message][:to_user] + ') geen geregistreerde gebruiker is van het Vlaams woordenboek.'
      render 'new'
    end
  end

  private

  def message_params
    params.require(:message).permit(
      :receiver_login,
      :title,
      :body
    )
  end
end
