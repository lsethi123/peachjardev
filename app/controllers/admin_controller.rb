class AdminController < ApplicationController

    before_filter :authenticate_user!
	def index
		if current_user.username=="administrator"
			begin
				se=SenderEmailConfig.find(1)
				@id=se.id
				@sender_email=se.sender_email
				@smpt_address=se.smtp
				@port=se.port
				@ET=EmailTemplate.find(:all,:select=>"id,name,updated_at")
			rescue ActiveRecord::RecordNotFound 
			end
		else
			render :inline => "Your are not Administrator !!!"
		end
	end
	def save_email
		begin
			if !params[:id].nil?
				@SEC=SenderEmailConfig.find(params[:id])
			end 
		rescue ActiveRecord::RecordNotFound 
			@SEC= SenderEmailConfig.new
		end
		@SEC.update_attributes(
				:sender_email=>params[:s_email],
				:password=>params[:password],
				:smtp=>params[:smtp_address],
				:port=>params[:smtp_port]	
			)
			@SEC.save
	    respond_to do |format|
	    	format.html{
	    		flash[:notice] = 'Email Configuration Done !!!'
		  		redirect_to :action=>'index'
	      	}
	    end
	end
	def save_template
		begin
			if !params[:id].nil?
				@email_templ=EmailTemplate.find(params[:id])
			end 
		rescue ActiveRecord::RecordNotFound 
			@email_templ= EmailTemplate.new
		end
		@email_templ.update_attributes(
			:name=>params[:temp_name],
			:body=>params[:mail_body]
		)
		@email_templ.save
	    respond_to do |format|
	    	format.html{
	    		flash[:notice] = 'Email Template Saved !!!'
		  		redirect_to :action=>'index'
	      	}
	    end

	end
	def edit_template
		@ET=EmailTemplate.find(params[:id])
	end
	def delete_template
		EmailTemplate.destroy(params[:id])
        render_j
	end
end
