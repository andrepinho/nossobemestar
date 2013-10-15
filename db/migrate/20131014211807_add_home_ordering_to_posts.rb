class AddHomeOrderingToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :home_ordering, :integer
  end
end
