class AccountController < ApplicationController
  # If you want "remember me" functionality, add this before_filter to Application Controller
  before_action :login_from_cookie
  before_action :login_required, only: [:edit, :update]

  def login
    self.current_user = User.authenticate(params[:login], params[:password])
    if logged_in?
      if params[:remember_me] == "1"
        self.current_user.remember_me
        cookies[:auth_token] = { :value => self.current_user.remember_token , :expires => self.current_user.remember_token_expires_at }
      end
      flash[:notice] = "Ge zijt succesvol ingelogd"

      redirect_to root_path
    end
  end

  def logout
    self.current_user.forget_me! if logged_in?
    cookies.delete :auth_token
    reset_session
    flash[:notice] = "Ge zijt nu uitgelogd."
    redirect_back_or_default(root_path)
  end

  def new
    @user = User.new
    render 'new'
  end

  def create
    @user = User.new(create_user_params)
    if @user.save
      self.current_user = @user
      flash[:notice] = "Merci om u in te schrijven! Ge kunt nu nieuwe woorden aan het woordenboek toevoegen."
      redirect_to root_path
    else
      render 'new'
    end
  end

  def edit
    @title = "Mijn instellingen"
    render 'edit'
  end

  def update
    if current_user.update(edit_user_params)
      flash[:notice] = 'Uw aanpassing werd succesvol in onze databank bewaard.'
      redirect_to edit_account_path
    else
      render 'edit'
    end
  end

  private

  def create_user_params
    params.require(:user).permit(
      :login,
      :email,
      :password,
      :password_confirmation
    )
  end

  def edit_user_params
    params.require(:user).permit(
      :details
    )
  end
end
