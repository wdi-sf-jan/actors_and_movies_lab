class MoviesController < ApplicationController
  before_action :find_entity, only: [:edit, :show, :destroy, :add_actor, :remove_actor]
  
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
    @commentable = @entity
    @actors = Actor.all - @entity.actors
    @comments = @entity.comments
  end

  def update
    @entity.update_attributes movie_params
    redirect_to @entity
  end

  def destroy
    @entity.destroy
    redirect_to movies_path
  end

  def add_actor
    actor = Actor.find(actor_params[:id])
    unless @entity.actors.include? actor
      @entity.actors << actor
    end
    redirect_to @entity
  end

  def remove_actor
    @entity.actors.delete(Actor.find(params[:actor_id]))
    redirect_to @entity 
  end
end
