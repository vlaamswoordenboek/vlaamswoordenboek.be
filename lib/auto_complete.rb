module AutoComplete
  def self.included(base)
    base.extend(ClassMethods)
  end

  #
  # Example:
  #
  #   # Controller
  #   class BlogController < ApplicationController
  #     auto_complete_for :post, :title
  #   end
  #
  #   # View
  #   <%= text_field_with_auto_complete :post, title %>
  #
  # By default, auto_complete_for limits the results to 10 entries,
  # and sorts by the given field.
  #
  # auto_complete_for takes a third parameter, an options hash to
  # the find method used to search for the records:
  #
  #   auto_complete_for :post, :title, :limit => 15, :order => 'created_at DESC'
  #
  # For help on defining text input fields with autocompletion,
  # see ActionView::Helpers::JavaScriptHelper.
  #
  # For more examples, see script.aculo.us:
  # * http://script.aculo.us/demos/ajax/autocompleter
  # * http://script.aculo.us/demos/ajax/autocompleter_customized
  module ClassMethods
    def auto_complete_for(object, method, options = {})
      table = object.to_s.camelize.constantize.table_name
      search_column = options.delete(:search_column) || method

      define_method("auto_complete_for_#{object}_#{method}") do
        @items = object.to_s.camelize.constantize.
                 where("LOWER(#{search_column}) LIKE ?", "%#{params[object][method].downcase}%").
                 limit(10)

        render inline: "<%= auto_complete_result @items, '#{search_column}' %>"
      end
    end
  end
end
