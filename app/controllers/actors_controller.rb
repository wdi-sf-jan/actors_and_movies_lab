class ActorsController < ApplicationController
  before_action :find_actor, only: [:edit, :show, :update, :destroy, :add_movie, :remove_movie]

  def index
    @actors = Actor.all
  end

  def create
    binding.pry
    Actor.create actor_params
    redirect_to actors_path
  end

  def new
    @actor = Actor.new
  end

  def edit
  end

  def show
    @movies = Movie.all - @actor.movies
    @comments = @actor.comments
  end

  def update
    @actor.update_attributes actor_params
    redirect_to @actor
  end

  def destroy
    @actor.destroy
    redirect_to actors_path
  end

  def add_movie
    @actor = Actor.find(params[:id])
    movie = Movie.find(movie_params[:id])
    unless @actor.movies.include? movie
      @actor.movies << movie
    end
    redirect_to @actor
  end

  def remove_movie
    movie = Movie.find(params[:movie_id])
    @actor.movies.delete(movie)
    redirect_to @actor
  end

  private
  def movie_params
    params.require(:movie).permit(:id, :title, :year)
  end

  def actor_params
    params.require(:actor).permit(:id, :name)
  end

  def find_actor
    @actor = Actor.find(params[:id])
  end
end
