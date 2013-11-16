class OauthController < ApplicationController
	require 'dropbox_sdk'
	before_filter :authenticate_user!
	### authentication using the dropbox
	def main
	    @client = get_dropbox_client
        if current_user.username=="administrator"
                redirect_to(:action=>'index',:controller=>'admin')
        else    
                redirect_to(:action=>'list',:controller=>'dropbox') 
        end
    end

    def get_web_auth()
        redirect_uri = url_for(:action => 'auth_finish')
        DropboxOAuth2Flow.new(APP_KEY, APP_SECRET, redirect_uri, session, :dropbox_auth_csrf_token)
    end
    def auth_start
        @authorize_url = get_web_auth().start()
        redirect_to(:action=>'list',:controller=>'dropbox') and return if !session[:access_token].nil?

        # Send the user to the Dropbox website so they can authorize our app.  After the user
        # authorizes our app, Dropbox will redirect them here with a 'code' parameter.
        
    end
    def auth_finish
        begin
            access_token, db_user_id, url_state = get_web_auth.finish(params)
            session[:access_token] = access_token
            ### save the acess token first time into the databse with user id
            dp=DpToken.new(:db_user_id=>db_user_id,:db_access_token=>access_token,:user_id=>current_user.id)
            dp.save
            @js="window.opener.location.reload();window.close();"
            render inline: "<%=javascript_tag @js %>"
        rescue DropboxOAuth2Flow::BadRequestError => e
            render :text => "Error in OAuth 2 flow: Bad request: #{e}"
        rescue DropboxOAuth2Flow::BadStateError => e
            logger.info("Error in OAuth 2 flow: No CSRF token in session: #{e}")
            redirect_to(:action => 'auth_start')
        rescue DropboxOAuth2Flow::CsrfError => e
            logger.info("Error in OAuth 2 flow: CSRF mismatch: #{e}")
            render :text => "CSRF error"
        rescue DropboxOAuth2Flow::NotApprovedError => e
            render :text => "Not approved?  Why not, bro?"
        rescue DropboxOAuth2Flow::ProviderError => e
            logger.info "Error in OAuth 2 flow: Error redirect from Dropbox: #{e}"
            render :text => "Strange error."
        rescue DropboxError => e
            logger.info "Error getting OAuth 2 access token: #{e}"
            render :text => "Error communicating with Dropbox servers. #{e.message}"
        end
    end

end
