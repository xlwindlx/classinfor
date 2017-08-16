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

def col_to_lecture(name, professor, campus, subjno, subjclass, year, semaster, classify, colgnm, ltbdrm)
  lecture = {
    name: name,
    professor: professor,
    campus: campus,

    subjno: subjno,
    subjclass: subjclass,

    year: year,
    semaster: semaster,
    classify: classify
  }
  # 전공에 대한 분류
  major = colgnm.split('<br>')
  lecture[:major1] = major[0]
  lecture[:major2] = major[1] unless major[1].nil?

  # 비어있거나 재택일경우에 대한 처리
  if ltbdrm.nil?
    lecture[:room_name] = '미정'
    return lecture
  end
  if ltbdrm.include?('재택')
    lecture[:room_name] ||= '재택'
    return lecture
  end

  # 만약 강의실의 관 혹은 호가 있다면
  if ltbdrm.include?('관')
    lecture[:building] = ltbdrm.split('관')[0].to_i
    lecture[:loc] = ltbdrm.split('호')[0][-3..-1].to_i
  end

  # 강의실 이름이 따로 적혀있는 경우
  if ltbdrm.include?('<')
    rst = ltbdrm.index('<')
    rfi = ltbdrm.index('>')
    lecture[:room_name] = ltbdrm[(rst + 1)..(rfi - 1)]
  end
  lecture[:room_name] ||= '미정'

  # 요일이나 시간에 대한 뒷부분
  if lecture[:room_name] == '미정'
    days_str = ltbdrm[i]
  else
    days_str = ltbdrm[i].split('>')[1]
  end

  # 요일의 경우 '/'로 나누어져 있기 때문에 이경우의 처리 (2차처리)
  days_str = days_str.split('/') if days_str.include?('/')
  days = []
  if days_str.class == ''.class
    # 하나일경우
    days[0] = days_str
  else
    # 2개일 경우
    days_str.each_with_index do |a, i|
      days[i] = a
    end
  end

  # 요일별 시간 처리
  time_classes = []
  days.each do |str|
    time_class = {}
    # 요일 정보를 빼내 등록한다
    for week in %w(월 화 수 목 금 토 일)
      if str.include?(week)
        time_class[:yoyil] = week
        break
      end
    end

    # 시간정보로 되어있을떄
    if str.include?('~')
      mid = str.index('~')
      st = str[(mid-5)..(mid-4)].to_i * 2 +
          ((str[(mid-2)..(mid-1)] == '30') ? 1 : 0 )
      fi = str[(mid+1)..(mid+2)].to_i * 2 +
          ((str[(mid+4)..(mid+5)] == '30') ? 1 : 0 )
    else

      # 시간정보가 아닐때때
      nums = str[(str.index(time_class[:yoyil]) + 1)..-1]
      nums = nums.split(',')
      nums = nums.collect{|s| s.to_i}
      nums = nums.sort

      st = nums[0]
      fi = nums[-1]
    end
    time_class[:st] = st
    time_class[:fi] = fi

    time_classes.push(time_class)
  end
  lecture[:time_classes] = time_classes

  return lecture
end

def lut(su)
  list = [8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 1]
  list[su]
end

def lectures_from_excel
  print ('excel data loaded...')

  script_folder_path = File.dirname(__FILE__)
  xlsx = Roo::Spreadsheet.open("#{script_folder_path}/cau_lectures/lectures_class.xlsx")
  sheet = xlsx.sheet(0)

  year = sheet.column(1) # 2017
  shtm = sheet.column(2) # 2
  campcd = sheet.column(3) # 1
  sbjtno1 = sheet.column(4) # 37550
  clssno1 = sheet.column(5) # 10
  kornm = sheet.column(7) # 21세기기업경
  colgnm = sheet.column(9) # 대학원<br>과
  corscd = sheet.column(10) # 0
  shtnm = sheet.column(11) # 전공
  profnm = sheet.column(12) # 서의석
  ltbdrm = sheet.column(13) # 관 호 <?강의실?>
  puts 'done'
  puts 'start parse data'

  lectures = []
  (1...year.size).each do |i|
    lectures[i - 1] = {}

    # 기본적인 강의 정보
    lecture = {
      name: kornm[i],
      professor: profnm[i],
      campus: campcd[i],

      subjno: sbjtno1[i],
      subjclass: clssno1[i],

      year: year[i],
      semaster: shtm[i],
      classify: shtnm[i]
    }
    major = colgnm[i].split('<br>')
    lecture[:major1] = major[0]
    lecture[:major2] = major[1] unless major[1].nil?

    lectures[i - 1] = {}
    # 비어있거나 재택일경우에 대한 뒷처리
    if ltbdrm[i].nil?
      next
    elsif ltbdrm[i].include?('재택')
      lecture[:room_name] ||= '재택'
      next
    end

    # 만약 강의실의 관 혹은 호가 있다면 파싱
    if ltbdrm[i].include?('관')
      lecture[:building] = ltbdrm[i].split('관')[0].to_i
      lecture[:loc] = ltbdrm[i].split('호')[0][-3..-1].to_i
    end

    # 강의실 이름이 따로 적혀있는 경우 파싱
    if ltbdrm[i].include?('<')
      rst = ltbdrm[i].index('<')
      rfi = ltbdrm[i].index('>')
      lecture[:room_name] = ltbdrm[i][(rst + 1)..(rfi - 1)]
    end
    lecture[:room_name] ||= '미정'

    # 요일이나 시간을 파싱할때 str에 대한 1차 처리 (뒷부분)
    if lecture[:room_name] == '미정'
      days_str = ltbdrm[i]
    else
      days_str = ltbdrm[i].split('>')[1]
    end

    # 요일의 경우 '/'로 나누어져 있기 때문에 이경우의 처리 (2차처리)
    days_str = days_str.split('/') if days_str.include?('/')
    days = []
    if days_str.class == ''.class
      # 하나일경우
      days[0] = days_str
    else
      # 2개일 경우
      days_str.each_with_index do |a, i|
        days[i] = a
      end
    end

    # 이제 time_class에 대한 시간 처리를 행함
    time_classes = []
    days.each do |str|
      time_class = {}
      # 요일 정보를 빼내 등록한다
      for week in %w(월 화 수 목 금 토 일)
        if str.include?(week)
          time_class[:yoyil] = week
          break
        end
      end

      next if time_class[:yoyil].nil?

      # 시간정보로 되어있을떄
      if str.include?('~')
        mid = str.index('~')
        st = str[(mid-5)..(mid-4)].to_i * 2 +
            ((str[(mid-2)..(mid-1)] == '30') ? 1 : 0 )
        fi = str[(mid+1)..(mid+2)].to_i * 2 +
            ((str[(mid+4)..(mid+5)] == '30') ? 1 : 0 ) + 1
      elsif !str.scan(/\d/).empty?

        # 시간정보가 아닐때때
        nums = str[(str.index(time_class[:yoyil]) + 1)..-1]
        nums = nums.split(',')
        nums = nums.collect{|s| s.to_i}
        nums = nums.sort

        st = lut(nums[0]) * 2
        fi = lut(nums[-1] + 1) * 2
      end
      time_class[:st] = st
      time_class[:fi] = fi

      time_classes.push(time_class)
    end

    lecture[:time_classes] = time_classes
    lectures[i - 1] = lecture
  end

  #binding.pry
  return lectures
end