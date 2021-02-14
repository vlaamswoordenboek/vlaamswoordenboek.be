# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  layout "standard"

  auto_complete_for :definition, :word

  include AuthenticatedSystem
  before_filter do |c|
    @current_user = (c.session[:user] && User.find_by_id(c.session[:user])) || :false
  end

  # Pick a unique cookie name to distinguish our session data from others'
  session :session_key => '_vlaamswoordenboek_session_id'

end
