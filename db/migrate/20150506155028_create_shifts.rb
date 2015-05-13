class CreateShifts < ActiveRecord::Migration
  def change
    create_table :shifts do |t|
      t.string :name
      t.string :location_uid, null: false
      t.time :starting_time
      t.time :ending_time

      t.timestamps null: false
    end

    add_index :shifts, :location_uid
  end
end
