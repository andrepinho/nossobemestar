class SetSubtitleOnPosts < ActiveRecord::Migration
  def up
    execute("UPDATE posts SET subtitle = front_content")
  end
  def down
    execute("UPDATE posts SET subtitle = null")
  end
end
