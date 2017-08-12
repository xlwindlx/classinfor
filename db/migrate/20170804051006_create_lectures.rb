class CreateLectures < ActiveRecord::Migration[5.0]
  def change
    create_table :lectures do |t|
      t.string :name
      t.string :professor
      t.integer :semaster # 201702
      t.integer :grade    # 01

      t.timestamps
    end
  end
end
