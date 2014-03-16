class Click < ActiveRecord::Base
  belongs_to :ad
  validates_presence_of :ip
end
