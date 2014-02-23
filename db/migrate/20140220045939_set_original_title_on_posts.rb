class SetOriginalTitleOnPosts < ActiveRecord::Migration
  def up
    execute("UPDATE posts SET original_title = title")
  end
  def down
    execute("UPDATE posts SET original_title = null")
  end
end
