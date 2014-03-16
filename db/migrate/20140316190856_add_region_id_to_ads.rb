class AddRegionIdToAds < ActiveRecord::Migration
  def change
    add_column :ads, :region_id, :integer
  end
end
