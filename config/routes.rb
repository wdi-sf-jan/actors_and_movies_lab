Rails.application.routes.draw do

  resources :movies do
    post '/comments' => 'comments#create', as: 'comments'
  end
  resources :actors do
    post '/comments' => 'comments#create', as: 'comments'
  end

  post '/movies/:id/actors/new' => 'movies#add_actor', as: :add_actor
  delete 'movies/:id/actors/:actor_id' => 'movies#remove_actor', as: :remove_actor

  post '/actors/:id/movies/new' => 'actors#add_movie', as: :add_movie
  delete '/actors/:id/movies/:movie_id' => 'actors#remove_movie', as: :remove_movie

  root 'site#index'

end
