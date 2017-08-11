class CreateRoomComments < ActiveRecord::Migration[5.0]
  def change
    create_table :room_comments do |t|
      t.belongs_to :user
      t.string :content

      t.integer :room_id, foreign_key: true
      t.timestamps
    end
  end
end
