class CreateLectures < ActiveRecord::Migration[5.0]
  def change
    create_table :lectures do |t|
      t.string :name
      t.string :professor
      t.integer :campus

      t.integer :subjno # 37550
      t.integer :subjclass # 1~

      t.integer :year # 2017
      t.integer :semaster # 2

      t.string :classify
      t.string :major1
      t.string :major2

      t.integer :room_id, foreign_key: true

      t.integer :grade    # 1~4
      t.integer :mynum
      t.timestamps
    end
  end
end
