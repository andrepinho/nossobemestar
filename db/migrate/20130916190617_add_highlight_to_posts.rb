class AddHighlightToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :front_title, :string
    add_column :posts, :front_content, :text
    add_column :posts, :priority, :integer
  end
end