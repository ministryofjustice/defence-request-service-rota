class CreateRotaSlots < ActiveRecord::Migration
  def change
    create_table :rota_slots do |t|
      t.date :date, null: false
      t.integer :shift_id, null: false
      t.uuid :organisation_uid, null: false
    end
  end
end
