class AccountController < ApplicationController
  # If you want "remember me" functionality, add this before_filter to Application Controller
  before_filter :login_from_cookie

  # say something nice, you goof!  something sweet.
  def index
    redirect_to(:action => 'signup') unless logged_in? || User.count > 0
    redirect_to(:controller => 'definities', :action => 'index')
  end

  def login
    return unless request.post?
    self.current_user = User.authenticate(params[:login], params[:password])
    if logged_in?
      if params[:remember_me] == "1"
        self.current_user.remember_me
        cookies[:auth_token] = { :value => self.current_user.remember_token , :expires => self.current_user.remember_token_expires_at }
      end
      redirect_back_or_default(:controller => 'definities', :action => 'index')
      flash[:notice] = "Ge zijt succesvol ingelogd"
    end
  end

  def signup
    flash[:notice] = 'Omdat we even geterroriseerd worden door spammers kan je momenteel geen account aanmaken. '
    redirect_to(:controller => 'definities', :action => 'index')
    @user = User.new(params[:user])
    return unless request.post?
    @user.save!
    self.current_user = @user
    redirect_back_or_default(:controller => 'definities', :action => 'index')
    flash[:notice] = "Merci om u in te schrijven! Ge kunt nu nieuwe woorden aan het woordenboek toevoegen."
  rescue ActiveRecord::RecordInvalid
    render :action => 'signup'
  end
  
  def logout
    self.current_user.forget_me if logged_in?
    cookies.delete :auth_token
    reset_session
    flash[:notice] = "Ge zijt nu uitgelogd."
    redirect_back_or_default( :controller => 'definities', :action => 'index' )
  end
  
  def instellingen
    if logged_in?
        @title = "Mijn instellingen"
        @user = User.find( current_user )
    else
        redirect_back_or_default( :controller => 'definities', :action => 'index' )
    end
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:notice] = 'Uw aanpassing werd succesvol in onze databank bewaard. '
      redirect_to :action => 'instellingen'
    else
      render :action => 'instellingen'
    end
  end

end
