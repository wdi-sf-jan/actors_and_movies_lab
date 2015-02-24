class MoviesController < ApplicationController
  before_action :find_movie, only: [:edit, :show, :destroy, :add_actor, :remove_actor]
  
  def index
    @movies = Movie.all
  end

  def create
    Movie.create movie_params 
    redirect_to movies_path
  end

  def new
    @movie = Movie.new
  end

  def edit
  end

  def show
    @actors = Actor.all - @movie.actors
  end

  def update
    @movie.update_attributes movie_params
    redirect_to @movie
  end

  def destroy
    @movie.destroy
    redirect_to movies_path
  end

  def add_actor
    actor = Actor.find(actor_params[:id])
    unless @movie.actors.include? actor
      @movie.actors << actor
    end
    redirect_to @movie
  end

  def remove_actor
    @movie.actors.delete(Actor.find(params[:actor_id]))
    redirect_to @movie 
  end

  private
  def movie_params
    params.require(:movie).permit(:title, :year)
  end

  def actor_params
    params.require(:actor).permit(:id, :name)
  end

  def find_movie
    @movie = Movie.find(params[:id])
  end
end
