require 'pry'
require 'rest-client'
require 'nokogiri'

require 'write_xlsx'
script_folder_path = File.dirname(__FILE__)

# 선택 '서울' -> 각대학 id : deptcd
url = 'http://sugang.cau.ac.kr/TIS/std/usk/sUskSif001/selectParam.do'
payload = '<map><year value="2017"/><campfg value="1"/><course value="3"/><gb value="3"/><colgcd value="3B300"/><shtm value="2"/><sust value="3B310"/><search_gb value="ELSE"/><kornm value=""/></map>'
headers = {
    'Content-Type' => 'application/xml',
    'charset' => 'UTF-8',
    'Cookie' => 'PHAROS_VISITOR=DkI0oMzHY3q; JSESSIONID=d9fde4afc54b813300113fa292cd31a5f01e35e1eef37303be67be5516a59837.TIS23; Lib1Proxy2Ssn=236754929; _ga=GA1.3.745490672.1499409988; ROUTEID=.TIS23; SiteLog=T; lastAccess=1502440528623; CAUAUTH=1580fe73799e0c2df76cd962fbffeaaad73fddaa3d7368f59766a82519ac6c3730d878cc5b3ecb5e014b51760634a9fa6e076729333f4ff907b6ab4a3e1ae6567ffcef0686b23687a9fc3b612c446cc6be3146b58d1618865a2744b7; nssoauthdomain=b39f0f3a11fa4a85d6b99f8541d8134b; caucookie=camcd%3d74cdce33b8a08df6%2ccaukd%3ddf39e7e2d9e40c48%2ccaunm%3dcffa67c85bee8cec7dae2b2c2a576c9f%2cdefault%3da157c53d74963e0c184e8a7d4360de31%2cdeptcd%3db23024651cde8857%2cdeptnm%3d292fff09801b4a7aaf7b6071b5449d20%2clibcd%3d74cdce33b8a08df6%2cname%3d9fedaaf84913384f%2coutsyscd%3d74cdce33b8a08df6%2cregst%3ddf39e7e2d9e40c48%2cuid%3d36fd39035288b742; NetFunnel_ID=; cautoken=13e6c65ee2ec0c53802162bdaf071210d2d2140e9adce2b558f2de4a985de0d87babb0ea138d08371199c735408784f9d52bd341b1c5ffad1a0fd8b9c2ca4aec09dd06ff5c3773fc49465dc57c46765ebe3146b58d1618865a2744b7; globalDebug=false'
}
small_univs = Nokogiri::HTML.parse(RestClient.post(url, payload, headers).body).xpath('//map//map')

# XML => HASH => ARRAY
array_small_univs = []
small_univ_attr_hash = {}

small_univs.each do |small_univ|
  one_small_univ = {}
  small_univ.children.each do |col|
    one_small_univ[col.name] = col.attributes["value"].value
    small_univ_attr_hash[col.name] = 1
  end
  array_small_univs.push(one_small_univ)
end

# ARRAY => (HASH) => XLSX
workbook = WriteXLSX.new("#{script_folder_path}/cau_lectures/smallUniv.xlsx")
worksheet = workbook.add_worksheet
i = 0
array_small_univs.each do |one|

  j = 0
  if i == 0
    small_univ_attr_hash.each do |k, v|
      worksheet.write(i, j, k)
      j += 1
    end
    i += 1
  end

   j = 0
  small_univ_attr_hash.each do |k, v|
    worksheet.write(i, j, one[k]) if one[k]
    j += 1
  end
  i += 1

end
workbook.close
puts '단과대가 끝났습니다..'

# 선택 '각대학' -> 각과 id : deptcd
univ_major_attr_hash = {}
array_univ_majors = []
array_small_univs.each do |one|
  next if one['deptcd'].nil?
  url = 'http://sugang.cau.ac.kr/TIS/std/usk/sUskSif001/selectSust.do'
  payload = '<map><year value="2017"/><campfg value="1"/><course value="3"/><gb value="3"/><colgcd value="'+one['deptcd']+'"/><shtm value="2"/><sust value="3B310"/><search_gb value="ELSE"/><kornm value=""/></map>'
  headers = {
      'Content-Type' => 'application/xml',
      'charset' => 'UTF-8',
      'Cookie' => 'PHAROS_VISITOR=DkI0oMzHY3q; JSESSIONID=d9fde4afc54b813300113fa292cd31a5f01e35e1eef37303be67be5516a59837.TIS23; Lib1Proxy2Ssn=236754929; _ga=GA1.3.745490672.1499409988; ROUTEID=.TIS23; SiteLog=T; lastAccess=1502440528623; CAUAUTH=1580fe73799e0c2df76cd962fbffeaaad73fddaa3d7368f59766a82519ac6c3730d878cc5b3ecb5e014b51760634a9fa6e076729333f4ff907b6ab4a3e1ae6567ffcef0686b23687a9fc3b612c446cc6be3146b58d1618865a2744b7; nssoauthdomain=b39f0f3a11fa4a85d6b99f8541d8134b; caucookie=camcd%3d74cdce33b8a08df6%2ccaukd%3ddf39e7e2d9e40c48%2ccaunm%3dcffa67c85bee8cec7dae2b2c2a576c9f%2cdefault%3da157c53d74963e0c184e8a7d4360de31%2cdeptcd%3db23024651cde8857%2cdeptnm%3d292fff09801b4a7aaf7b6071b5449d20%2clibcd%3d74cdce33b8a08df6%2cname%3d9fedaaf84913384f%2coutsyscd%3d74cdce33b8a08df6%2cregst%3ddf39e7e2d9e40c48%2cuid%3d36fd39035288b742; NetFunnel_ID=; cautoken=13e6c65ee2ec0c53802162bdaf071210d2d2140e9adce2b558f2de4a985de0d87babb0ea138d08371199c735408784f9d52bd341b1c5ffad1a0fd8b9c2ca4aec09dd06ff5c3773fc49465dc57c46765ebe3146b58d1618865a2744b7; globalDebug=false'
  }
  majors = Nokogiri::HTML.parse(RestClient.post(url, payload, headers).body).xpath('//map//map')

  # XML => HASH => ARRAY
  majors.each do |major|
    one_major = {}
    one_major['univdeptcd'] = one['deptcd']
    one_major['univname'] = one['deptkornm']
    univ_major_attr_hash['univdeptcd'] = 1
    univ_major_attr_hash['univname'] = 1

    major.children.each do |col|
      one_major[col.name] = col.attributes["value"].value
      univ_major_attr_hash[col.name] = 1
    end
    array_univ_majors.push(one_major)
  end
end

# ARRAY => (HASH) => XLSX
workbook = WriteXLSX.new("#{script_folder_path}/cau_lectures/majors.xlsx")
worksheet = workbook.add_worksheet
i = 0
array_univ_majors.each do |major|

  j = 0
  if i == 0
    univ_major_attr_hash.each do |k, v|
      worksheet.write(i, j, k)
      j += 1
    end
    i += 1
  end

  j = 0
  univ_major_attr_hash.each do |k, v|
    worksheet.write(i, j, major[k]) if major[k]
    j += 1
  end
  i += 1

end
workbook.close
puts '각 전공에 대한 정보 수집이 종료되었습니다'

puts '강의들을 수집합니다'
# 각 단과대의 전공 선택 -> 강의들 [한번에 하는게 관건]
lecture_attr_hash = {}

workbook = WriteXLSX.new("#{script_folder_path}/cau_lectures/lectures.xlsx")
worksheet = workbook.add_worksheet
i = 1

array_univ_majors.each do |major|
  print "#{major['univname']}|(대학) #{major['nm']}|(전공) 요청하여 진행합니다 "
  worksheet.write(i, 0, 'A')
  worksheet.write(i, 1, major['univname'])
  worksheet.write(i, 2, major['nm'])
  i += 1

  url = 'http://sugang.cau.ac.kr/TIS/std/usk/sUskSif001/selectSbjt.do'
  if major['clfycd'].nil?
    payload = '<map><year value="2017"/><campfg value="1"/><course value="3"/><gb value="3"/><colgcd value="'+major['univdeptcd']+'"/><shtm value="2"/><sust value="'+major['deptcd']+'"/><search_gb value="'+major['univdeptcd']+'"/><kornm value=""/></map>'
  else
    payload = '<map><year value="2017"/><campfg value="1"/><course value="3"/><gb value="3"/><colgcd value="'+major['univdeptcd']+'"/><shtm value="2"/><sust value="'+major['deptcd']+'"/><search_gb value="ELSE"/><kornm value=""/></map>'
  end
  headers = {
      'Content-Type' => 'application/xml',
      'charset' => 'UTF-8',
      'Cookie' => 'PHAROS_VISITOR=DkI0oMzHY3q; JSESSIONID=d9fde4afc54b813300113fa292cd31a5f01e35e1eef37303be67be5516a59837.TIS23; Lib1Proxy2Ssn=236754929; _ga=GA1.3.745490672.1499409988; ROUTEID=.TIS23; SiteLog=T; lastAccess=1502440528623; CAUAUTH=1580fe73799e0c2df76cd962fbffeaaad73fddaa3d7368f59766a82519ac6c3730d878cc5b3ecb5e014b51760634a9fa6e076729333f4ff907b6ab4a3e1ae6567ffcef0686b23687a9fc3b612c446cc6be3146b58d1618865a2744b7; nssoauthdomain=b39f0f3a11fa4a85d6b99f8541d8134b; caucookie=camcd%3d74cdce33b8a08df6%2ccaukd%3ddf39e7e2d9e40c48%2ccaunm%3dcffa67c85bee8cec7dae2b2c2a576c9f%2cdefault%3da157c53d74963e0c184e8a7d4360de31%2cdeptcd%3db23024651cde8857%2cdeptnm%3d292fff09801b4a7aaf7b6071b5449d20%2clibcd%3d74cdce33b8a08df6%2cname%3d9fedaaf84913384f%2coutsyscd%3d74cdce33b8a08df6%2cregst%3ddf39e7e2d9e40c48%2cuid%3d36fd39035288b742; NetFunnel_ID=; cautoken=13e6c65ee2ec0c53802162bdaf071210d2d2140e9adce2b558f2de4a985de0d87babb0ea138d08371199c735408784f9d52bd341b1c5ffad1a0fd8b9c2ca4aec09dd06ff5c3773fc49465dc57c46765ebe3146b58d1618865a2744b7; globalDebug=false'
  }
  lectures = Nokogiri::HTML.parse(RestClient.post(url, payload, headers).body).xpath('//map//map')

  # 단과대|전공 : 의 강의들
  # XML => HASH => ARRAY
  array_lectures = []
  lectures.each do |lecture|
    one_lecture = {}
    lecture.children.each do |col|
      one_lecture[col.name] = col.attributes["value"].value
      lecture_attr_hash[col.name] = 1
    end
    array_lectures.push(one_lecture)
  end

  # ARRAY => XLSX
  array_lectures.each do |lecture|
    j = 0
    lecture_attr_hash.each do |k, v|
      worksheet.write(i, j, lecture[k]) if lecture[k]
      j += 1
    end
    i += 1
  end
  puts '(' + i.to_s + ')'
end
i = j = 0
lecture_attr_hash.each do |k, v|
  worksheet.write(i, j, k)
  j += 1
end
workbook.close
puts '강의수집종료'
