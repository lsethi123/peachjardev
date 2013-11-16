class SenderEmailConfig < ActiveRecord::Base
	attr_encrypted :password, :key => SECRET_KEY
end
