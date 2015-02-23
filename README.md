Actors and Movies
=================

Let's make a Ruby on Rails app that allows us to list some of our
favorite actors and movies. We should be able to perform all of the
CRUD operations on both Actors and Movies. Additionally, we should
be able to indicate which actors are in which movies.

Actors and Movies have an interesting relationship because a Movie can
have many Actors and an Actor can also have many Movies. This is a
classic many-to-many problem. If we try to use a one-to-many
relationship we would either limit a Movie to having one Actor or
an Actor to appearing in only one Movie.

Things we'll need
-----------------

One approach would be to decide what we'd need for Actors and Movies
separately, and then think about joining them later. Another approach
would be to get the relationships setup first and then fill out the
rest of your app. I don't know which is better. I took the first
approach but I feel dirty admitting it.

### For Movies

We'll need routes, a model, and a controller. Look into `resources`
for creating the necessary routes and `rails generate` (`rails g`)
for creating models (and migrations) and controllers.

### For Actors

It will be the same as what you did for Movies, but for Actors this
time.

### For Actors and Movies

A few things need to happen at this phase. You'll need to make
decisions around:

- setting up the many-to-many relationship in the database and models,
- setting up the routes and controller actions, and
- integrating this feature into your UI.

Notes
-----

This assignment is purposely open-ended. You get to take what you
learned (right, guys?) in the weekend lab and integrate in the
many-to-many relationship that we discussed this morning. On one hand
it's nothing too different from what you've done, on the other it's a
sizeable lab with many pieces to put together.

The only requirements are that you allow the user to indicate that
many actors can appear in a movie and an individual actor can appear
in many different movies. How to do that is largely left up to you.
