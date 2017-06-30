class Book < ActiveRecord::Base
  belongs_to :user
  has_many :sentences, dependent: :destroy
  has_many :comments, dependent: :destroy
end
