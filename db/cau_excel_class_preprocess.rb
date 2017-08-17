require 'pry'
require 'roo' # read
require 'write_xlsx' # write

def colgnm_2_major(colgnm)
  str = colgnm.split('<br>')
  major1 = str[0]
  major2 = str[1] unless str[1].nil?
  [major1, major2]
end

def ltbdrm_has_room?(ltbdrm)
  return false if ltbdrm.nil?
  return false if ltbdrm.include?('재택')
  return false unless ltbdrm.include?('호')
  return true
end

def ltbdrm_2_room(ltbdrm)
  return nil unless ltbdrm_has_room?(ltbdrm)
  b = ltbdrm.split('관')[0].to_i
  l = ltbdrm.split('호')[0][-3..-1].to_i
  [b, l]
end

def ltbdrm_2_building_name(ltbdrm)
  return nil unless ltbdrm_has_room?(ltbdrm)
  ra = ltbdrm.split('관')[1].split('호')[0]
  ra[/\(.*?\)/, 1]
end

def ltbdrm_2_room_name(ltbdrm)
  return nil unless ltbdrm_has_room?(ltbdrm)
  room_name = ltbdrm.split('호')[1][/<.*?>/]
  room_name ||= '미정'
  return room_name
end

def lut(su)
  list = [8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 1]
  list[su]
end

def ltbdrm_2_time(ltbdrm)
  return nil unless ltbdrm_has_room?(ltbdrm)
  classes = ltbdrm.split('>')[1].split('/')

  # /를 통해 요일별로 나눈것을 array화 한다
  classes_arr = []
  if classes.class == ''.class
    classes_arr.push(classes)
  else
    classes_arr = []
    classes.each_with_index do |c, j|
      classes_arr[j] = c
    end
  end

  # 요일에서 요일을 추출한뒤, 남은 문자열로 시간정보를 추출한다
  time_class = []
  classes_arr.each do |str|
    yoyil = []
    %w(월 화 수 목 금 토 일 없음).each do |week|
      yoyil = week
      break if str.include?(week)
    end
    next if yoyil == '없음'

    time_str = [(str.index(yoyil) + 1)..-1]
    if time_str.include?('~')
      wave = str.index('~')
      st = str[(wave-5)..(wave-4)].to_i * 2
      st += str[(wave-2)..(wave-1)].to_i > 0 ? 1 : 0
      fi = str[(wave+1)..(wave+2)].to_i * 2
      fi += str[(wave+3)..(wave+5)].to_i > 0 ? 1 : 0
      fi += 1

    else
      nums = str[(str.index(yoyil)+1)..-1]
      nums = nums.split(',')
      nums = nums.collect{ |s| s.to_i }
      nums = nums.sort

      st = lut(nums[0]) * 2
      fi = lut(nums[-1] + 1) * 2
    end
    time_info = {week: yoyil, st: st, fi: fi}
    time_class.push(time_info)
  end

  time_class
end

## main ##
script_folder_path = File.dirname(__FILE__)
xlsx = Roo::Spreadsheet.open("#{script_folder_path}/cau_lectures/lectures_class.xlsx")
sheet = xlsx.sheet(0)

workbook = WriteXLSX.new("#{script_folder_path}/cau_lectures/processed.xlsx")
worksheet = workbook.add_worksheet

print('load excel data ... ')
year = sheet.column(1)    # 2017
shtm = sheet.column(2)    # 2
campcd = sheet.column(3)  # 1
sbjtno1 = sheet.column(4) # 37550
clssno1 = sheet.column(5) # 1
sbjtno = sheet.column(6)  # 37550-01
kornm = sheet.column(7)   # 20세기음악사
sust = sheet.column(8)    # 20571
colgnm = sheet.column(9)  # 대학원<br>음악학과
corscd = sheet.column(10) # 4
shtnm = sheet.column(11)  # 공통
profnm = sheet.column(12) # 서의석
ltbdrm = sheet.column(13) # 302(대학원) 501 <강의실>
puts 'done'

list = %w(과목명 교수 캠퍼스 과목명 분반 년도 학기 분류 전공1 전공2 강의실여부 건물이름 건물 호수 강의실이름 강의들)
list.each_with_index do |l, i|
  worksheet.write(0, i, l)
end

(1...year.size).each do |i|
  puts i.to_s
  j = 0
  one_list = [kornm[i], profnm[i], campcd[i],
              sbjtno1[i], clssno1[i],
              year[i], shtm[i],
              shtnm[i]
  ]
  colgnm_2_major(colgnm[i]).each{ |m| one_list.push(m) }
  one_list.push(ltbdrm_has_room?(ltbdrm[i]))
  next unless ltbdrm_has_room?(ltbdrm[i])
  one_list.push(ltbdrm_2_building_name(ltbdrm[i]))
  ltbdrm_2_room(ltbdrm[i]).each{ |n| one_list.push(n) }
  one_list.push(ltbdrm_2_room_name(ltbdrm[i]))
  one_list.push(ltbdrm_2_time(ltbdrm[i]))

  binding.pry
  one_list.each do |n|
    c = n.to_s
    c ||= '0'
    worksheet.write(i + 1, j, c)
    j += 1
  end
end

workbook.close
