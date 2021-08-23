# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  layout "application"

  before_action :redirect_to_www

  include AuthenticatedSystem
  before_action do |c|
    @current_user = (c.session[:user] && User.find_by_id(c.session[:user])) || :false
  end

  protect_from_forgery

  private

  def redirect_to_www
    if request.host == 'vlaamswoordenboek.be' && request.method == 'GET'
      redirect_to "https://www.vlaamswoordenboek.be#{request.fullpath}", status: :moved_permanently
    end
  end
end
