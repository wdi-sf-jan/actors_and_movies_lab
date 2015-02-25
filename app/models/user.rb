class User < ActiveRecord::Base
  has_secure_password

  has_many :comments

  validates :username, presence: true, uniqueness: true

  def confirm(password_param)
    authenticate(password_param)
  end
end
