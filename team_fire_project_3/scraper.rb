require 'httparty'
require 'nokogiri'
require_relative 'parser.rb'

class Scraper

    # Base URL for accessing days of the calendar
    BASE_URL = "https://studentlife.osu.edu/calendar.aspx/"

    # Returns a Hash of links and the HTML at them for all the events on the provided date
    #    Provided date must be in format "yyyy/m/d"
    def self.scrape_day(date)
        
        # Compute the full URL of the day
        url = BASE_URL + "#{date}"
        # Get the HTML at that page
        day_page_html = HTTParty.get(url).force_encoding('utf-8')
        # Get all the event links on that day
        relative_urls = Parser.extract_event_URLs(day_page_html)
        
        # Initialize the hash of links and parsee html
        link_and_html = {} 

        # For each relative url, add it and it's parsed HTML to the hash
        relative_urls.each { |relative_url|
            # Sleep for 100 ms to prevent program from pinging site too quickly
            sleep(0.1)
            full_url = "https://studentlife.osu.edu" + relative_url
            unparsed_html = HTTParty.get(full_url).force_encoding('utf-8')
            link_and_html[full_url] = Nokogiri::HTML(unparsed_html)
        }

        # Return the hash
        link_and_html


    end 

end
