require 'duck_duck_go'

class Subject < ActiveRecord::Base

  before_create :set_abstract

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
      correct_case(abstract.heading)
      self.abstract = parse_ddg_abstract(abstract).to_s
    end
  end

  def parse_ddg_abstract(abstract)
    abstract.abstract_text ||
    abstract.definition ||
    abstract.related_topics.values.map(&:first).map(&:text)
  end

  def correct_case(ddg_heading)
    return ddg_heading unless ddg_heading.present?
    self.name = ddg_heading if self.name.match(/\A#{Regexp.quote(ddg_heading)}\z/i)
  end
end
