class Book < ActiveRecord::Base
  belongs_to :user
  has_many :sentences
  has_many :comments
end
