class User < ActiveRecord::Base

  has_many :identities, :dependent => :destroy

  def avatar
    identities.find(:all, :order => "logged_in_at desc", :limit => 1).first.avatar
  end
end
