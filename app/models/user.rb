class User <ActiveRecord::Base
  has_secure_password
  has_many :books
  has_many :sentences, through: :books
  has_many :comments, through: :books

end
