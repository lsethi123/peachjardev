class CreateDpTokens < ActiveRecord::Migration
  def change
    create_table :dp_tokens do |t|
      t.string :db_access_token
      t.integer :db_user_id
      t.integer :user_id

      t.timestamps
    end
  end
end
