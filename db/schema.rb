# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of ActiveRecord to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 2) do

  create_table "albumcomments", :force => true do |t|
    t.integer  "album_id",       :limit => 10, :null => false
    t.text     "content",                      :null => false
    t.datetime "datetime",                     :null => false
    t.integer  "commentator_id", :limit => 10, :null => false
    t.integer  "user_id",        :limit => 10, :null => false
  end

  create_table "albums", :force => true do |t|
    t.integer  "user_id",        :limit => 10,                     :null => false
    t.string   "name",           :limit => 100, :default => "",    :null => false
    t.text     "description"
    t.datetime "datetime",                                         :null => false
    t.integer  "coverPhoto_id",  :limit => 10
    t.integer  "clickCount",     :limit => 10,  :default => 0,     :null => false
    t.integer  "downloadCount",  :limit => 10,  :default => 0,     :null => false
    t.integer  "downloadPoint",  :limit => 10,  :default => 5,     :null => false
    t.boolean  "isPacked",                      :default => false, :null => false
    t.string   "packName",       :limit => 45
    t.boolean  "isMiddlePacked",                :default => false, :null => false
    t.string   "middlePackName", :limit => 45
  end

  create_table "comments", :force => true do |t|
    t.integer  "photo_id",       :limit => 10
    t.text     "content"
    t.datetime "datetime",                     :null => false
    t.integer  "commentator_id", :limit => 10
    t.integer  "user_id",        :limit => 10
  end

  create_table "expressmails", :force => true do |t|
    t.string   "photoIDs", :default => "", :null => false
    t.datetime "datetime",                 :null => false
  end

  create_table "favorites", :force => true do |t|
    t.integer  "photo_id", :limit => 10, :null => false
    t.integer  "user_id",  :limit => 10, :null => false
    t.integer  "owner_id", :limit => 10, :null => false
    t.datetime "datetime",               :null => false
  end

  create_table "friends", :force => true do |t|
    t.integer  "user_id",   :limit => 10, :null => false
    t.integer  "friend_id", :limit => 10, :null => false
    t.datetime "datetime",                :null => false
  end

  create_table "messages", :force => true do |t|
    t.integer  "receiver_id",     :limit => 10,                 :null => false
    t.integer  "sender_id",       :limit => 10,                 :null => false
    t.text     "content",                                       :null => false
    t.datetime "sendDatetime",                                  :null => false
    t.datetime "receiveDatetime",                               :null => false
    t.string   "senderName",      :limit => 30, :default => "", :null => false
    t.boolean  "new",                                           :null => false
    t.string   "title",                         :default => "", :null => false
    t.integer  "delStatus",       :limit => 10,                 :null => false
  end

  create_table "photos", :force => true do |t|
    t.integer  "album_id",       :limit => 10,                    :null => false
    t.integer  "user_id",        :limit => 10,                    :null => false
    t.string   "filename",                     :default => "",    :null => false
    t.datetime "datetime",                                        :null => false
    t.text     "description"
    t.string   "tags"
    t.integer  "width",          :limit => 10,                    :null => false
    t.integer  "height",         :limit => 10,                    :null => false
    t.integer  "filesize",       :limit => 10,                    :null => false
    t.string   "originalName",                 :default => "",    :null => false
    t.boolean  "isAuth",                       :default => false, :null => false
    t.integer  "clickCount",     :limit => 10, :default => 0,     :null => false
    t.datetime "lastComment_at"
    t.integer  "private",        :limit => 10, :default => 0,     :null => false
    t.integer  "commentsCount",                :default => 0,     :null => false
    t.integer  "addFavorCount",                :default => 0,     :null => false
  end

  add_index "photos", ["album_id"], :name => "index_photos_on_album_id"
  add_index "photos", ["isAuth"], :name => "index_photos_on_isAuth"
  add_index "photos", ["tags"], :name => "index_photos_on_tags"
  add_index "photos", ["lastComment_at"], :name => "index_photos_on_lastComment_at"
  add_index "photos", ["clickCount"], :name => "index_photos_on_clickCount"
  add_index "photos", ["id"], :name => "index_photos_on_id"

  create_table "pointoplogs", :force => true do |t|
    t.integer  "user_id",   :limit => 10,                 :null => false
    t.string   "operation", :limit => 45, :default => "", :null => false
    t.integer  "point",     :limit => 10,                 :null => false
    t.datetime "datetime",                                :null => false
    t.string   "ip",        :limit => 15, :default => "", :null => false
  end

  create_table "reports", :force => true do |t|
    t.string   "reportType", :limit => 50, :default => "", :null => false
    t.text     "content",                                  :null => false
    t.datetime "datetime",                                 :null => false
  end

  create_table "tags", :force => true do |t|
    t.string   "tagName",       :limit => 45, :default => "", :null => false
    t.datetime "datetime",                                    :null => false
    t.integer  "referedPhotos", :limit => 10, :default => 0,  :null => false
    t.integer  "referedAlbums", :limit => 10, :default => 0,  :null => false
    t.integer  "coverPhoto_id", :limit => 10,                 :null => false
  end

  create_table "userinformations", :force => true do |t|
    t.integer  "user_id",  :limit => 10, :null => false
    t.string   "realname", :limit => 20
    t.datetime "birthday"
    t.string   "sex",      :limit => 4
    t.string   "hometown", :limit => 20
    t.string   "sign"
  end

  create_table "users", :force => true do |t|
    t.string   "username",          :limit => 20,  :default => "",    :null => false
    t.string   "password",          :limit => 32,  :default => "",    :null => false
    t.string   "email",             :limit => 100, :default => "",    :null => false
    t.datetime "registerDatetime",                                    :null => false
    t.datetime "lastLoginDatetime"
    t.boolean  "isAdmin",                          :default => false, :null => false
    t.integer  "point",             :limit => 10,  :default => 0,     :null => false
    t.integer  "gain",              :limit => 10,  :default => 0,     :null => false
    t.string   "portrait",          :limit => 50,  :default => ""
    t.integer  "viewCount",         :limit => 10,  :default => 0,     :null => false
    t.integer  "loginCount",        :limit => 10,  :default => 0,     :null => false
    t.string   "language",          :limit => 10,  :default => "zh",  :null => false
    t.string   "lastIP",            :limit => 15
  end

  add_index "users", ["id"], :name => "index_users_on_id"

  create_table "vipinfos", :force => true do |t|
    t.integer  "user_id",            :limit => 10,                :null => false
    t.datetime "start_at",                                        :null => false
    t.datetime "end_at",                                          :null => false
    t.integer  "level",              :limit => 10, :default => 0, :null => false
    t.integer  "albumDownloadCount", :limit => 10, :default => 0, :null => false
    t.integer  "photoDownloadCount", :limit => 10, :default => 0, :null => false
  end

end
