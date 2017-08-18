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
#114210
  #215 946078 41237
  lectures = lectures_from_excel
  lectures.each do |lecture|

    db_lecture = Lecture.where(mynum: lecture[:mynum])[0]
    unless db_lecture
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

    # 강의를 등록했으니 방을 등록하자
    unless lecture[:r].nil?
      db_building = Building.where(number: lecture[:b][:building])
      # 건물을 만든다
      if db_building.exists?
        db_building = db_building[0]
        #이름을 갱신해본다
        if db_building.name.nil? && lecture[:b][:building_name]
          db_building.update_column(:name, lecture[:b][:building_name])
        end
      # 건물이 없는경우
      else
        # 건물을 만든다
        # 건물을 만들기 전에 이름이 있는지 확인해서 만든다
        if lecture[:b][:building_name].nil?
          Building.create(number: lecture[:b][:building])
        else
          Building.create(number: lecture[:b][:building], name: lecture[:b][:building_name])
        end
        db_building = Building.where(number: lecture[:b][:building])[0]
      end


      # 방을 이제 만든다 (빌딩이 있는데 방이 없을리가 없는)
      ### puts "puts #{lecture[:r][:building]} -- #{lecture[:r][:loc1]} -- #{db_building.number}"
      db_room = Room.where('build = ? AND loc = ?', lecture[:r][:building], lecture[:r][:loc1])
      if db_room.exists?
        ### puts "A"
        db_room = db_room[0]
      else
        ### puts "B"
        Room.create(building_id: db_building.id, build: lecture[:r][:building], loc: lecture[:r][:loc1])
        ##puts "#{db_building.id} #{lecture[:r][:building]} #{lecture[:r][:loc1]}"
        db_room = Room.where('build = ? AND loc = ?', lecture[:r][:building], lecture[:r][:loc1])[0]
      end

      ##puts "C"
      ##puts "#{db_room}"

      # 강의들에 대해서
      unless lecture[:t].nil?
        # 강의들에 대해서 *여러개 -< 한개
        lecture[:t].each do |time|
          next if time.nil?
          db_time = TimeClass.where('room_id = ? AND week = ? AND st = ?', db_room.id, time[:week], time[:st])
          unless db_time.exists?
            TimeClass.create(lecture_id: db_lecture.id, room_id: db_room.id, week: time[:week], st: time[:st], fi: time[:fi])
          end
        end

      end #강의들에 대해서 끝

    end #방이 있을 경우에 대해서 끝



  end #강의들에 대해서 끝
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
