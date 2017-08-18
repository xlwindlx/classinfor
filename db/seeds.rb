user = [{ email: 'admin@test.com', password: 'likelion2' }]
user.each do |u|
  unless User.where(email: u[:email]).exists?
    User.create(email: u[:email],
                password: u[:password])
  end
end

#cau
if true
  # 강의실에 대한 room 정보가 담겨있음
  load "#{Rails.root}/db/cau_excel_to_data.rb"
  rooms = rooms_from_excel

  rooms.each do |r|
    # uniquness
    next if Room.where('build = ? AND loc = ?', r[:build], r[:loc]).exists?

    # buidling
    building = Building.where(number: r[:build])
    unless building.exists?
      building_id = Building.create(number: r[:build]).id
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

  lectures = lectures_from_excel
  lectures.each do |lecture|

    db_lecture = Lecture.where(mynum: lecture[:mynum])[0]
    unless db_lecture.exists?
      Lecture.create(
        name: lecture[:name],
        professor: lecture[:professor],
        campus: lecture[:campus],

        subjno: lecture[:subjno],
        subjclass: lecture[:subjclass],

        year: lecture[:year],
        semaster: lecture[:semaster],

        classify: lecture[:classify],
        major1: lecture[:major1],
        major2: lecture[:major2],

        mynum: lecture[:mynum]
      )
      db_lecture = Lecture.where(mynum: lecture[:mynum])[0]
    end

    unless lecture[:r].nil?
      db_building = Building.where(number: lecture[:b][:building])[0]
      if db_building.exists?
        if db_building.name.nil? && lecture[:b][:building_name]
          db_building.update_column(:name, lecture[:b][:building_name])
        end
      else
        if lecture[:b][:building_name].nil?
          Building.create(number: lecture[:b][:building])
        else
          Building.create(number: lecture[:b][:building], name: lecture[:b][:building_name])
        end
        db_building = Building.where(number: lecture[:b][:building])[0]
      end

      db_room = Room.where('build = ? AND loc = ?', lecture[:r][:building], lecture[:loc1])[0]
      unless db_room.exists?
        db_room = Room.create()
      end
      unless lecture[:t].nil?

      end
    end



  end
end

#dku
if false
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
