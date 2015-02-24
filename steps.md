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

__Routes__

It seems like I'm going to need 4 routes:

- add a movie to an actor
- remove a movie from an actor
- add an actor to a movie, and
- remove an actor from a movie.

Hey, you say, aren't these really 2 actions (associating an actor and
a movie and dissocating them)? Yeah, that's a good point, but I feel
like I want my user interface to be different between the two, so I'm
sticking with 4 for now. Maybe I'll learn more in the future and have
to change my approach. That's ok.

I add the following to my `config/routes.rb` and we'll see how it goes.

```ruby
post '/movies/:id/actors/new' => 'movies#add_actor', as: :add_actor
delete 'movies/:id/actors/:actor_id' => 'movies#remove_actor', as: :remove_actor
post '/actors/:id/movies/new' => 'actors#add_movie', as: :add_movie
delete '/actors/:id/movies/:movie_id' => 'actors#remove_movie', as: :remove_movie
```

__The Model__

Ok, I know that for a many-to-many relationship I'm going to need a
junction table. Rails offers a couple ways to represent this, but my
favorite, the "has :many, :through", requires me to create a new
model. I need to construct this new model carefully. Just like the
other models it needs to be named something singular, and the table
name will be the pluralized version. The junction table will need to
have two columns (in addition to the primary key) that are foreign
keys to the two tables I'm joining. I write this as:

```sh
rails g model ActorsMovie actor:references movie:references
```

(Note: the model is the singular "ActorsMovie" while the table will be
the plural "ActorsMovies". Also note that the pluralization only
happens at the end of the word, so the "Actors" piece always has the
"s", even in the singular version).

I check out the two files that are generated, they look reasonable. In
order to finish setting up this relationship, I'll need to modify
`actor.rb` and `movie.rb` to be:

```ruby
class Actor < ActiveRecord::Base
  has_many :actors_movies
  has_many :movies, through: :actors_movies
end
```

```ruby
class Movie < ActiveRecord::Base
  has_many :actors_movies
  has_many :actors, through: :actors_movies
end
```

The way I think of that code is that we can't directly say that an
actor has many movies because the `actors` table and the `movies`
table have no direct links between them. Instead, the `actors` table
is connected to the `actors_movies` table (which is also connected to
the `movies` table), so we have to establish that relationship
first. Then once we've established that first hop we can make the
second hop by saying an actor has many movies `:through`
`actors_movies`.

Also, since you've generated a new migration file, don't forget to run

```sh
rake db:migrate
```

I test out the relationships work in `rails console`. It would not be
wise to skip this step.

__The Views__

I decide that I want the relationships to appear in the existing view
pages. Meaning, I'd like movies to show up on an actor's show page and
I'd like actors to show up on a movie's show page. So, I won't create
any new template files, but I will need to modify the existing ones.

In the `view/actors/show.html.erb` I add the following,

```erb
<div>
  <h2>Movies</h2>
  <ul>
    <% @actor.movies.each do |role| %>
    <li>
      <%= link_to "#{role.title} (#{role.year})", movie_path(role) %>
      <%= button_to "X", remove_movie_path(@actor, role), :method => :delete %>
    </li>
    <% end %>
  </ul>
  <%= form_tag add_movie_path do |f|%>
    <select name="movie_id">
      <% @movies.each do |flick| %>
      <option value="<%=flick.id%>"><%=flick.title %></option>
      <% end %>
    </select>
    <input type="submit" value="Add">
  <% end %>
</div>
```

This renders:

- an h2 heading that says "Movies"
- a list of actors in the movie and a button to remove them
- a dropdown menu of all actors so you can add a new one to the movie

In order for this to work I need to modify `movies_controller.rb` so
that the `show` method returns all the actors in addition to the movie
in question

```ruby
def show
  @movie = Movie.find(params[:id])
  @actors = Actor.all
end
```

and also add the `add_actor` and `remove_actor` methods that my forms
will call.

```ruby
def add_actor
  movie = Movie.find(params[:id])
  actor = Actor.find(params[:actor_id])
  movie.actors << actor
  redirect_to movie_path(movie)
end
def remove_actor
  movie = Movie.find(params[:id])
  actor = Actor.find(params[:actor_id])
  movie.actors.delete(actor)
  redirect_to movie_path(movie)
end
```

I repeat these steps on the actor show page and in
`actors_controller.rb`.

The app is mostly done by this point.

Bonus Steps
-----------

__Seed file__

Did you create a `db/seeds.rb` file? Not necessary, but it can be
helpful.

__A home page to connect the actors and movies sections__

Even after I've done everything above, going to
[localhost:3000](localhost:3000) still shows the Rails Welcome page.
I create a home page that allows me to browse with by actor or by
movie.

In `config/routes.rb`, add

```ruby
root 'site#index'
```

Also, create a site controller by

```sh
rails generate controller site index
```

And modify `views/site/index.html.erb` to contain your home page.

__Delete dependent rows__

What happens if you delete a movie that has actors assigned to it?
That relationship is represented in the `actors_movies` table. If you
remove the movie, the `actors_movies` table will now be referencing a
movie that no longer exists. This is bad. A better solution is remove
all rows from the `actors_movies` table that reference the movie or
actor being deleted. Rails can help you does this with `dependent:
:destroy`.

In both models, `actor.rb` and `movie.rb`, change the line

```ruby
has_many :actors_movies
```

to

```ruby
has_many :actors_movies, dependent: :destroy
```

__Only be able to add movies / actors that aren't already associated__

We might as well only populate the drop downs with values that haven't
already been associated with the item in question. Ruby has this
awesome feature where you can subtract one array from another to get
the difference of them.

I changed the #show actions in `actors_controller.rb` and
`movies_controller.rb` to be the following, respectively:

```ruby
def show
  @actor = Actor.find(params[:id])
  @movies = Movie.all - @actor.movies
end
```

```ruby
def show
  @movie = Movie.find(params[:id])
  @actors = Actor.all - @movie.actors
end
```

__Prevent Movie and Actor from being associated more than once__

While preventing duplicate associations by filtering what appears in
the drop down menus works for the most part, is there a way to prevent
this duplication at the database level?

Yep, try a uniqueness validation on the join model with the addition
of `:scope`:

In `actors_movie.rb`:

```ruby
validates :actor_id, uniqueness: {scope: :movie_id}
```

__Use Rails' collection_select form helper__

In the above code for rendering the dropdown menus, I manually wrote
HTML in my template files.  For instance, in

`views/actors/show.html.erb` I had:

```erb
<select name="movie_id">
  <% @movies.each do |flick| %>
  <option value="<%=flick.id%>"><%=flick.title %></option>
  <% end %>
</select>
```

Well, Rails probably has a helper function for this. Someone in class
mentioned
[collection_select](http://api.rubyonrails.org/classes/ActionView/Helpers/FormOptionsHelper.html#method-i-collection_select)
which can be used to do the following refactoring:

```erb
<%= collection_select :movie, :id, @movies, :id, :title %>
```

This roughly generates the following:

```erb
<select name="movie[id]">
  <% @movies.each do |flick| %>
  <option value="<%=flick.id%>"><%=flick.title %></option>
  <% end %>
</select>
```

Neat. However, as you can see, it isn't a direct
translation. `name="movie_id"` has turned into
`name="movie[id]"`. That's ok, but I have to modify the controller
accordingly. The `add_movie` action in  `actors_controller.rb` needs
to grab the movie id slightly differently:

```ruby
def add_movie
  movie_params = params.require(:movie).permit(:id)
  movie = Movie.find(movie_params[:id])
  # ...code snipped...
end
```
