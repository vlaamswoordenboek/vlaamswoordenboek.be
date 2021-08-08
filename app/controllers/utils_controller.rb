class UtilsController < ApplicationController
  ROBOTS_TXT_BETA = <<~ROBOTS.freeze
  User-Agent: *
  Disallow: /
ROBOTS

  ROBOTS_TXT_PROD = <<~ROBOTS.freeze
  User-Agent: *
  Allow: /
  Crawl-Delay: 1
ROBOTS

  def robots
    if ENV['VLAAMSWOORDENBOEK_BETA']
      render plain: ROBOTS_TXT_BETA
    else
      render plain: ROBOTS_TXT_PROD
    end
  end
end
