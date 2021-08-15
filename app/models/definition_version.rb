class DefinitionVersion < ActiveRecord::Base
  belongs_to :definition, counter_cache: 'versions_count'
  belongs_to :editor, class_name: 'User', foreign_key: 'updated_by'

  def <=>(other)
    word <=> other.word
  end

  def self.recent(count: 10, offset: 0)
    self.order('updated_at DESC').limit(count).offset(offset)
  end
end
