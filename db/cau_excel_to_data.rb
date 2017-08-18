require 'roo'
require 'pry'

def is_i?(str)
  !!(str =~ /\A[-+]?[0-9]+\z/)
end

def rooms_from_excel
  script_folder_path = File.dirname(__FILE__)
  xlsx = Roo::Spreadsheet.open("#{script_folder_path}/cau_classinfo.xlsx")
  sheet = xlsx.sheet(0)

  buildings = sheet.column(2)
  departments = sheet.column(9)
  floors = sheet.column(3)
  numbers = sheet.column(4)
  capacities = sheet.column(8)

  rooms = []
  for i in 2...buildings.size do
    str = buildings[i].split('관')[0]
    rooms[i-2] = {
        build: (is_i?(str) ? str.to_i : 0),
        floor: (floors[i] == 'B1' ? -1 : floors[i].to_i),
        loc: (floors[i][0] == '0' ? floors[i][1] : floors[i]) + numbers[i],
        capacity: capacities[i].to_i,
        department: departments[i],
        level: 1
    }
  end
  return rooms
end

def lectures_from_excel
  puts 'lectures'
  script_folder_path = File.dirname(__FILE__)
  xlsx = Roo::Spreadsheet.open("#{script_folder_path}/cau_lectures/pprocessed.xlsx")
  sheet = xlsx.sheet(0)

  name = sheet.column(1)      # 과목명
  professor = sheet.column(2) # 교수
  campus = sheet.column(3)    # 캠퍼스
  subjno = sheet.column(4)    # 과목번호
  subjclass = sheet.column(5) # 분반
  year = sheet.column(6)      # 년도
  semaster = sheet.column(7)  # 학기
  classify = sheet.column(8)  # 분류
  major1 = sheet.column(9)    # 전공1
  major2 = sheet.column(10)   # 전공2

  room_exists = sheet.column(11)  # 강의실여부
  building_name = sheet.column(12)  # 건물이름
  building = sheet.column(13)  # 건물
  loc1 = sheet.column(14)  # 호수1
  loc2 = sheet.column(15)  # 호수2
  room_name = sheet.column(16)  # 강의실이름
  time1 = sheet.column(17)  # 강의1
  time2 = sheet.column(18)  # 강의2
  time3 = sheet.column(19)  # 강의3

  mynums = sheet.column(21) # 중복방지

  lectures = []
  (1..name.size).each do |i|
    lecture = {
      name: name[i],
      professor: professor[i],
      campus: campus[i].to_i,

      subjno: subjno[i].to_i,
      subjclass: subjclass[i].to_i,

      year: year[i].to_i,
      semaster: semaster[i].to_i,

      classify: classify[i],
      major1: major1[i],
      major2: major2[i],
      mynums: mynums[i]
    }

    if room_exists[i] == 'true'
      local_building = {
          building_name: building_name[i],
          building: building[i].to_i
      }

      local_room = {
          building: building[i].to_i,
          loc1: loc1[i].to_i,
          loc2: loc2[i].to_i,
          room_name: room_name[i]
      }

      local_times = []
      if time1[i].size > 0
        temp = time1[i].split(' ')
        local_times.push({ week: temp[0], st: temp[1].to_i, fi: temp[2].to_i })
      end
      if time2[i].size > 0
        temp = time2[i].split(' ')
        local_times.push({ week: temp[0], st: temp[1].to_i, fi: temp[2].to_i })
      end
      if time3[i].size > 0
        temp = time3[i].split(' ')
        local_times.push({ week: temp[0], st: temp[1].to_i, fi: temp[2].to_i })
      end

      lecture[:b] = local_building
      lecture[:r] = local_room
      lecture[:t] = local_times
    end
    lectures.push(lecture)
  end

  return lectures
end