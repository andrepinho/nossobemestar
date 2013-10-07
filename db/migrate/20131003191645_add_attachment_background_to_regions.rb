class AddAttachmentBackgroundToRegions < ActiveRecord::Migration
  def self.up
    change_table :regions do |t|
      t.attachment :background
    end
  end

  def self.down
    drop_attached_file :regions, :background
  end
end
