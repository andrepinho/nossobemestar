class AddSessionToPosts < ActiveRecord::Migration
  def change
    add_reference :posts, :session, index: true
  end
end
