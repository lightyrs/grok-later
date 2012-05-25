class Reference < ActiveRecord::Base

  belongs_to :subject
  belongs_to :link
end
