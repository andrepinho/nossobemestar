class AddEventIdAndServiceIdToAds < ActiveRecord::Migration
  def change
    add_column :ads, :event_id, :integer
    add_column :ads, :service_id, :integer
  end
end
