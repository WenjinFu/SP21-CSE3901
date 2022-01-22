#Utility class
class Emailer
  #creates email to send to Users 
  #email will have an event that week that the User may be interested in

  require 'mail'
  require 'json'
  #require 'random'
  require_relative "event.rb"
  require_relative "eventset.rb" 
  require_relative "user.rb"


  #reads the JSON file into a hash, then creates an array of Users
  #input file must be named users.json
  def self.create_all_users
    all_users = Array.new
    user_hash = Hash.new
    #check to make sure file exists
    if !File.exist?('users.json')
      puts "required input file not found"
      puts "no newsletters will be sent"
    else 
      #if file exists, read file
      user_file_input = File.read('users.json')
      user_hash = JSON.parse(user_file_input)
    end
    #create a User for each user in the file
    #if the file did not exist and thus the hash is empty, this block will not execute
    user_hash.each_value do |one_user|
      user1 = User.new(one_user)
      user1.update_user_events
      all_users.append(user1)
    end
    #return array of Users
    all_users
  end

  #sends email to each user with an event in the next week that matched their preferences
  #if no events match the user's preferences, it sends an email suggesting a random event
  def self.send_daily_newsletter
    self.set_mail_defaults
    all_users = Emailer.create_all_users
    all_users.each do |user1|
      event_to_send = Emailer.choose_random_event(user1.event_list)
      if !event_to_send
        email_body = Emailer.no_matching_events_body(user1)
      else 
        email_body = Emailer.create_email_body(user1, event_to_send)
      end
      mail = Mail.deliver do 
        from     'Team Fire <teamfire3901@gmail.com>'
        to       user1.email
        subject  'Your suggested event today!'
        html_part do  
          content_type 'text/html; charset=UTF-8'
          body email_body
        end
      end
    end
  end

  #set defaults to send emails from the Team Fire gmail account
  def self.set_mail_defaults
    Mail.defaults do  
      delivery_method :smtp, {
        :address => "smtp.gmail.com",
        :port => 587,
        :domain => 'gmail.com',
        :user_name => 'teamfire3901',
        :password => 'this is a test email address for team fire!',
        :authentication => 'plain',
        :enable_starttls_auto => true 
      }
    end
  end

  #choose a random event from the User's event_list to send in the daily email
  #if there are no matching events it will return false
  def self.choose_random_event(list)
    if list.size != 0
      num = Random.rand(list.size - 1)
      event_to_send = list.at(num)
    else 
      event_to_send = nil
    end
      event_to_send
  end

  #create the html body for the email to be sent if there is a matching event this week
  #customizes the email to the User and the Event being sent
  def self.create_email_body(user1, event1)
    #to fill in whether the event needs an RSVP to attend
    if event1.rsvp_required 
      rsvp = "requires an RSVP, so be sure to sign up soon!"
    else 
      rsvp = "does not require an RSVP!"
    end
    #link to today's page on the OUAB website
    ouab_link = "https://ouab.osu.edu/events.aspx/#{User.get_date_range[0]}?p=3"
    #get datetime into a string format for email
    datetime_string = Emailer.datetime_tostring(event1)
    #email html body
    email_html = 
    "<style>
    p {
      font-family: arial,helvetica neue,helvetica,sans-serif;
      font-size: 13px;
      }
    a:link {
      color: #ff9933;
      background-color: transparent;
      text-decoration: none;
    }
    a:hover {
      color: #ff9933;
      background-color: transparent;
      text-decoration: underline;
    }
    </style>
    
    <h1>
      <span style=\"font-size:42px\">
      <span style=\"color:#ff9933\">
      Hey there, #{user1.first_name}!</span>
      </span>
      <img data-file-id=\"5126302\" height=\"120\" src=\"https://mcusercontent.com/738d41d8b17f10d49336bc24b/images/358c00db-2cf9-41d3-bc03-839a854e3585.gif\" align=\"right\" style=\"border: 0px  ; width: 120px; height: 120px; margin: 0px;\" width=\"120\" alt=\"yas\" />
    </h1>

    <p style=\"text-align: justify;\">
      <span style=\"font-size:16px\">There&#39;s an event happening this week <br /> that we think you&#39;ll like!</span>
    </p>
    <br />
    <hr />
    
    <p style=\"font-size:17px\">Here&#39;s the scoop:&nbsp;
    <br />
    </p>

    <p>
      <br />
      <span style=\"font-size:24px\"><a href=\"#{event1.link}\" target=\"_blank\">#{event1.name}</a>
      </span>
    </p>

    <p>
    This event is taking place on #{datetime_string}. The location is #{event1.location} and it #{rsvp}<br />
    <br />
    If you&#39;d like to add this event to your calendar, <a href=\"#{event1.calendar_event_link}\" target=\"_blank\">click here</a>.<br />
    <br />
    <p style=\"text-align: center\"><br />
      <span style=\"font-size:16px\"><a href=\"#{ouab_link}\" target=\"_blank\"><span style=\"border-radius:30px;background:#ff9933;color:white;padding:10px;text-align:center;display:inline-block\">Take a look at the other events happening today</span></a>
      </span>
    </p><br /><br /><br />
    
    <div style=\"text-align: center;\"><em>Copyright &copy; 2021 Team Fire, All     rights reserved.</em><br />
      <br />
      <strong>Our mailing address is:</strong><br />
      2098 Ohio Union, 1739 N. High Street, Columbus, OH 43210<br />
      <br />
      Want to change how you receive these emails?<br />
      You can <a href=\"https://forms.gle/wW3JNC9dYmJ2ZPDe7\" target=\"_blank\">update your preferences</a> or <a href=\"mailto:teamfire3901@gmail.com?subject=Unsubscribe&amp;body=Unsubscribe\" target=\"_blank\">unsubscribe from this list</a>.</div>"


  end

  #create the html email body for an email when the user does not have any events that matched their preferences
  #will select a random event over the next week and suggest it instead
  def self.no_matching_events_body(user1)
    #get a random event
    week_events = EventSet.new(User.get_date_range).whole_event_list
    event1 = Emailer.choose_random_event(week_events)

    #to fill in whether the event needs an RSVP to attend
    if event1.rsvp_required 
      rsvp = "requires an RSVP, so be sure to sign up soon!"
    else 
      rsvp = "does not require an RSVP!"
    end
    #link to today's event page on the OUAB website
    ouab_link = "https://ouab.osu.edu/events.aspx/#{User.get_date_range[0]}?p=3"
    #get datetime into a string format for email
    datetime_string = self.datetime_tostring(event1)
    #email html body
    email_html = 
    "<style>
    p {
      font-family: arial,helvetica neue,helvetica,sans-serif;
      font-size: 13px;
      }
    a:link {
      color: #3346a4;
      background-color: transparent;
      text-decoration: none;
    }
    a:hover {
      color: #3346a4;
      background-color: transparent;
      text-decoration: underline;
    }
    </style>
    
    <h1><span style=\"font-size:42px\"><span style=\"color:#3346a4\">Hey there, #{user1.first_name}!</span></span><img data-file-id=\"5126302\" height=\"105\" src=\"https://mcusercontent.com/738d41d8b17f10d49336bc24b/images/d52e59d8-4d72-4c85-a0ce-d165cd342c06.gif\" align=\"right\" style=\"border: 0px  ; width: 175px; height: 105px; margin: 0px;\" width=\"175\" alt=\"crying\" /></h1>

    <p style=\"text-align: justify;\"><span style=\"font-size:15px\">I hate to bear bad news, but there aren&#39;t any <br /> events this week that match your preferences.&nbsp;</span>
    </p><br />

    <hr />
    
    <p style=\"font-size:15px\">Want to try something new? Why not give this event&nbsp;a shot:&nbsp;
    <br /></p>

    <p><br />
    <span style=\"font-size:24px\"><a href=\"#{event1.link}\" target=\"_blank\">#{event1.name}</a></span></p>

    <p>
    This event is taking place on #{datetime_string}. The location is #{event1.location} and it #{rsvp}<br />
    <br />
    If you&#39;d like to add this event to your calendar, <a href=\"#{event1.calendar_event_link}\" target=\"_blank\">click here</a>.<br />
    <br />
    <p style=\"text-align: center\"><br />
    <span style=\"font-size:16px\"><a href=\"#{ouab_link}\" target=\"_blank\"><span style=\"border-radius:30px;background:#3346a4;color:white;padding:10px;text-align:center;display:inline-block\">Take a look at the other events happening today</span></a></span></p>

    <br /><br /><br />

    <div style=\"text-align: center;\"><em>Copyright &copy; 2021 Team Fire, All     rights reserved.</em><br />
      <br />
      <strong>Our mailing address is:</strong><br />
      2098 Ohio Union, 1739 N. High Street, Columbus, OH 43210<br />
      <br />
      Want to change how you receive these emails?<br />
      You can <a href=\"https://forms.gle/wW3JNC9dYmJ2ZPDe7\" target=\"_blank\">update your preferences</a> or <a href=\"mailto:teamfire3901@gmail.com?subject=Unsubscribe&amp;body=Unsubscribe\" target=\"_blank\">unsubscribe from this list</a>.</div>"
  end

  #turns the datetime from an Event object into a nicely formatted string for emails
  def self.datetime_tostring(event1)
    datetime_string = event1.datetime.strftime("%A %B %-d, %Y at %I:%M %p")
  end

  
end

#executable code to run program
Emailer.send_daily_newsletter
