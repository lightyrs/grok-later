require 'duck_duck_go'

class Subject < ActiveRecord::Base

  before_create :set_abstract

  validates :name, :presence => true, :uniqueness => true

  has_many :curiosities, :dependent => :destroy
  has_many :users, :through => :curiosities

  def get_abstract
    duck = DuckDuckGo.new
    duck.zeroclickinfo(name)
  end

  private

  def set_abstract  
    self.abstract = get_abstract.abstract_text
  end
end
