# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

u1 = User.new(
  login: 'nathans',
  email: 'anon@example.org',
  password: 'test1234',
  password_confirmation: 'test1234',
)
u1.save!

d = Definition.new(
  word: 'Goesting',
  description: 'Zin hebben in',
  example: 'Ik heb goesting in frieten',
  updated_by: u1.id,
)

d.save!

w = Wotd.create!(definition: d, date: Date.today)
