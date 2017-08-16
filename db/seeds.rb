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

  # 강의들을 불러온다
  lectures = lectures_from_excel
  lectures.each do |lecture|
    # 강의를 등록한다
    db_lecture = Lecture.where('subjno = ? AND subjclass = ?', lecture[:subjno], lecture[:subjclass])[0]
    if db_lecture.nil?
      new_lecture = Lecture.new(
          name: lecture[:name],
          professor: lecture[:professor],
          campus: lecture[:campus],
          subjno: lecture[:subjno],
          subjclass: lecture[:subjclass],
          year: lecture[:year],
          semaster: lecture[:semaster],
          classify: lecture[:classify],
          major1: lecture[:major1]
      )
      new_lecture[:major2] = lecture[:major2] unless lecture[:major2].nil?
      new_lecture.save
      db_lecture = Lecture.where('subjno = ? AND subjclass = ?', lecture[:subjno], lecture[:subjclass])[0]
    end

    # room을 등록한다
    room = nil
    unless lecture[:building].nil?
      b_num = lecture[:building].to_i
      l_num = lecture[:loc].to_i

      room = Room.where('build = ? AND loc = ?', b_num, l_num)[0]
      unless room.nil?
        room.update_column(:room_name, lecture[:room_name]) if room[:room_name].nil?
      else
        Building.create(number: b_num) unless Building.where(number: b_num).exists?
        new_building_id = Building.where(number: b_num)[0].id

        local_floor = 0
        if lecture[:loc].size == 3
          local_floor = lecture[:loc][0].to_i
        elsif lecture[:loc].size == 4
          local_floor = lecture[:loc][0..1].to_i
        end

        room = Room.create(
          room_name: lecture[:room_name],
          build: b_num,
          loc: l_num,
          floor: local_floor,
          level: 2,
          building_id: new_building_id
        )
      end

      if db_lecture.room.nil? && !room.nil?
        db_lecture.update_column(:room_id, room.id)
      end
    end

    unless lecture[:time_classes].nil?
      #puts lecture[:time_classes]
      lecture[:time_classes].each do |time_class|
        # 수업을 등록한다
        db_time = db_lecture.time_classes.where('week = ? AND st = ? AND fi = ?', time_class[:yoyil], time_class[:st], time_class[:fi])[0]

        if db_time.nil?
          new_time_class = TimeClass.new(
              lecture_id: db_lecture.id,
              week: time_class[:yoyil],
              st: time_class[:st],
              fi: time_class[:fi]
          )
          new_time_class.room_id = room.id unless room.nil?
          new_time_class.save!
          #new_time_class = db_lecture.time_classes.where('week = ? AND st = ? AND fi = ?', time_class[:yoyil], time_class[:st], time_class[:fi])[0]
        end
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
