class AddGroupToRegion < ActiveRecord::Migration
  def change
    add_column :regions, :group, :string
  end
end
