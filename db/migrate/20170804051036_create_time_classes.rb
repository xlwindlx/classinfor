class CreateTimeClasses < ActiveRecord::Migration[5.0]
  def change
    create_table :time_classes do |t|
      t.string :week
      t.integer :st
      t.integer :fi
      # 7(14) 7.5(15) 8(16) 8.5(17) 9(18) 9.5(19) 10(20) 10.5(21) 11(22) 11.5(23)
      #12(24) 12.5(25) 13(26) 13.5(27) 14(28) 14.5(29) 15(30) 15.5(31) 16(32) 16.5(33)
      #17(34) 17.5(35) 18(36) 18.5(37) 19(38) 19.5(39) 20(40)

      t.integer :lecture_id, foreign_key: true
      t.integer :room_id, foreign_key: true
      t.timestamps
    end
  end
end
