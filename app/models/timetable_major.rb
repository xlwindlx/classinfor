class TimetableMajor < ApplicationRecord
  if TimetableMajor.count.zero?
    proftable = Nokogiri::HTML(open(File.open("2017_2_profession.html")))

    @profs = proftable.css("table#mjLctTmtblDscTbl tbody tr")
    @profs.each do |f|
      weekdays =  f.css("td")[9].text.split("/")
      time, classroom = [], []

      weekdays.each do | weekday |
        time << weekday.scan(/(.*)(?:\(.*\))/).flatten.join(", ").lstrip
        classroom_tmp = weekday.scan(/.*\((.*)\)/)
        classroom << (classroom_tmp.nil? ? "" : classroom_tmp.join(", "))
      end
      time = time.reject{|x|x == ""}.join("\n")
      classroom = classroom.join("\n")
      TimetableMajor.create(
          div: f.css("td")[3].text,
          title: f.css("td.ta_l a").text,
          grades: f.css("td")[7].text,
          proffesion: f.css("td")[8].text,
          day: time.split("\n").map{|day|day[0]}.join("\n"),
          time: time,
          classroom: classroom,
          grade: f.css("td")[2].text,
          subject: f.css("td")[1].text,
          validation: f.css("td")[0].text
      )
    end
  end
end
