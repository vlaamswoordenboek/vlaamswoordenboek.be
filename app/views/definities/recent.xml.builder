xml.instruct!
xml.rss("version" => "2.0", "xmlns:dc" => "http://purl.org/dc/elements/1.1/") do
  xml.channel do
    xml.title @feed_title
    xml.link @feed_url
    xml.description @feed_description
    xml.language "en-gb"

    @definitions.each do |definition|
      xml.item do
        xml.pubDate definition.updated_at.rfc822
        xml.title h(definition.word)
        xml.link definition_url(definition.id)
        xml.guid definition_url(definition.id)
        xml.description do
          xml << textilize( definition.description ).gsub(/\[(.*?)\]/, '\1' ).gsub(/</,'&lt;').gsub(/>/,'&gt;')
	        xml << "&lt;i&gt;" + textilize( definition.example ).gsub(/\[(.*?)\]/, '\1' ).gsub(/</,'&lt;').gsub(/>/,'&gt;') + "&lt;/i&gt;"
        end
      end
    end
  end
end
