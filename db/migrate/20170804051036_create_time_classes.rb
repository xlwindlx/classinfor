class CreateTimeClasses < ActiveRecord::Migration[5.0]
  def change
    create_table :time_classes do |t|
      t.string :week
      t.integer :st
      t.integer :fi
      # 700 710 720 730 740 750 800...
      # 2400

      t.integer :lecture_id, foreign_key: true
      t.integer :room_id, foreign_key: true
      t.timestamps
    end
  end
end
