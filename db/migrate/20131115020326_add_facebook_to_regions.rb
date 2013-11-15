class AddFacebookToRegions < ActiveRecord::Migration
  def change
    add_column :regions, :facebook, :string
  end
end
