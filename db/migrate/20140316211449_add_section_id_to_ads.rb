class AddSectionIdToAds < ActiveRecord::Migration
  def change
    add_column :ads, :section_id, :integer
  end
end
