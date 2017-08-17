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
  return false unless ltbdrm.include?('호') || ltbdrm.include?('<')
  return true
end

def ltbdrm_2_room(ltbdrm)
  return [nil, nil] unless ltbdrm_has_room?(ltbdrm)
  # TODO : 강의실이 두개인 경우 : 시간에 비해 복잡성이 굉장히 상승하여 (보류)
=begin
  temp = ltbdrm[/^.*>/]
  temp = temp.split('/')
  temp_arr = []
  if temp.class == ''.class
    temp_arr[0] = [temp]
  else
    temp_arr = temp
  end
  temp_arr.each do |ltb|

  end
=end
  b = ltbdrm.split('관')[0].to_i
  if b == 0
    b = 1959 if ltbdrm.include?('공연예술원')
    b = 801 if ltbdrm.include?('외국어문학')
    b = 9999 if ltbdrm.include?('대 운 동 장')
    b = 1001 if ltbdrm.include?('국악대학 가건물')
    b = 810 if ltbdrm.include?('원형관')
    b = 805 if ltbdrm.include?('공연영상관')
    b = 1002 if ltbdrm.include?('국악대학')
  end

  temp = ltbdrm[/[0-9\-_]*호/]
  if !temp.nil?
    temp = temp.split('호')[0]
    if temp.include?('-')
      l = temp.split('-')[0].to_i
      l2 = temp.split('-')[1].to_i
    else
      l = temp.to_i
    end
  else
    possible_case = ltbdrm[/\d{4}/]
    l = possible_case.to_i unless possible_case.nil?
  end
  [b, l, l2]
end

def ltbdrm_2_building_name(ltbdrm)
  return nil unless ltbdrm_has_room?(ltbdrm)

  ra = ltbdrm.split('호')[0]
  unless ra[/\(.*?\)/].nil?
    return ra[/\(.*?\)/][1..-2]
  end

  ['공원예술원', '외국어문학', '대 운 동 장', '국악대학 가건물', '원형관', '공연영상관'].each do |n|
    return n if ltbdrm.include?(n)
  end

  return nil

end

def ltbdrm_2_room_name(ltbdrm)
  return nil unless ltbdrm_has_room?(ltbdrm)
  temp = ltbdrm
  # temp = ltbdrm.split('호')[1] if ltbdrm.include?('호')
  room_name = temp[/<.*?>/]
  room_name = room_name[1..-2] unless room_name.nil?
  room_name ||= '미정'
  return room_name
end

def lut(su)
  list = [8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 1]
  list[su]
end

def ltbdrm_2_time(ltbdrm)
  return nil unless ltbdrm_has_room?(ltbdrm)
  temp = ltbdrm[/>[a-zA-Z가-힣 0-9\/,():~]*$/]
  classes = temp[1..-1].split('/') unless temp.nil?
  classes ||= ltbdrm.split('>')[1].split('/')

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

    time_str = str[(str.index(yoyil) + 1)..-1]
    # puts "time_str = #{time_str}" ##
    if time_str.include?('~')
      wave = time_str.index('~')
      st = time_str[(wave-2)..(wave-1)].to_i
      st += time_str[(wave-5)..(wave-4)].to_i * 100

      fi = time_str[(wave+4)..(wave+5)].to_i
      fi += time_str[(wave+1)..(wave+2)].to_i * 100

    else
      nums = time_str
      nums = nums.split(',')
      nums = nums.collect{ |s| s.to_i }
      nums = nums.sort

      st = lut(nums[0]) * 100
      fi = lut(nums[-1] + 1) * 100
    end
    time_info = { week: yoyil, st: st, fi: fi }
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

list = %w(과목명 교수 캠퍼스 과목명 분반 년도 학기 분류 전공1 전공2 강의실여부 건물이름 건물 호수1 호수2 강의실이름 강의들)
list.each_with_index do |l, i|
  worksheet.write(0, i, l)
end

(1...year.size).each do |i|
  # puts i.to_s.rjust(4, '0') ##
  # puts ltbdrm[i] ##
  j = 0
  one_list = [kornm[i], profnm[i], campcd[i],
              sbjtno1[i], clssno1[i],
              year[i], shtm[i],
              shtnm[i]
  ]
  colgnm_2_major(colgnm[i]).each{ |m| one_list.push(m) }
  one_list.push(ltbdrm_has_room?(ltbdrm[i]))
  one_list.push(ltbdrm_2_building_name(ltbdrm[i]))
  ltbdrm_2_room(ltbdrm[i]).each{ |n| one_list.push(n) }
  one_list.push(ltbdrm_2_room_name(ltbdrm[i]))

  times = ltbdrm_2_time(ltbdrm[i])
  unless times.nil?
    times.each do |t|
      temp_str = ''
      t.each { |k, v| temp_str += v.to_s + ' ' }
      one_list.push(temp_str)
    end
  end

  # print one_list ##
  # puts '' ##
  # binding.pry

  one_list.each do |n|
    c = n.to_s
    c ||= '0'
    worksheet.write(i, j, c)
    j += 1
  end
end

workbook.close
