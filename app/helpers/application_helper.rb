# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def localize( d, format = "%d %b %Y" )
    I18n.l(d, format => format)
  end

  def all_pagination_links( pages )
    html= ''
    if pagination_links( pages )
      if pages.current.previous
  		  html << link_to('&laquo; vorige pagina', {:params => params.merge('page' => pages.current.previous)}) << "&nbsp;|&nbsp;"
  	  end
  	  html << pagination_links( pages )
  	  if pages.current.next
  		  html << "&nbsp;|&nbsp;" << link_to('volgende pagina &raquo;', {:params => params.merge('page' => pages.current.next)})
  	  end
	  end
	  html
  end

end
