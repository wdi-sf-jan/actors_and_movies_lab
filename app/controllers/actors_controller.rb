class ActorsController < ApplicationController
  def index
    @actors = Actor.all
  end

  def create
    form_params = params.require(:actor).permit(:name)
    actor = Actor.create form_params
    redirect_to actors_path
  end

  def new
    @actor = Actor.new
  end

  def edit
    @actor = Actor.find(params[:id])
  end

  def show
    @actor = Actor.find(params[:id])
  end

  def update
    form_params = params.require(:actor).permit(:name)
    actor = Actor.find(params[:id])
    actor.update_attributes form_params
    redirect_to actor_path(actor)
  end

  def destroy
    actor = Actor.find(params[:id])
    actor.destroy
    redirect_to actors_path
  end
end
