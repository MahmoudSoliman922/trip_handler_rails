class CreateLocations < ActiveRecord::Migration[5.2]
  def change
    create_table :locations do |t|
      t.text :loc
      t.integer :trip_id

      t.timestamps
    end
  end
end
