counter = 1
begin
	file = File.new("chromeBookmarks.html", "r")
	while (line = file.gets)
		puts "#{counter}: #{line}"
		counter = counter + 1
	end
	file.close
rescue => err
	puts "Exception: #{err}"
	err
end