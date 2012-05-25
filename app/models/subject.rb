class Subject < ActiveRecord::Base

  validates :name, :presence => true, :uniqueness => true

  has_many :curiosities, :dependent => :destroy
  has_many :users, :through => :curiosities
end
