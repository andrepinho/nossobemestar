class CreateAds < ActiveRecord::Migration
  def change
    create_table :ads do |t|
      t.string :code
      t.datetime :starts_at
      t.datetime :ends_at
      t.attachment :image
      t.text :url
      t.text :observations

      t.timestamps
    end
  end
end
