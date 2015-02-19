Actors and Movies
=================

Let's make a Ruby on Rails app that allows us to perform CRUD
operations on Actors and Movies. I'd like to be able to list some of
my favorite actors and then keep track of movies in which they've
appeared. At the same time I'd like to keep track of some of my
favorite movies and some of the actors have have appeared in them.

Actors and Movies have an interesting relationship because a Movie can
have many Actors but an Actor can also have many Movies. This is a
classic many-to-many problem. If we try to use a one-to-many
relationship we would either limit a Movie to having one Actor or
limit an Actor to appearing in one Movie.

Things we'll need
-----------------

We can initially think about what we'd need for Actors and Movies
separately, and then think about joining them later.

### For Movies

We'll need routes, a model, and a controller. Look into `resources`
for creating the necessary routes and `rails generate` or `rails g`
for creating models and controllers.

### For Actors

It will be the same as what you did for Movies, but for Actors this
time.

### For Actors and Movies

You should have a working site that allows you to perform CRUD
operations on Actors and Movies separately before trying to setup the
relationship between them.
