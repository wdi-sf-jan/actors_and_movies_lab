class Actor < ActiveRecord::Base
  has_many :actors_movies, dependent: :destroy
  has_many :movies, through: :actors_movies
end
