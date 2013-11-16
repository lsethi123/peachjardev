class CreateShareLinksUsers < ActiveRecord::Migration
  def change
    create_table :share_links_users do |t|
     t.belongs_to :share_link
      t.belongs_to :user	
      t.timestamps
    end
  end
end
