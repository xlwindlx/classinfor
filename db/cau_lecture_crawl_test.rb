require 'rest-client'
require 'pry'
require 'nokogiri'
require 'write_xlsx'

url = 'http://sugang.cau.ac.kr/TIS/std/usk/sUskSif001/selectSust.do'
payload = '<map><year value="2017"/><campfg value="1"/><course value="3"/><gb value="3"/><colgcd value="3B400"/><shtm value="2"/></map>'
headers = {
    'Content-Type' => 'application/xml',
    'charset' => 'UTF-8',
    'Cookie' => 'PHAROS_VISITOR=DkI0oMzHY3q; JSESSIONID=4e8cedc0b4af0abbfc0d9d53cacf176639318659ffb1d559dddab3d19b6c9913.TIS23; Lib1Proxy2Ssn=236754929; _ga=GA1.3.745490672.1499409988; ROUTEID=.TIS23; SiteLog=T; lastAccess=1502440528623; CAUAUTH=837fc0786803dbab22397151beaf58ef3142722ab4baa796bf2e520e6a1a52f6815f4a620e94cbf32234603a4529b693826bab1fdaa7e033254a5d3600dab52e6890a637b135a4742c36afd0ea73de7df9b6467692236c050f235bb2; nssoauthdomain=b39f0f3a11fa4a85d6b99f8541d8134b; caucookie=camcd%3d74cdce33b8a08df6%2ccaukd%3ddf39e7e2d9e40c48%2ccaunm%3dcffa67c85bee8cec7dae2b2c2a576c9f%2cdefault%3da157c53d74963e0c184e8a7d4360de31%2cdeptcd%3db23024651cde8857%2cdeptnm%3d292fff09801b4a7aaf7b6071b5449d20%2clibcd%3d74cdce33b8a08df6%2cname%3d9fedaaf84913384f%2coutsyscd%3d74cdce33b8a08df6%2cregst%3ddf39e7e2d9e40c48%2cuid%3d36fd39035288b742; NetFunnel_ID=; cautoken=13e6c65ee2ec0c53fa4dc8bfd7fce4c3f2bed29d16a7f96f9fbed238f44b00c92d31ca02d69a2d8ea0b57b0989a006337c21638c00a46d7849dab93752e20d3b9df4358b36fdba7f9941dfb6e46e0175f9b6467692236c050f235bb2; globalDebug=false'
}
big_a = RestClient.post(url, payload, headers)
big_doc = Nokogiri::HTML.parse(big_a.body)
deps = big_doc.xpath('//map//map')

script_folder_path = File.dirname(__FILE__)
workbook = WriteXLSX.new("#{script_folder_path}/cau_lectures/params.xlsx")
worksheet = workbook.add_worksheet
i = 0

array_deps = []
deps.each do |d|
  temp = {}
  j = 0
  d.children.each do |attr| # camp, colg!, sustcd!, clfycd, deptcd, nm, ord
    temp[attr.name] = attr.attributes["value"].value
    worksheet.write(i, j, temp[attr.name])
    j += 1
  end
  array_deps.push(temp)
  i += 1
end
workbook.close

workbook = WriteXLSX.new("#{script_folder_path}/cau_lectures/l1.xlsx")
worksheet = workbook.add_worksheet
i = 0
attr_hash = {}

array_deps.each do |d|
  deptcd = d['deptcd']

  url = 'http://sugang.cau.ac.kr/TIS/std/usk/sUskSif001/selectSbjt.do'
  payload = '<map><year value="2017"/><campfg value="1"/><course value="3"/><gb value="3"/><colgcd value="3B400"/><shtm value="2"/><sust value="' + deptcd + '"/><search_gb value="ELSE"/><kornm value=""/></map>'
  headers = {
      'Content-Type' => 'application/xml',
      'charset' => 'UTF-8',
      'Cookie' => 'PHAROS_VISITOR=DkI0oMzHY3q; JSESSIONID=e21c6dc8435f90c5655a77eb46e633680e569c9b345c01cca844f51ad741d580.TIS23; Lib1Proxy2Ssn=236754929; _ga=GA1.3.745490672.1499409988; ROUTEID=.TIS23; SiteLog=T; lastAccess=1502440528623; CAUAUTH=d27fb3034248cf57fbb797adeff664b425abbf971ec7f9ee8e48359365be38c0b062c281e9ff01d5b25b5688df57d2001cfab400b58c3280605c8eb5e0034b04e1e6d4e62f525e271c9028919a7b5ceac4394d67b01cc77a124ec3af; nssoauthdomain=b39f0f3a11fa4a85d6b99f8541d8134b; caucookie=camcd%3d74cdce33b8a08df6%2ccaukd%3ddf39e7e2d9e40c48%2ccaunm%3dcffa67c85bee8cec7dae2b2c2a576c9f%2cdefault%3da157c53d74963e0c184e8a7d4360de31%2cdeptcd%3db23024651cde8857%2cdeptnm%3d292fff09801b4a7aaf7b6071b5449d20%2clibcd%3d74cdce33b8a08df6%2cname%3d9fedaaf84913384f%2coutsyscd%3d74cdce33b8a08df6%2cregst%3ddf39e7e2d9e40c48%2cuid%3d36fd39035288b742; NetFunnel_ID=; cautoken=13e6c65ee2ec0c53904d63c57696953fa24633b8832d44de287e20b1c774921b3a3f07b0f219c2381de8822b5f980a05debdf56cfe13f45cc867bcaf36fe5ac7fe96c511865b2fbefd3722eb04e8a88ac4394d67b01cc77a124ec3af; globalDebug=false'
  }
  a = RestClient.post(url, payload, headers)
  doc = Nokogiri::HTML.parse(a.body)

  lectures = doc.xpath('//map//map')

  lectures_array = []
  lectures.each do |lecture|
    lecture_one = {}
    lecture.children.each do |column|
      lecture_one[column.name] = column.attributes["value"].value
      attr_hash[column.name] = 1
    end
    lectures_array.push(lecture_one)
  end

  attr_list = []
  attr_hash.each do |k, v|
    attr_list.push(k)
  end

  if i == 0
    j = 0
    attr_list.each do |attr|
      worksheet.write(i, j, attr)
      j += 1
    end
    i += 1
  end

  lectures_array.each do |l|
    j = 0
    attr_list.each do |attr|
      worksheet.write(i, j, l[attr]) unless l[attr].nil?
      j += 1
    end
    i += 1
  end
end
workbook.close
#binding.pry
__END__
#doc.document.children[0].children[1].children[0].attributes["id"].value
  #doc.document.children[0].children[1].children[0].children[0].name

#파일을 다 저장한 다음에 해야할듯
=begin
colgnm 대학
sustnm 학부
pobtnm 전공교양
sbjtclass 과목번호
clssnm 과목명

=end
list = %w(colgnm sustnm shyr pobtnm sbjtclss sbjtclsslk sbjtno clssno clssnm clssnmlk pnt profnm profnmlk ltbdrm remk campcd sust corscd comsut shyr2 pobtfg cnt n empno clsefg]