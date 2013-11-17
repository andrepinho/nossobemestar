class AddRegionIdToEvents < ActiveRecord::Migration
  def change
    add_column :events, :region_id, :integer
  end
end
