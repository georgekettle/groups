# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
puts "Creating kettle users"
george_user = User.create!(email: 'george@gmail.com', password: 'secret')
georgia_user = User.create!(email: 'georgia@gmail.com', password: 'secret') # to better test search
georgio_user = User.create!(email: 'georgio@gmail.com', password: 'secret') # to better test search
sylvie_user = User.create!(email: 'sylvie@gmail.com', password: 'secret')
alice_user = User.create!(email: 'alice@gmail.com', password: 'secret')
eva_user = User.create!(email: 'eva@gmail.com', password: 'secret')
puts "Finished creating kettle users"

kettle_users = [ george_user, georgia_user, georgio_user, sylvie_user, alice_user, eva_user ]

puts "Creating kettle profiles"
george_user.profile.update(first_name: 'George', last_name: 'Kettle')
georgia_user.profile.update(first_name: 'Georgia', last_name: 'blah blah')
georgio_user.profile.update(first_name: 'Georgio', last_name: 'blah blah')
sylvie_user.profile.update(first_name: 'sylvie', last_name: 'kettle')
alice_user.profile.update(first_name: 'alice', last_name: 'kettle')
eva_user.profile.update(first_name: 'eva', last_name: 'kettle')
puts "Finished creating kettle profiles"

puts "Creating kettle group"
kettle_group = Group.create!(name: 'Fambamalicious')
puts "Finished creating kettle group"

puts "Creating group_members"
kettle_users.each_with_index do |user, index|
  role = index == 0 ? 'owner' : 'member'
  kettle_group.group_members.create!(profile_id: user.profile.id, role: role)
end
puts "Finished creating group_members"

puts "Creating channel_members"

def create_channel_member(user, channel)
  channel.channel_members.create(profile_id: user.profile.id)
end

kettle_users.each_with_index do |user, index|
  user.profile.groups.each do |group|
    group.channels.each do |channel|
      create_channel_member(user, channel)
    end
  end
  # kettle_group.channel_members.create!(profile_id: user.profile.id, role: role)
end
puts "Finished creating channel_members"
