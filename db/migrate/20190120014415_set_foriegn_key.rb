class SetForiegnKey < ActiveRecord::Migration[5.2]
  def change
    add_foreign_key :locations, :trips
  end
end
