Actors and Movies
=================

Create the project
------------------

I'm going to create a Rails application. I know that `rails new` is a
command that will create a new project (and directory) and I've heard
that `rails new -h` will list the available options. So after
consulting the help menu I decide to run

```sh
rails new actors_and_movies -TBd postgresql
```

to create a new project without tests (-T), without immediately
running `bundle` (-B, since we're going to add some more dependencies
before the install step), and a postgres database (-d postgresql).

Start with movies
-----------------

To start, I want to get a site up and running with all the CRUD
operations for movies. I know I'll need routes, a model, and a
controller. My mind also knows that I'll need a migration, but I
remember that Rails will give that to me when I generate the model.

__The Model__

I'll start with the model. I know I want to store movie titles as well
as the year they were released. I also know the `rails generate` (or
`rails g`) command will create models (& migrations) for me. I run

```sh
rails generate model movie title:string year:integer
```

which generates both `db/migrate/20150219222418_create_movies.rb` and
`app/models/movie.rb`. I open them in my text editor to make sure they
look ok. If they don't, or I determine I made a mistake, I can run
`rails destroy model movie` to undo the previous command, which
deletes the model and migration files.

__The Routes__

I forget which routes I'll need. Luckily, Rails `resources`
autogenerates routes for me.

In `config/routes.rb`, I add the line:

```ruby
resources :movies
```

To understand what I just did, I run `rake routes` in the terminal to
see the URLs that my app now needs to support.

```sh
$ rake routes
    Prefix Verb   URI Pattern                Controller#Action
    movies GET    /movies(.:format)          movies#index
           POST   /movies(.:format)          movies#create
 new_movie GET    /movies/new(.:format)      movies#new
edit_movie GET    /movies/:id/edit(.:format) movies#edit
     movie GET    /movies/:id(.:format)      movies#show
           PATCH  /movies/:id(.:format)      movies#update
           PUT    /movies/:id(.:format)      movies#update
           DELETE /movies/:id(.:format)      movies#destroy
```

__The Controller__

I now have a model and a migration which take care of storing my
movies in the database.  I also have routes which take care of
defining the URLs that my site will provide. I now need a controller
to link them together.

I forget the arguments required for generating a controller so I run
`rails g controller` to see the help menu and an example. I pay
attention to the pluralization. I know I want actions to correspond to
all the routes generated in the previous step, so I reference them
in the following command:

```sh
rails g controller Movies index create new edit show update destroy
```

This generates lots of files and I take some notice of what files and
where they were saved.  Unfortunately, I notice that this added a bunch
of routes to my `config/routes.rb` file. I already took care of that
by using `resources` so I go and delete the newly generated lines from
`config/routes.rb`. Remember, if you make a mistake here, you can
undo the generation with `rails destroy controller Movies`. However,
that won't delete the routes so you'll still need to do that manually.

__Try starting server__

I want to see if I did all that properly, so I'm going to start my
server. I run the following in the Terminal:

```sh
rails server
```

When I navigate to
[http://localhost:3000/movies](http://localhost:3000/movies) I get an
error message telling me I need to run the following, which I do.

```sh
rake db:create
rake db:migrate
```

__CRUD Methods__

Now that we have a skeleton project setup, I fill out the empty
actions (i.e., controller methods) in
`app/controllers/movies_controller.rb` and the corresponding .erb
template files in `app/views/movies/`.

_movies#index_

I start with `MoviesController#index` and `index.html.erb`.

```ruby
def index
  @movies = Movie.all
end
```

```erb
<h1>Movies</h1>
<ul>
  <% @movies.each do |film| %>
  <li><%= film.title %> (<%= film.year %>)</li>
  <% end %>
</ul>
<%= link_to "Add movie", new_movie_path %>
```

This grabs all the movies from the database and passes them to the
template. It should look familiar from our time with Sinatra and
ActiveRecord. The new Rails feature I'm using is `link_to` which
generates an `<a>` tag with a link automatically pointing to route
with the `new_movie` prefix (as listed when I run `rake routes`
in the terminal).

_movies#new_

I move onto `MoviesController#new` and `new.html.erb`.

```ruby
def new
  @movie = Movie.new
end
```

```erb
<h1>Add a new movie</h1>
<%= form_for @movie do |f| %>
  <%= f.text_field :title, :placeholder => "Title" %>
  <%= f.text_field :year, :placeholder => "Year" %>
  <%= f.submit "Add" %>
<% end %>
```

Here the new Rails feature I'm using is `form_for`, the distant cousin
of `link_to`. It takes a Movie (the placeholder one I created with the
line `@movie = Movie.new`) and generates a `<form>` for it. (This
placeholder movie is never saved to the database. It is only
constructed for the use of creating the form then discarded).

_movies#create_

Now that I have a form for adding a new movie, I need to write the
`MoviesController#create` action which will actually save my new movie
to the database.

```ruby
def create
  form_data = params.require(:movie).permit(:title, :year)
  Movie.create form_data
  redirect_to movies_path
end
```

For security purposes Rails makes me `permit` certain fields from the
form. The data gets sent from the browser as `{:movie => {:title
"abc", :year => "xyz"}}` and I only want the :title and :year fields
from the :movie object. I use that data to create a new movie in the
database. I then redirect to the prefix which takes me to the movies
index page. I determine which prefix path that is by looking at the
output of `rake routes` again.

_movies#show_

Show the details of an individual movie by adding code to
`MoviesController#show` and `show.html.erb`:

```ruby
def show
  @movie = Movie.find(params[:id])
end
```

```erb
<h1><%= @movie.title %></h1>
<p><%= @movie.year %></p>
<%= link_to "Back to movies", movies_path %>
```

I also add a link to the show page from the `index.html.erb`:

```ruby
<li><%= link_to "#{film.title} (#{film.year})", film %></li>
```

Here `"#{film.title} (#{film.year})"` is the text of the link
(e.g. "The Big Lebowski (1999)"). If I put the `film` instance as
the second argument, Rails knows how to link to it
automatically. Nice.

_movies#edit_

Make it so I can click on an "Edit" link on the movies#show page and
be taken to the movies#edit page which will display a form that can be
used to edit the movie.

```ruby
def edit
  @movie = Movie.find(params[:id])
end
```

```erb
<h1>Edit</h1>
<%= form_for @movie do |f| %>
  <%= f.text_field :title %>
  <%= f.text_field :year %>
  <%= f.submit "Update" %>
<% end %>
```

I use `form_for` again, just like I did in `new.html.erb`. The
difference is that this time Rails knows the movie is already in the
database so it generates an edit form. Nice.

I also add a link to the edit page in `show.html.erb`:

```erb
<%= link_to "Edit", edit_movie_path(@movie) %>
```

Here we're using `link_to` again, linking to the path with the
`edit_movie` prefix as detailed when I look at the output of `rake
routes`. This time I have to tell Rails *which* movie's edit page I
want to go to by passing `@movie` to `edit_movie_path`. Any prefix in
the output of `rake routes` that has a parameter in its URI pattern
(e.g., `/:id/`) needs to passed an additional parameter like this.

_movies#update_

`MoviesController#update` needs to take the updated information from
the form and save it to the database.

```ruby
def update
  form_data = params.require(:movie).permit(:title, :year)
  movie = Movie.find(params[:id])
  movie.update_attributes form_data
  redirect_to movie_path(movie)
end
```

The first half should look familiar.  I use `update_attributes` to
update the database. This should be straightforward but look it up if
it is not. Finally, we'll redirect since we don't want the user
hanging around this update page. I want to redirect to this movie's
show page. I can do this by referencing `movie_path` (since `rake
routes` has a prefix of `movie` listed for the `movies#show` action)
and passing it the specific movie in question as discussed in the
previous section.

_movies#destroy_

Lastly, let's add the ability to delete a movie. We'll need a delete
button in `show.html.erb` and to add the necessary code in
`MoviesController#destroy`.

```ruby
def destroy
  movie = Movie.find(params[:id])
  movie.destroy
  redirect_to movies_path
end
```

```erb
<%= button_to "Delete", movie_path(@movie), :method => :delete %>
```

The `destroy` method finds the movie in question, deletes it from the
database, then redirects to the movies index page.

`button_to` is a relative of `link_to`. Instead of generating an `<a>`
tag, which are usually used for GET requests, `button_to` generates a
`<form>` which is better suited for POST, PUT, and
DELETE requests. `movie_path(@movie)` is the path for a specific
movie. However, if you look at `rake routes`, there are 4 routes under
the movie prefix, and we need to specify that we want the one
corresponding to the DELETE verb, so we also include `:method =>
:delete`.

Do the same for Actors
----------------------

All the steps for Actions should be the same (or similar) as they were
for Movies.

However, Actors will only have names, instead of titles and years.

Remember:

- The model name is singular.
- The controller name is plural.

Create the new routes:

```ruby
resources :actors
```

Create the new model (and corresponding migration):

```sh
rails g model actor name:string
```

Run the new migration:

```sh
rake db:migrate
```

Create the new controller (and corresponding views):

```sh
rails g controller actors index create new edit show update destroy
```

Don't forget to delete the unwanted routes that get added to
`config/routes.rb`.

Fill out all the actions and views for Actors just as you did for
Movies.

Many-to-Many relationship
-------------------------

Alright, so I have Actors and Movies functioning by themselves. It'd
be good to get to the point of the lab which is to be able to
assign actors to movies and vice versa. I can tell that it's a
Many-to-Many relationship, but where do I go from there? It's up to me
really. I decide that I want to display all of an Actor's Movies on
the Actor's show page and the same for Movies.

Do nested resources play into this? If so, how? I don't think so
because Actors won't belong to (i.e., be nested in) Movies nor will
Movies be nested in Authors. I could probably make it work with nested
resources but it doesn't feel quite right.

To be continued...
