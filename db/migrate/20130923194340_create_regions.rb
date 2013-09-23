class CreateRegions < ActiveRecord::Migration
  def change
    create_table :regions do |t|
      t.string :name
      t.string :subdomain
      t.string :background_url

      t.timestamps
    end
  end
end
