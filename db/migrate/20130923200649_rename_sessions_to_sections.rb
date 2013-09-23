class RenameSessionsToSections < ActiveRecord::Migration
  def change
    rename_table :sessions, :sections
  end
end
