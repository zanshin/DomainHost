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
# DomainHost class
# -------------------------------------------------
class DomainHost
  
  def initialize(bookmarkFile)
    @bookmarks = bookmarkFile
    @counter = 1
    @http_schemes = ["http", "https"]
  end
  
  def resolve_domains
    begin
    	file = File.new(@bookmarks, "r")
    	while (line = file.gets)
    		# extract the URL
    		aUrl = line.slice(URI.regexp(@http_schemes))
    		unless aUrl.nil?
  		    theUrl = URI.parse(aUrl.to_s)
  		    domain = theUrl.host
  		    puts "#{@counter}: #{domain}"
  		    @counter = @counter + 1
    		end
    	end
    	file.close
    rescue => err
    	puts "Exception: #{err}"
    	err
    end
  end

end
  
# -------------------------------------------------
# Instantiate DomainHost and feed it a bookmarks file
# -------------------------------------------------
hosts = DomainHost.new("chromeBookmarks.html")
hosts.resolve_domains


