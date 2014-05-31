class CreateDislikes < ActiveRecord::Migration
  def change
    create_table :dislikes do |t|
      t.references :dislikeable, index: true, polymorphic: true
      t.references :user, index: true

      t.timestamps
    end
  end
end
