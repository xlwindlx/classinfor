require 'pry'
require 'rest-client'
require 'nokogiri'

require 'write_xlsx'
script_folder_path = File.dirname(__FILE__)

url = 'http://cautis.cau.ac.kr/TIS/std/usk/sUskSif002/selectList.do'
payload = '<map><year value="2017"/><shtm value="2"/><choice value="sbjt"/><searchnm value=""/></map>'
headers = {
    'Content-Type' => 'application/xml',
    'charset' => 'UTF-8',
    'Cookie' => 'PHAROS_VISITOR=muw1Q0E1ZI8; JSESSIONID=ed1c11857ebc9a3f58903865317b015153ccb82841e3b944be7a5dbc69dcd802.TIS12; SiteLog=T; ROUTEID=.TIS12; lastAccess=1502708063530; Lib1Proxy2Ssn=27028788; LP1121SID=27028788; NCAUPOLICYNUM=64; ncautoken=ee189558b7888ea0ae5b6a3b7bee53c5150764cd703f1084efe695bfd27f463ba72e07ddc47b70d758800fc4c87ee545d5980d3b1e18d3238408fb65f852ddb1961076a15ce58c80620e8fbf6025f7727abc438e8ae44b8a3ffc2ca2; ncaucookie=c7b62f44750d3a64987143ea78768982d523e54ccc13d9fc22f0f45d6804f93bced2f14ac9d0e6b2fa513bf51922acdb724482bac5c4c855de595b5ff268c680d8d0266782152aab81355bf55194202c3c600b0071f71bd2a223c836263c4a523add578cd4eb29d233be741c219f3d86ea3f7f8b1053878cd10405545391d1a776e00c34327f7a34292b0a1183c97771b8975af1a518046cabe492ae206074d0a282ce1785a3dd749ddbe420e288392738b896742c502db3f79e2e87f8dfc2c559efc76b91e24a9c13bb107cef6e3a8499594aff08677c5c6b4a9a3af6ba394a4b5fca35a3eff79b18cd63a672c0aee03853b7d212426577ecdafc0ab63f3c5ae422a5b54eaa91ab5e14edf3abed8bc27601ffad9cd77ca8626bbb187226a3804974779d2561a7e7da65d72195033608b686e27478a2d8bcc9045d7e51a40819cd92a4f366f7e504153e87a827a1cb8324fc8097e35e12d022b19765413864af64bbec963925a00ef734239d866ec460899088cfedc7d62332d4ae6a12db327302fb7ea81b549e4e2dd5b58a545b12a586eafb7175b02d23590466e1ff7b349c0ab84970b01345c377b3089a5cd23a2ba6d88ae279fcc6b2a2a5e476d94c451bf28abc28bf9371c8808641d72c0431af0a5a3f3e4e3b549c6465f59153fe516bcac25c565078437c250da8360478379e; CAUAUTH=9a8b04a77ef17eed2b1a52faec2fbba752078ba371b37b874e99e02e3d0629c997d440c3c313870041dd7c6599899b961a0ad43c740d9e44b3b9a3d8fb91cda5928e568431a625894532a4f285c341ba77d74136aed3305801820179; nssoauthdomain=b39f0f3a11fa4a85d6b99f8541d8134b; caucookie=camcd%3d74cdce33b8a08df6%2ccaukd%3ddf39e7e2d9e40c48%2ccaunm%3dcffa67c85bee8cec7dae2b2c2a576c9f%2cdefault%3da157c53d74963e0c184e8a7d4360de31%2cdeptcd%3db23024651cde8857%2cdeptnm%3d292fff09801b4a7aaf7b6071b5449d20%2clibcd%3d74cdce33b8a08df6%2cname%3d9fedaaf84913384f%2coutsyscd%3d74cdce33b8a08df6%2cregst%3ddf39e7e2d9e40c48%2cuid%3d36fd39035288b742; _ga=GA1.3.745490672.1499409988; _gid=GA1.3.1825558377.1502709458; cautoken=8467d945eb3c46427a0da94d1c3a9ce1117a41d79ca4ac43476be91401ed15088739e7222a764f6aff1cc3fdcc9bf660936e0505af886013abb07dc9f2b014676e187177b33000bce6451e48279233c477d74136aed3305801820179; globalDebug=false'
}
responce = RestClient.post(url, payload, headers).body
parse = Nokogiri::HTML.parse(responce)
#puts parse.xpath('//map//map')
lectures = parse.xpath('//map//map')

#binding.pry

attr_hash = {}
lectures_array = []

lectures.each do |lectures|
  one_lecture = {} #초기화
  lectures.children.each do |col|
    attr_hash[col.name] = 1 #키값들 저장
    one_lecture[col.name] = col.attributes["value"].value #value저장
  end
  lectures_array.push(one_lecture) #array에 대입
end

workbook = WriteXLSX.new("#{script_folder_path}/cau_lectures/lectures_class.xlsx")
worksheet = workbook.add_worksheet
i = 0
j = 0
attr_hash.each do |k, v|
  worksheet.write(i, j, k)
  j += 1
end
i += 1
lectures_array.each do |lecture|
  j = 0
  attr_hash.each do |k, v|
    worksheet.write(i, j, lecture[k])
    j += 1
  end
  i += 1
end
workbook.close