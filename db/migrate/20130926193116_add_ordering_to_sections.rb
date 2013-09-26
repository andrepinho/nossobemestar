class AddOrderingToSections < ActiveRecord::Migration
  def change
    add_column :sections, :ordering, :integer
  end
end
