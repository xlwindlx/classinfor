# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
User.create(email: 'admin@test.com', password: 'likelion2')
Building.create(loc: '310', name: '경영경제관')
Department.create(loc: '310-301', name: '경영경제대학')
Room.create(floor: 7, loc: 701, capacity: 40, level: 1, building_id: 1)