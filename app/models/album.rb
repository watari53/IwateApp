class Album < ActiveRecord::Base
  geocoded_by :address
  after_validation :geocode

  has_many :pictures
  has_many :tags
  accepts_nested_attributes_for :pictures
end
