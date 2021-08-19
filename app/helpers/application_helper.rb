# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def localize(d, format = "%d %b %Y")
    I18n.l(d, format: format)
  end

  def format_user_content(text)
    return "" if text.blank?

    coder = HTMLEntities.new

    RedCloth.new(text).
      to_html.
      gsub(/\[(.*?)\]/) do |m, a|
        link_to(coder.decode(m[1..-2]), term_definitions_path(term: coder.decode(m[1..-2]).html_safe))
      end.
      html_safe
  end

  def format_user_content_for_xml(text)
    return "" if text.blank?

    coder = HTMLEntities.new
    RedCloth.new(text).
      to_html.
      gsub(/\[(.*?)\]/) do |m|
        link_to(coder.decode(m[1..-2]).html_safe, term_definitions_path(term: coder.decode(m[1..-2]).html_safe))
      end.
      html_safe
  end
end

module ActionView # nodoc
  module Helpers
    module ActiveRecordHelper
      def error_messages_for(object_name, options = {})
        options = options.symbolize_keys
        object = instance_variable_get("@#{object_name}")
        unless object.errors.empty?
          content_tag("div",
                      content_tag(
                        options[:header_tag] || "h2",
                        "Onvolledig formulier"
                      ) +
                      content_tag("p", "Het formulier is onvolledig ingevuld:") +
                      content_tag("ul", object.errors.full_messages.collect { |msg| content_tag("li", msg) }),
                      "id" => options[:id] || "errorExplanation", "class" => options[:class] || "errorExplanation")
        end
      end
    end
  end
end
