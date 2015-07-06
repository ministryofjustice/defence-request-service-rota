class AddUserIdToRotaGenerationLogEntry < ActiveRecord::Migration
  def change
    add_column :rota_generation_log_entries, :user_id, :integer, null: false
  end
end
