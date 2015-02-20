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
  end

  def update
    form_data = params.require(:movie).permit(:title, :year)
    movie = Movie.find(params[:id])
    movie.update_attributes form_data
    redirect_to movie_path(movie)
  end

  def destroy
  end
end
