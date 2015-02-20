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
  end

  def show
  end

  def update
  end

  def destroy
  end
end
