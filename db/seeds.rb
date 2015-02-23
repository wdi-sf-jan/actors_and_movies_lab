# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Actor.destroy_all
Movie.destroy_all

goodman = Actor.create(:name => "John Goodman")
buscemi = Actor.create(:name => "Steve Buscemi")
moore = Actor.create(:name => "Julianne Moore")
bridges= Actor.create(:name => "Jeff Bridges")
turturro = Actor.create(:name => "John Turturro")
hoffman = Actor.create(:name => "Philip Seymour Hoffman")

lebowski = Movie.create(:title => "The Big Lebowski", :year => 1998)
magnolia = Movie.create(:title => "Magnolia", :year => 1999)
fink = Movie.create(:title => "Barton Fink", :year => 1991)

lebowski.actors << goodman
lebowski.actors << buscemi
lebowski.actors << moore
lebowski.actors << bridges
lebowski.actors << turturro
lebowski.actors << hoffman

magnolia.actors << moore
magnolia.actors << hoffman

fink.actors << goodman
fink.actors << buscemi
fink.actors << turturro
