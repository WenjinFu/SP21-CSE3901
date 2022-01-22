require_relative "scraper.rb"
require_relative "event.rb"

# Wrapper class around an array of events. 
# Will also be used for filtering events based on all their attributes
class EventSet
    
    # Has two arrays of events: ALL the events from the provided dates, and also JUST those events selected via filtering
    attr_accessor :whole_event_list, :filtered_event_list, :date_count, :array_of_dates

    # Conversion factors for comparing times of day
    HOURS_TO_SECONDS = 3600
    MINUTES_TO_SECONDS = 60

    # Static utility method for comparing times of day
    def self.time_of_day(date_time)
        HOURS_TO_SECONDS * date_time.hours + MINUTES_TO_SECONDS * date_time.minutes + date_time.seconds
    end

    # Given an array of dates, uses the scraper class to fill its event list with all the events on those dates
    def initialize(array_of_dates) #for example, day1.2-4        
        
        @whole_event_list = []
        @filtered_event_list = []
        @array_of_dates=array_of_dates

        # Iterate over each date and add that days events to the whole event list
        count = 0
        while count<array_of_dates.size do
            
            # Get the hash of links and parsed html for each event
            link_html_hash = Scraper.scrape_day(array_of_dates[count])
            
            # Construct an event for each link
            link_html_hash.each { |link, parsed_html|
                @whole_event_list.push(Event.new(link, parsed_html))
            }

            count = count + 1
        end

    end

    # Resets the filtered event list to be a copy of the whole event list
    def reset_filters()
        @filtered_event_list = @whole_event_list.clone
    end

    # Clean the filtered event list to be []
    def clean_filters()
        @filtered_event_list = []
    end

    # Filters the filtered event list to include only those in the specified time range
    #    Considers only the hours, minutes, and seconds of the incoming date time objects
    #    Ignores DATE portion of the incoming datetime objects
    def filter_by_time(time_of_day_min, time_of_day_max) #For example, Time.new(2021,2,18,18,00,00)
        # Strip the DATE portion, keep only the TIME of day portion for comparison
        begin_time = time_of_day(time_of_day_min)
        end_time = time_of_day(time_of_day_max)
        # Keep only those events with start times in the acceptable range
        @filtered_event_list.select! { |event| 
            time_of_day(event.datetime)>=begin_time && time_of_day(event.datetime)<=end_time
        }
    end

    # Filters the filtered event list to include only those that do/do not require RSVP
    def filter_by_requires_rsvp(requires_rsvp) # true/false
        @filtered_event_list.select! { |event| event::rsvp_required==requires_rsvp}
    end

    # Filters the filtered event list to include only those that have an audience from the provided audiences set
    #   If audience_set is empty, then no filtering will take effect.
    #   If an event has no audiences, it will not get filtered out.
    def filter_by_audience(audience_set) #audience_set=[student,teacher,employee,...] 
        if audience_set.size > 0
            @filtered_event_list.select! {|event| (event.audiences & audience_set).size > 0 || event.audiences.size == 0} 
        end
    end

    # Filters the filtered event list to include only those that have a program from the provided program set
    #   If program_set is empty, then no filtering will take effect.
    #   If an event has no programs, it will not get filtered out.
    def filter_by_program(program_set) #program_set=["Esports"]
        if program_set.size > 0
            @filtered_event_list.select! {|event| (event.programs & program_set).size > 0 || event.programs.size == 0}
        end
    end

    # Filters the filtered event list to include only those that have a dept from the provided dept set
    #   If dept_set is empty, then no filtering will take effect.
    #   If an event has no depts, it will not get filtered out.
    def filter_by_dept(dept_set) #dept_set=["Student Life","Health and Wellness"]
        if dept_set.size > 0
            @filtered_event_list.select! {|event| (event.depts & dept_set).size > 0 || event.depts.size == 0}
        end
    end

    # Filters the filtered event list to include only those that have a category from the provided category set
    #   If category_set is empty, then no filtering will take effect.
    #   If an event has no categories, it will not get filtered out.
    def filter_by_category(category_set) #category_set=["Sports", "Social"]
        if category_set.size > 0
            @filtered_event_list.select! {|event| (event.categories & category_set).size > 0 || event.categories.size == 0}
        end
    end

    # Filters the filtered event list to include only those that have a tag from the provided tag set
    #   If tag_set is empty, then no filtering will take effect.
    #   If an event has no tags, it will not get filtered out.
    def filter_by_tag(tag_set) #tag_set=[]
        if tag_set.size > 0
            @filtered_event_list.select! {|event| (event.tags & tag_set).size > 0 || event.tags.size == 0}
        end
    end

end