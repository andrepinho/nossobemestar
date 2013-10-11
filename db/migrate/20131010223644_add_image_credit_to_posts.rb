class AddImageCreditToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :image_credit, :string
  end
end
