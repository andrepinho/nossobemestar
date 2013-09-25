class AddColorToSection < ActiveRecord::Migration
  def change
    add_column :sections, :color, :string
  end
end
