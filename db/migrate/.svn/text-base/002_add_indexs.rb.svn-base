class AddIndexs < ActiveRecord::Migration
  def self.up
    add_index :photos, :album_id
    add_index :photos, :isAuth
    add_index :photos, :tags
    add_index :photos, :lastComment_at
    add_index :photos, :clickCount
    add_index :users, :id
    add_index :photos, :id
  end

  def self.down
    remove_index :photos, :id
    remove_index :users, :id
    remove_index :photos, :clickCount
    remove_index :photos, :lastComment_at
    remove_index :photos, :tags
    remove_index :photos, :isAuth
    remove_index :photos, :album_id
  end
end
