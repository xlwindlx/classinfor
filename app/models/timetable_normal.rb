class TimetableNormal < ApplicationRecord
  if TimetableNormal.count.zero?
    normaltable = Nokogiri::HTML(open(File.open("2017_2_normals.html")))

    @normals = normaltable.css("table#culLctTmtblDscTbl tbody tr")
    @normals.each do |t|
      weekdays =  t.css("td")[7].text.split("/")
      time, classroom = [], []

      weekdays.each do | weekday |
        time << weekday.scan(/(.*)(?:\(.*\))/).flatten.join(", ").lstrip
        classroom_tmp = weekday.scan(/.*\((.*)\)/)
        classroom << (classroom_tmp.nil? ? "" : classroom_tmp.join(", "))
      end
      time = time.reject{|x|x == ""}.join("\n")
      classroom = classroom.join("\n")
      TimetableNormal.create(
          div: t.css("td")[1].text,
          title: t.css("td.ta_l a").text.remove("(타학년 제한없음 2차때 수강가능)").remove("(타학년 제한없음, 2차때 신청가능)"),
          grades: t.css("td")[5].text,
          proffesion: t.css("td")[6].text,
          day: time.split("\n").map{|day|day[0]}.join("\n"),
          time: time,
          classroom: classroom,
          validation: t.css("td")[0].text
      )
    end
  end
end
