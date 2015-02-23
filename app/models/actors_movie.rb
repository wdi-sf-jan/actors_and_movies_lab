class ActorsMovie < ActiveRecord::Base
  belongs_to :actor
  belongs_to :movie

  validates :actor_id, uniqueness: {scope: :movie_id}
end
