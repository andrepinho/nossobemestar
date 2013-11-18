class AddPostalCodeToService < ActiveRecord::Migration
  def change
    add_column :services, :postal_code, :string
  end
end
