class DropboxController < ApplicationController
    before_filter :authenticate_user!
    before_filter :get_dropbox_client
    def list
        path=params[:current_folder] || '/'
        if !@client.nil?
            @account_info = @client.account_info
            ### get  files details
            root_metadata = @client.metadata(path)
            @files_array=root_metadata['contents']
            params[:current_folder]=path
        else
            #redirect_to(:action => 'auth_start',:controller=>'oauth') and return
        end
        @user_emails=User.find(:all,:select=>'email').map(&:email)
        s_user_ids=ShareLinksUsers.where(user_id:current_user.id).pluck(:share_link_id).uniq
        if !s_user_ids.empty?
            @share_files_array=ShareLink.find(s_user_ids) 
        end
         @share_files_array
    end



    def upload
        unless @client
            redirect_to(:action => 'auth_start',:controller=>'oauth') and return
        end
        begin
            # Upload the POST'd file to Dropbox, keeping the same name
            if  !params[:file].nil?
                if params[:options]=='Y'
                    params[:file].original_filename=params[:file].original_filename.concat('.encrypt')
                end
                resp = @client.put_file("#{params[:current_folder]}/#{params[:file].original_filename}", params[:file].read)
                #render :text => "Upload successful.  File now at #{resp['path']}"
                redirect_to(:action=>'list',:current_folder=>params[:current_folder])
            else
                raise "Please select the file to upload"
                #redirect_to(:actione=>'newfile')
            end
        rescue DropboxAuthError => e
            session.delete(:access_token)  # An auth error means the access token is probably bad
            logger.info "Dropbox auth error: #{e}"
            render :text => "Dropbox auth error"
        rescue DropboxError => e
            logger.info "Dropbox API error: #{e}"
            render :text => "Dropbox API error"
        end
    end

    def folder
        path="#{params['current_folder']}/#{params['folder_name']}"
        @client=get_dropbox_client
        @client.file_create_folder(path)
        redirect_to(:action=>'list',:current_folder=>params[:current_folder])
    end

    def download
        file_name=params[:file]
        if file_name=~/\.encrypt$/
            decrypt_file_array=file_name.split('/').last.split('.')
            decrypt_file_array.pop
            dest_file_name=decrypt_file_array.join('.')
        else
            dest_file_name=file_name.split('/').last
        end
        contents, metadata = @client.get_file_and_metadata("#{file_name}")
        ### chenage the metadata of file and its extenssion so user can able 
        ### to see the orignal file which uploaded
        
        #dest_file_name=dest_file_name.split('.').first.concat('.txt')
        #metadata['mime_type']='text/plain'
        destination_file="/tmp/#{dest_file_name}"
        open(destination_file, 'wb') {|f| f.puts contents }
        send_file destination_file, :type =>"#{metadata['mime_type']}" , :disposition => 'attachment'
    end

    def destroy
        path=params[:file]
        f_array=params[:current_folder].split('/')
        f_array.pop
        params[:current_folder]=f_array.join('/')
        @client.file_delete(path)
        #redirect_to(:action=>'list',:current_folder=>params[:current_folder])
        render_j
    end

    def share
        file_name=params[:file]
        url_to_share=@client.shares("/#{file_name}")
        @SL=ShareLink.find_or_initialize_by_file_name(file_name)
        @SL.update_attributes(:link_url=>url_to_share['url'],:icon=>params[:icon],
            :mime_type=>params['file_type'],:user_id=>current_user.id)
        @SL.save
        #PeachjarMailer.send_email('lalitsethi2003@gmail.com','Hello subject',"share url #{url_to_share['url']} for file #{file_name}").deliver
        #render :inline=>"share url #{url_to_share['url']} for file #{file_name}"
    end
    def share_with_user
        emails=params['emails'].gsub(/\s+/, "")
        email_array=emails.split(',')
        subject=params[:subject]
        e_body=params[:body]
        link_id= params['link_id']
        registered_email=[]
        email_array.each{|e|
            shared_user_id=User.where(email:e).pluck(:id)[0]
            if !shared_user_id.nil?
                registered_email.push e
                ShareLinksUsers.create!(:share_link_id=>link_id,:user_id=>shared_user_id)
            end
        }
        not_register_emails=email_array-registered_email
        if !registered_email.empty?
            PeachjarMailer.send_email(registered_email.join(','),subject,e_body,true).deliver
        end
        if !not_register_emails.empty?
            PeachjarMailer.send_email(not_register_emails.join(','),subject,e_body,false).deliver
        end
        #PeachjarMailer.send_email(emails,subject,e_body).deliver
        redirect_to(:action=>'list',:current_folder=>params[:current_folder])
    end
    def logout
        reset_session
        render :inline=>"logout Sucessfully"
    end
    def destroy_link
        x=ShareLinksUsers.where(share_link_id:params[:id],user_id:current_user.id).pluck(:id)[0]
        ShareLinksUsers.destroy(x)
        render_j
    end
end
