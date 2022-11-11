xml.instruct!
xml.rss("version" => "2.0", "xmlns:dc" => "http://purl.org/dc/elements/1.1/") do
  xml.channel do
    xml.title @feed_title
    xml.link @feed_url
    xml.description @feed_description
    xml.language "en-gb"

    @wotds.each do |wotd|
      xml.item do
        xml.pubDate wotd.date.strftime("%a, %d %b %Y %H:%M:%S %z")
        xml.title h(wotd.definition.word)
        xml.link definition_url(wotd.definition)
        xml.guid definition_url(wotd.definition)
        xml.description do
          xml << format_user_content_for_xml(wotd.definition.description)
          xml << "![CDATA[ #{format_user_content_for_xml(wotd.definition.example)} ]]"
        end
      end
    end
  end
end
