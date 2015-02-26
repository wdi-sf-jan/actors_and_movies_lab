# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
Actor.destroy_all
Movie.destroy_all
Comment.destroy_all

downey = Actor.create({ name: "Robert Downey Jr."})
pine = Actor.create({ name: "Chris Pine" })
hemsworth = Actor.create({ name: "Chris Hemsworth" })
hiddleston = Actor.create({ name: "Tom Hiddleston" })
neeson = Actor.create({ name: "Liam Neeson" })
brosnan = Actor.create({ name: "Pierce Brosnan" })
craig = Actor.create({ name: "Daniel Craig" })
johanssen = Actor.create({ name: "Scarlett Johanssen" })
gadot = Actor.create({ name: "Gal Gadot" })
beckinsale = Actor.create({ name: "Kate Beckinsale" })

ironman = Movie.create({ title: "Iron Man", year: 2009 })
avengers = Movie.create({ title: "Avengers", year: 2011 })
startrek = Movie.create({ title: "Star Trek", year: 2012 })
taken = Movie.create({ title: "Taken", year: 2011 })
goldeneye = Movie.create({ title: "GoldenEye", year: 1999 })
casinoroyale = Movie.create({ title: "Casino Royale", year: 2010 })
thor = Movie.create({ title: "Thor", year: 2013 })
underworld = Movie.create({ title: "Underworld", year: 2009 })
fnf = Movie.create({ title: "Fast and Furious", year: 2015 })

ironman.actors << downey
ironman.actors << johanssen
avengers.actors << downey
avengers.actors << johanssen
avengers.actors << hemsworth
avengers.actors << hiddleston
startrek.actors << pine
taken.actors << neeson
goldeneye.actors << brosnan
casinoroyale.actors << craig
thor.actors << hemsworth
underworld.actors << beckinsale
fnf.actors << gadot