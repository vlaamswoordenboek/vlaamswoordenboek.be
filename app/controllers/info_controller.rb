class InfoController < ApplicationController
  def show
    @title = "Achtergrond bij het Vlaams Woordenboek"
  end

  def regios
    @title = "Vlaamse provincies en regio's"
  end

  def contact
    @title = "Contacteer ons"
  end

  def feeds
    @title = "RSS Feeds"
  end

  def updates
    @title = "Updates"
  end

  def voorwaarden
    @title = "Algemene Voorwaarden"
  end

  def uitspraak
    @title = "Uitspraakweergave"
  end
end
