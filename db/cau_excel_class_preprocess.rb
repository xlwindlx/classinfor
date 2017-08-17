require 'pry'
require 'roo' # read
require 'write_xlsx' # write

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

1...year.size.each do |i|
  ltbdrm[i]
  profnm[i]
  campcd[i]

  sbjtno1[i]
  clssno1[i]

  year[i]
  shtm[i]

  shtnm[i]
  colgnm[i]
end

def colgnm_2_major(colgnm)
  str = colgnm.split('<br>')
  major1 = str[0]
  major2 = str[1] unless str[1].nil?
  [str.size, major1, major2]
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

def ltbdrm_2_time(ltbdrm)
  return nil unless ltbdrm_has_room?(ltbdrm)
  classes = ltbdrm.split('>')[1].split('/')


  if classes.class == ''.class
    classes_arr = [classes]
  else
    classes_arr = []
    classes.each_with_index do |c, j|
      classes_arr[j] = c
    end
  end

  classes_arr.each do |str|
    yoyil = []
    %w(월 화 수 목 금 토 일).each do |week|
      yoyil = week
      break str.include?(week)
    end

    str.index(yoyil)

  end
end