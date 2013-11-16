class AddMimeTypeIntoShareLinks < ActiveRecord::Migration
  def change
  add_column :share_links, :mime_type, :string

  end
end
