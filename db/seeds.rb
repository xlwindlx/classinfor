# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
user = [{ email: 'admin@test.com', password: 'likelion2' }]
user.each do |u|
  unless User.where(email: u[:email]).exists?
    User.create(email: u[:email],
                password: u[:password])
  end
end

load "#{Rails.root}/db/test.rb"
rooms = hello

rooms.each do |r|
  # uniquness
  next if Room.where('building = ? AND loc = ?', r[:building], r[:loc]).exists?

  # buidling
  building = Building.where(number: r[:building])
  unless building.exists?
    building_id = Building.create(number: r[:building]).id
  else
    building_id = building[0].id
  end
  r[:building_id] = building_id

  # department
  department = Department.where(name: r[:department])
  unless department.exists?
    department_id = Department.create(name: r[:department]).id
  else
    department_id = department[0].id
  end
  r[:department_id] = department_id

  # assingment
  new_room = Room.new
  r.each do |key, v|
    new_room[key] = v
  end
  new_room.save

end

__END__
xlsx = Roo::Spreadsheet.open('./classinfo')
building = [{ loc: '310', name: '경영경제관' }]
building.each do |b|
  unless Building.where(loc: b[:loc]).exists?
    new_building = Building.new
    b.each do |k,v|
      new_building[k] = v
    end
    new_building.save
  end
end

department = [{ loc: '310-301', name: '경영경제대학' }]
department.each do |d|
  unless Department.where(loc: d[:loc]).exists?
    Department.create(loc: d[:loc], name: d[:name])
  end
end