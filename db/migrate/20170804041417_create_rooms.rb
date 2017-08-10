class CreateRooms < ActiveRecord::Migration[5.0]
  def change

    create_table :rooms do |t|

      t.integer :buliding
      t.string :department

      t.integer :floor #층
      t.string :loc #위치
      t.integer :capacity #정원

      t.integer :level #관리레벨(0=팀플, 1=강의실, 2=특수강의실, 3=비대여강의실)

      t.integer :building_id, foreign_key: true
      t.integer :department_id, foreign_key: true
      t.timestamps
    end

  end
end
