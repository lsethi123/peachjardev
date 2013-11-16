class CreateSenderEmailConfigs < ActiveRecord::Migration
  def change
    create_table :sender_email_configs do |t|
      t.string :sender_email
      t.string :encrypted_password
      t.string :smtp
      t.integer :port

      t.timestamps
    end
  end
end
