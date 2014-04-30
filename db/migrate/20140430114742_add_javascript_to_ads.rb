class AddJavascriptToAds < ActiveRecord::Migration
  def change
    add_column :ads, :javascript, :text
  end
end
