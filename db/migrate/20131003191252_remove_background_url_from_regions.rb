class RemoveBackgroundUrlFromRegions < ActiveRecord::Migration
  def change
    remove_column :regions, :background_url, :string
  end
end
