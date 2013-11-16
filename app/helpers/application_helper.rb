module ApplicationHelper
	
	def myfiles(active)
		active ? "" : 'active'
	end

	def get_share_link_url(short_url,http_client)
        result = http_client.head(short_url)
        preview_link= result.header['Location'][0].gsub('www.dropbox.com', 'dl.dropboxusercontent.com')
    end
end
