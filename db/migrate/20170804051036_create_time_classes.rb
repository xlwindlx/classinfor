class CreateTimeClasses < ActiveRecord::Migration[5.0]
  def change
    create_table :time_classes do |t|
      # TODO time things
      t.timestamps
    end
  end
end
