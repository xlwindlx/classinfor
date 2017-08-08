class CreateTimetableMajors < ActiveRecord::Migration[5.0]
  def change
    create_table :timetable_majors do |t|
      t.string :div         #이수구분
      t.string :title       #과목명
      t.integer :grades     #학점
      t.integer :grade      #학년
      t.string :subject     #전공명
      t.string :proffesion  #교강사
      t.string :day         #요일
      t.string :time        #시간
      t.string :classroom   #강의실
      t.string :validation  #식별자
      t.timestamps
    end
  end
end
