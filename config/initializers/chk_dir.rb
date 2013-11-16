def create_directory_if_not_exists(directory_name)
  Dir.mkdir(directory_name) unless File.exists?(directory_name)
end


create_directory_if_not_exists("log/daily_error")



