class AddNewsletterIdToRegions < ActiveRecord::Migration
  def change
    add_column :regions, :newsletter_id, :integer
  end
end
