xml.instruct!
xml.rss("version" => "2.0", "xmlns:dc" => "http://purl.org/dc/elements/1.1/") do
  xml.channel do
    xml.title @feed_title
    xml.link @feed_url
    xml.description @feed_description
    xml.language "en-gb"

    @definition_versions.each do |definition_version|
      xml.item do
        xml.pubDate definition_version.updated_at.rfc822
        xml.title h(definition_version.word)
        xml.link definition_url(definition_version.definition.id)
        xml.guid definition_url(definition_version.definition.id)
        xml.description do
          xml << format_user_content_for_xml(definition_version.description)
          xml << "![CDATA[ #{format_user_content_for_xml(definition_version.example)} ]]"
        end
      end
    end
  end
end
