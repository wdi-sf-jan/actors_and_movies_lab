class Movie < ActiveRecord::Base
  has_many :actors_movies, dependent: :destroy
  has_many :actors, through: :actors_movies
  has_many :comments, as: :commentable

  validates :title, :presence => true
  validates :year, {
              :presence => true,
              :numericality => {
                :greater_than_or_equal_to => 1000,
                :less_than_or_equal_to => 3000
              }
            }
end
