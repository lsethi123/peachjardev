class AddIconToShareLinks < ActiveRecord::Migration
  def change
    add_column :share_links, :icon, :string
  end
end
