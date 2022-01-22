class User
  require_relative "eventset.rb"

  #Initialize variables
  attr_accessor :first_name, :last_name, :email, :audiences, :categories, :departments, :time_range, :rsvp, :tags, :event_list
  
  #constant needed for get_date_range
  DAYS_TO_SECONDS = 86400

  #constructor 
  #takes hash of info and creates a User with those preferences
  def initialize(user_hash)
    @first_name = user_hash["first_name"]
    @last_name = user_hash["last_name"]
    @email = user_hash["email"]
    @audiences = user_hash["audiences"]
    @categories = user_hash["categories"]
    @departments = user_hash["departments"]
    @time_range = user_hash["time_range"]
    @rsvp = user_hash["rsvp"]
    @tags = user_hash["tags"]
    @event_list = []
  end 

  #use EventSet class to find array of events that the User might be interested in
  #updates the User's event_list
  #gets events within the next week for the newsletter
  def update_user_events
    #create new EventSet
    weeks_events = EventSet.new(User.get_date_range)
    users_events = []
    #filter based on user's preferences
    #have to reset the filtered list each time so that we don't try to get events that match only if ALL preferences are met
    #this way we get an array where each event matches a preference rather than all preferences
    #it is very rare that there would be an event that has every category or tag that a user likes i.e. Food and Music and Reading
    weeks_events.filter_by_audience(@audiences)
    users_events.concat(weeks_events.filtered_event_list)
    weeks_events.reset_filters()
    weeks_events.filter_by_dept(@departments)
    users_events.concat(weeks_events.filtered_event_list)
    weeks_events.reset_filters()
    weeks_events.filter_by_category(@categories)
    users_events.concat(weeks_events.filtered_event_list)
    weeks_events.reset_filters()
    weeks_events.filter_by_requires_rsvp(@rsvp)
    users_events.concat(weeks_events.filtered_event_list)
    weeks_events.reset_filters()
    weeks_events.filter_by_tag(@tags)
    users_events.concat(weeks_events.filtered_event_list)
    #filter by time if user has given time preferences
    #if user has not given time preferences it will not filter on time
    #if @time_range.size == 2
      #weeks_events.filter_by_time(Time.new(@time_range[0]), Time.new(@time_range[1]))
    #end
    @event_list = users_events
  end

 
  #get the dates for the next week into the correct format for EventSet class to use
  def self.get_date_range
    today = Time.now
    date_strings = (0...7).to_a.map {|i| (today + DAYS_TO_SECONDS * i).strftime("%Y/%-m/%-d")}
  end
end
