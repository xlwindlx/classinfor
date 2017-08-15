class CreateBuildings < ActiveRecord::Migration[5.0]
  def change
    create_table :buildings do |t|
      t.integer :number
      t.string :name

      t.integer :have_floors
      t.integer :valid_floors
      # 이진수로 32bit 기록할것
      # 지하 -6(0) -5(1) -4(2) -3(3) -2(4) -1(5) 1(6) 2(7) 3(8) 4(9) 5(10) 6(11) 7(12) 8(13) 9(14) 10(15)

      t.timestamps
    end
  end
end
