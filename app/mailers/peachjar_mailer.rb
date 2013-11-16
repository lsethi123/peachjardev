class PeachjarMailer < ActionMailer::Base
#default from: "from@example.com"
	def send_email(to_email_ids,subject,email_body,flag)
		body_append_str=''
		if flag
			body_append_str=EmailTemplate.find_by_name('registered_user',:select=>"body").body
		else
			body_append_str=EmailTemplate.find_by_name('not_register_user',:select=>"body").body
		end
		from_email=email_config()
		@body=email_body + body_append_str
		mail(:from=>@sender_email,:to => to_email_ids,:subject => subject) do |format|
	            format.html
	    end
	end
	private
	def email_config
		sec=SenderEmailConfig.find(1)
		@sender_email=sec.sender_email
		@sender_pwd=sec.password
		ActionMailer::Base.smtp_settings = {
	    :address              => sec.smtp,
	    :port                 => sec.port,
	    :domain               => "localhost:3000",
	    :user_name            => @sender_email,
	    :password             => @sender_pwd,
	    :authentication       => "plain",
	    :content_type		  =>"text\html",
	    :enable_starttls_auto => true
	    }
	end
end
