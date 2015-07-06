class RenameJournalEntriesToRotaGenerationLogEntry < ActiveRecord::Migration
  def change
    rename_table :journal_entries, :rota_generation_log_entries
  end
end
