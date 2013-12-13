class ChangeNewsletterIdFormatInRegions < ActiveRecord::Migration
  def change
    change_column :regions, :newsletter_id, :string
  end
end
