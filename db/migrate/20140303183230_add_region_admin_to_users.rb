class AddRegionAdminToUsers < ActiveRecord::Migration
  def change
    add_column :users, :region_admin, :boolean, default: false
  end
end
