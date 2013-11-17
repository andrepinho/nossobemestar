class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :name
      t.datetime :starts_at
      t.datetime :ends_at
      t.attachment :image
      t.text :description
      t.string :address
      t.string :url
      t.string :email
      t.string :phone_number

      t.timestamps
    end
  end
end
