class RenamePostsSessionIdToSectionId < ActiveRecord::Migration
  def change
    rename_column :posts, :session_id, :section_id
  end
end
