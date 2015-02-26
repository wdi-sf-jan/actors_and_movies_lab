class ActorsController < ApplicationController
  before_action :find_entity, only: [:edit, :show, :update, :destroy, :add_movie, :remove_movie]

  def index
    @actors = Actor.all
  end

  def create
    Actor.create actor_params
    redirect_to actors_path
  end

  def new
    @entity = Actor.new
  end

  def edit
  end

  def show
    @commentable = @entity
    @movies = Movie.all - @entity.movies
    @comments = @entity.comments
  end

  def update
    @entity.update_attributes actor_params
    redirect_to @entity
  end

  def destroy
    @entity.destroy
    redirect_to actors_path
  end

  def add_movie
    movie = Movie.find(movie_params[:id])
    unless @entity.movies.include? movie
      @entity.movies << movie
    end
    redirect_to @entity
  end

  def remove_movie
    movie = Movie.find(params[:movie_id])
    @entity.movies.delete(movie)
    redirect_to @entity
  end
end
