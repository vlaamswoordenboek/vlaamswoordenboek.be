# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  layout "application"

  auto_complete_for :definition, :word

  include AuthenticatedSystem
  before_action do |c|
    @current_user = (c.session[:user] && User.find_by_id(c.session[:user])) || :false
  end

  protect_from_forgery
end
