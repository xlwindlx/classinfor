class CreateBuildings < ActiveRecord::Migration[5.0]
  def change
    create_table :buildings do |t|
      t.string :loc
      t.string :name
      t.timestamps
    end
  end
end
