class PostController < ApplicationController

  before_action :login_required
  include AutoComplete
  auto_complete_for :user, :login

  def in
    @title = "Postvak: Binnengekomen berichten"
    @messages = Message.find( :all, :conditions => ["to_user = ?", current_user ], :order => 'created_at DESC' )
  end

  def uit
    @title = "Postvak: Uitgaande berichten"
    @messages = Message.find( :all, :conditions => ["from_user = ?", current_user ], :order => 'created_at DESC' )
  end

  def toon
    @message = Message.find( params[ :id ] )
    if ( current_user != @message.sender ) && ( current_user != @message.receiver )
      redirect_to :controller => 'post', :action => 'in'
    end
    if ( current_user == @message.receiver )
      @message.read = true;
      @message.save!
    end
    @title = @message.title
  end

  def nieuw
    @title = "Nieuw bericht"
    @message = Message.new
    @message.from_user = current_user
    @message.to_user = User.find_by_login( params[ :id ] ).id
  end

  def creeer
    @message = Message.new(params[:message])
    @message.from_user = self.current_user.id
    receiver = User.find_by_login( params[:user][:login] );
    if receiver
      @message.to_user = receiver.id;
      if @message.save
        flash[:notice] = 'Uw nieuw bericht werd succesvol verzonden.'
        redirect_to :controller => 'post', :action => 'uit'
      else
        render :action => 'nieuw'
      end
    else
      flash[:notice] = 'Het bericht is niet verzonden, omdat uw bestemmeling (' + params[:user][:login] + ') geen geregistreerde gebruiker is van het Vlaams woordenboek.'
      render :action => 'nieuw'
    end
  end


end
