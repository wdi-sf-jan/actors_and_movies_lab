class MoviesController < ApplicationController
  def index
    @movies = Movie.all
  end

  def create
    form_data = params.require(:movie).permit(:title, :year)
    Movie.create form_data
    redirect_to movies_path
  end

  def new
    @movie = Movie.new
  end

  def edit
    @movie = Movie.find(params[:id])
  end

  def show
    @movie = Movie.find(params[:id])
    @actors = Actor.all - @movie.actors
  end

  def update
    form_data = params.require(:movie).permit(:title, :year)
    movie = Movie.find(params[:id])
    movie.update_attributes form_data
    redirect_to movie_path(movie)
  end

  def destroy
    movie = Movie.find(params[:id])
    movie.destroy
    redirect_to movies_path
  end

  def add_actor
    actor_params = params.require(:actor).permit(:id)
    movie = Movie.find(params[:id])
    actor = Actor.find(actor_params[:id])
    unless movie.actors.include? actor
      movie.actors << actor
    end
    redirect_to movie_path(movie)
  end

  def remove_actor
    movie = Movie.find(params[:id])
    actor = Actor.find(params[:actor_id])
    movie.actors.delete(actor)
    redirect_to movie_path(movie)
  end
end
