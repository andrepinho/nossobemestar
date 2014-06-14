#coding: utf-8

class Like < ActiveRecord::Base
  belongs_to :likeable, polymorphic: true
  belongs_to :user
  validates_presence_of :likeable
  validates :user_id, :uniqueness => { :scope => [:likeable_type, :likeable_id] }, if: :user_id
end
