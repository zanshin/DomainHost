#!/usr/bin/env ruby

#
# DomainHost.rb
#
# This application parses a Netscape fomatted bookmarks file and produces a list of the domain
# hosts used by the domain contained in the file. Each domain is only counted once, regardless of
# how many times it or derevations of it occur in the file.
#

require "uri"

# -------------------------------------------------
# DomainHost is our main
# -------------------------------------------------
class DomainHost
  counter = 1
  def read_bookmarks(bookmarks)
    begin
    	file = File.new(bookmarks, "r")
    	while (line = file.gets)
    		#puts "#{counter}: #{line}"
		
    		# extract the URL
    		aUrl = URI.extract(line)
    		puts aUrl
    		#theUrl = URI.parse(aUrl.to_s)
    		#domain = theUrl.host 
    		validate_url(aUrl)
    		#puts "#{counter}: #{domain}"
    		counter = counter + 1
    	end
    	file.close
    rescue => err
    	puts "Exception: #{err}"
    	err
    end
  end

  # -------------------------------------------------
  # validate_url looks for a valid URL
  # -------------------------------------------------
  def validate_url(url)
    uri = URI.parse(url)
    uri.class != URI::HTTP
  rescue URI::InvalidURIError
    false
  end

end
  
  # -------------------------------------------------
  # call read_bookmarks with a file
  # -------------------------------------------------
  read_bookmarks("chromeBookmarks")


