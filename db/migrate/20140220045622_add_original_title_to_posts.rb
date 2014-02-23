class AddOriginalTitleToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :original_title, :string
  end
end
