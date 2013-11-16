class ApplicationController < ActionController::Base
# Prevent CSRF attacks by raising an exception.
rescue_from Exception, :with => :known_error if Rails.env.production?
before_filter :configure_permitted_parameters, if: :devise_controller?
# For APIs, you may want to use :null_session instead.
	require 'dropbox_sdk'
	protect_from_forgery with: :exception
	def get_dropbox_client
		### read acess token from the database
		begin
			@dp = DpToken.find(current_user.id)
			if !@dp.nil?
				db_access_token=@dp.db_access_token
				session[:access_token]=db_access_token if !db_access_token.nil?
			end
		    if session[:access_token]
		        begin
		           access_token = session[:access_token]
		           @client = DropboxClient.new(access_token)
		        rescue
		            # Maybe something's wrong with the access token?
		            session.delete(:access_token)
		            raise
		        end
		    end
		rescue ActiveRecord::RecordNotFound 
		end
	end
	protected

	def configure_permitted_parameters
		devise_parameter_sanitizer.for(:sign_up) do |u|
		u.permit :username, :email, :password, :password_confirmation
		end
	end
	private
	Dir[Rails.root + 'app/lib/*.rb'].each do |file|
     require_dependency file
   end
end
