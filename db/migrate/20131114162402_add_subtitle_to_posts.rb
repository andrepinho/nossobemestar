class AddSubtitleToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :subtitle, :text
  end
end
