class CreateShareLinks < ActiveRecord::Migration
  def change
    create_table :share_links do |t|
      t.string :link_url
      t.string :file_name
      t.integer :user_id

      t.timestamps
    end
  end
end
