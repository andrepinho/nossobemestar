class CreateLikes < ActiveRecord::Migration
  def change
    create_table :likes do |t|
      t.references :likeable, index: true, polymorphic: true
      t.references :user, index: true

      t.timestamps
    end
  end
end
