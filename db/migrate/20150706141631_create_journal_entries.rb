class CreateJournalEntries < ActiveRecord::Migration
  def change
    create_table :journal_entries do |t|
      t.integer :procurement_area_id, null: false
      t.integer :total_slots, null: false
      t.datetime :start_time, null: false
      t.datetime :end_time
      t.string :status
    end
  end
end
