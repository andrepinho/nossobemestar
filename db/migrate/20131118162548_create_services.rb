class CreateServices < ActiveRecord::Migration
  def change
    create_table :services do |t|
      t.string :name
      t.attachment :image
      t.text :description
      t.string :address
      t.string :url
      t.string :email
      t.string :phone_number
      t.references :region, index: true
      t.float :latitude
      t.float :longitude

      t.timestamps
    end
  end
end
