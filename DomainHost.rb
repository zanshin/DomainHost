#!/usr/bin/env ruby
#
# DomainHost.rb
#
# This application parses a Netscape fomatted bookmarks file and produces a list of the domain
# hosts used by the domain contained in the file. Each domain is only counted once, regardless of
# how many times it or derevations of it occur in the file.
#

require "uri"
require "action_view"
include ActionView::Helpers::TextHelper

require "whois"

# -------------------------------------------------
# DomainHost class
# -------------------------------------------------
class DomainHost
  
  def initialize(bookmarkFile)
    @bookmarks = bookmarkFile
    @counter = 1
    @http_schemes = ["http", "https"]
    @domains = Hash.new { |h, k| h[k] = 0 }
    @domains_in_order = Hash.new
    @hosts = Hash.new { |h, k| h[k] = 0 }
  end
  
  def resolve_domains
    begin
    	file = File.new(@bookmarks, "r")
    	while (line = file.gets)
    		# extract the URL
    		aUrl = line.slice(URI.regexp(@http_schemes))
    		unless aUrl.nil?
    		  domain = URI.parse(aUrl.to_s).host.gsub(/^www\./, '')
  		    puts "#{@counter}: #{domain}"
  		    @counter = @counter + 1
  		    
  		    # put the domains into a Hash, which has the effect of eliminating duplicates
  		    @domains[domain] += 1
    		end
    	end
    	file.close
    rescue => err
    	puts "Exception: #{err}"
    	err
    end
  end
    
  def whois_lookup
    client = Whois::Client.new(:timeout => 20)
    @domains_in_order.each do | domain, count |
      begin
        result = client.query(domain)        
        puts "Querying whois for #{domain}."
        unless result.nameservers.nil?
          result.nameservers.each do |nameserver|
            @hosts[nameserver] += 1
          end
        end
        
      rescue Whois::ConnectionError
        puts "Whois::ConnectionError... #{domain}"
      rescue Whois::ResponseIsThrottled
        puts "Whois::ResponseIsThrottled... #{domain}"
      rescue Timeout::Error
        puts "Timeout::Error... #{domain}"
      rescue NoMethodError
        puts "NoMethodError.... #{domain}"
      rescue Exception
        puts "Exception.... #{domain}"
      end
    end
  end
  
  
  def domain_display
    # sort alphabetically and display
    @counter = 1
    @domains_in_order = Hash[@domains.sort]
    @domains_in_order.each do | domain, count |
      puts "#{@counter}: The domain #{domain} has " + pluralize(count, "instance") + "."
      @counter = @counter + 1
    end
  end
  
  
  def host_display
    # sort in descending order of nameserver popularity and dislay
    @counter = 1
    #hosts_in_order = Hash[@hosts.sort]
    @hosts.each do | nameserver, count |
      puts "#{@counter}: The nameserver #{nameserver} is used " + pluralize(count, "time") + "."
      @counter = @counter + 1
    end
  end

end
  
# -------------------------------------------------
# Instantiate DomainHost and feed it a bookmarks file
# -------------------------------------------------
hosts = DomainHost.new("chromeBookmarks.html")
hosts.resolve_domains
hosts.domain_display
hosts.whois_lookup
hosts.host_display


