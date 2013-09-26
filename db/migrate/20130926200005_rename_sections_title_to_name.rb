class RenameSectionsTitleToName < ActiveRecord::Migration
  def change
    rename_column :sections, :title, :name
  end
end
