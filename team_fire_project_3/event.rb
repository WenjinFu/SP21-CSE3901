require "byebug"

class Event

    # All the interesting measures of an event.
    # Includes link to event page, time, location, admission requirements, Description, Google calendar event link, Audiences, Programs, Departments, Categories, Tags, Zoom link (if exist)
    
    # Single-string values
    attr_accessor :name, :link, :location, :calendar_event_link

    # Ruby datetime type
    attr_accessor :datetime

    # Boolean value
    attr_accessor :rsvp_required

    # Arrays of strings, all come from the sidebar of the page
    attr_accessor :audiences, :programs, :depts, :categories, :tags 

    # Constructor. Takes in a single event page's parsed HTML body 
    #  and constructs a new Event object out of it determining as many details as possible
    def initialize(link, parsed_html)
        
        # Assign the link from the argument immediately
        @link = link
        if (parsed_html)
            # Use the parser class to all other attributes
            @name = Parser.extract_event_name(parsed_html)
            @location = Parser.extract_event_location(parsed_html)
            @datetime = Parser.extract_event_datetime(parsed_html)
            @calendar_event_link = Parser.extract_event_calendar_event_link(parsed_html)
            @rsvp_required = Parser.extract_rsvp_required?(parsed_html)
        
            # Extract everything from the sidebar
            @audiences, @programs, @depts, @categories, @tags = Parser.extract_sidebar(parsed_html)
        end
        
    end


end
