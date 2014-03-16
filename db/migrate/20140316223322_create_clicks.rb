class CreateClicks < ActiveRecord::Migration
  def change
    create_table :clicks do |t|
      t.references :ad, index: true
      t.string :ip

      t.timestamps
    end
  end
end
