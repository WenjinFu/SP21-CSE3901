require "nokogiri"
require "byebug"
require "time"

# Utility class containing only static methods to abstract parsing HTML
class Parser

    # Keywords/magic strings to be used in parsing apart the sidebar
    KEYWORDS = %w{Audiences Programs Departments Categories Tags}

    # Given the HTML of a calendar entire day page (like https://studentlife.osu.edu/calendar.aspx/yyyy/m/d/),
    #     returns an array of relative string URLs (like /calendar.aspx/yyyy/mm/dd/######/event-name-) 
    #     for ALL the events on that day
    def self.extract_event_URLs(day_page_html)
        
        # Parse the HTML using nokogiri
        parsed_html = Nokogiri::HTML(day_page_html)

        # Get the relative URLs from the parsed html
        # Each linked is wrapped in a span title.
        relative_urls = parsed_html.css("span.title").map { |span_title|
            # Get the zeroth anchor element's href
            span_title.css("a")[0].attributes["href"].value
        }

        # Return them
        relative_urls

    end

    # Given the Nokogiri-parsed HTML for an event page, returns the name
    def self.extract_event_name(parsed_html)
    
        # The title is inside the only instance of a "header" class on the page.
        # It's found in the text of an h2
        parsed_html.css("div.header")[0].css("h2").text

    end

    # Given the Nokogiri-parsed HTML for an event page, returns the location as a string
    def self.extract_event_location(parsed_html)
    
        # (This data very near the other datetime data)
        # The location is inside the only instace of a "mainbar" class on the page
        # It's found inside the text of the SECOND paragraph
        # Find the first colon character and take everything after that
        location_string = parsed_html.css("div.mainbar")[0].css("p")[1].text
        location_string[location_string.index(":")+2...location_string.length]

    end

    # Given the Nokogiri-parsed HTML for an event page, returns the datetime as a ruby datetime
    def self.extract_event_datetime(parsed_html)

        # (This data very near the other location data)
        # The datetime is inside the only instace of a "mainbar" class on the page
        # It's found inside the text of the FIRST paragraph
        # Find the first colon character and take everything after that
        # Convert to datetime with Time.parse
        full_time_string = parsed_html.css("div.mainbar")[0].css("p")[0].text
        Time.parse(full_time_string[full_time_string.index(":")+2...full_time_string.length])

    end

    # Given the Nokogiri-parsed HTML for an event page, returns the add-to-google-calendar link
    def self.extract_event_calendar_event_link(parsed_html)
    
        # The GOOGLE calendar link is the href value of the SECOND "button-ical" class instance in the page
        parsed_html.css("a.button-ical")[1].attributes["href"].value

    end

    # Given the Nokogiri-parsed HTML for an event page, returns whether RSVP is required or not
    def self.extract_rsvp_required?(parsed_html)

        # The statement that RSVP is required -- if it exists -- will be after the location
        # It would be in the THIRD paragraph of the mainbar
        paragraphs = parsed_html.css("div.mainbar")[0].css("p")
        paragraphs.length > 2 && paragraphs[2].text.include?("RSVP Required")

    end


    # All data below extracted from the same place in the page -- the sidebar
    # So function groups them toegether likewise
    # Given the Nokogiri-parsed HTML for an event page, returns the list of associated audiences
    def self.extract_sidebar(parsed_html)

        sidebar = parsed_html.css("div.sidebar")[0]
        
        # Get the 'Titles' via the h3 elements in the sidebar
        titles = sidebar.css("h3")
        # Get what's listed beneath the titles via the unordered list ul elements in the sidebar
        uls = sidebar.css("ul")

        # Convert each h3 title element into just its own string value
        titles = titles.map {|title|
            title.text
        }
        # Remove any titles called "Event Image"
        titles.select! {|title| title != "Event Image"}
        # Convert each ul element into an array of strings of its list elements
        uls = uls.map {|ul|
            ul.css("li").collect {|li| li.text}
        }
        
        # For each of the might-not-exist-on-page elements, check if the keyword term DOES 
        #    exist in the sidebar titles. If so, find where, and assign the corresponding
        #    values from the unordered lists to that keyword.
        audiences = titles.index(KEYWORDS[0]) == nil ? [] : uls[titles.index(KEYWORDS[0])]
        programs = titles.index(KEYWORDS[1]) == nil ? [] : uls[titles.index(KEYWORDS[1])]
        depts = titles.index(KEYWORDS[2]) == nil ? [] : uls[titles.index(KEYWORDS[2])]
        categories = titles.index(KEYWORDS[3]) == nil ? [] : uls[titles.index(KEYWORDS[3])]
        tags = titles.index(KEYWORDS[4]) == nil ? [] : uls[titles.index(KEYWORDS[4])]

        # Return an array containing the five sidebar elements
        [audiences, programs, depts, categories, tags]

    end

end