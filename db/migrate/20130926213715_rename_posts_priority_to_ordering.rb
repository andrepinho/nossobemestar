class RenamePostsPriorityToOrdering < ActiveRecord::Migration
  def change
    rename_column :posts, :priority, :ordering
  end
end
