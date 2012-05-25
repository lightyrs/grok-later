require 'duck_duck_go'

class Subject < ActiveRecord::Base

  before_save :set_abstract

  validates :name, :presence => true, :uniqueness => true

  has_many :curiosities, :dependent => :destroy
  has_many :users, :through => :curiosities

  has_many :references, :dependent => :destroy
  has_many :links, :through => :references

  def get_abstract
    duck = DuckDuckGo.new
    duck.zeroclickinfo(name)
  end

  private

  def set_abstract  
    if abstract = get_abstract
      self.abstract = abstract.abstract_text ||
      self.abstract = abstract.related_topics.values.map(&:first).map(&:text)
    end
    self.destroy if self.abstract.empty?
  end
end
