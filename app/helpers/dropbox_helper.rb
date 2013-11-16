module DropboxHelper
	def create_subject(file_name)
		"PeachJar File Sharing: #{file_name}"
	end
	def create_body(share_link_url,file_name)
		body_contents=EmailTemplate.find_by_name('common_share_email',:select=>"body").body
		body=body_contents.gsub(/\r\n?/, "\n")
		body=body %[current_user.username,file_name,share_link_url]
	end
end
