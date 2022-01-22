# team_fire_project_3
Team Fire's Project #3 -- Student Events Calendar Web Scraper

Written by:  
------------
Wenjin Fu  
Gabby Rigol  
Michael Taylor  
Yu Xiong  

HOW TO USE
===========
This project enables users to get emails notifying them of events from the student life event calendar that might interest them.   
<br>
To get an event email:  
<br>
Add yourself to 'user.json'. This includes details like name, email, and preferences. <br>Preferences include preferred times of day (when reccomended events should be), <br>and preferred event categories, audiences, programs, tags, and department (as listed on the event page). <br>
For ease of use, we have added a user in the file that is named "Grader Grader". If you would like to just use this user, you will only need to change the email address to your own.<br>

Run 'bundle exec ruby emailer.rb'.    
The scraper will examine the next week's  events, filter down to those that interest the user, and email a random matching one.  
If user preferences are strict enough that no event matches, a completely random event will be emailed instead.
Enjoy! 
<br><br>
Please Note: OSU's links to add events to your google calendar currently appear to be broken for some events, and thus the links in the emails to add those events to your calendar do not work. If Ohio State updates the links on their website, then the links in our emails will work correctly. 

Project Design
=============================
The project is broken up into 6 classes.

Event
-----
The abstraction of a single calendar event.  
Includes details like event name, location, date, time, etc...   

Event Set
--------
A wrapper class around two arrays of events: a whole event list and a filtered event list.  
Upon creation, the whole event list is populated with every event from all the days provided.  
Includes methdos to move events to the filtered list and filter events on the filtered list.  
Used by the user class so that users can make selections for which type of events they would like to be notified of.

User
----
Abstraction of a user who would like to be notified of events on the calendar.  
Has an email, and other preferences that filter which type of events they get notified of.

Emailer
------
Static utility class used by the user class to send emails to the appropriate email.

Parser
------
Static utility class used by the event class to extract event data from an event page HTML with Nokogiri.

Scraper
-------
Static utility class used by the EventSet class to get the HTML for calendar events and calendar days (lists of events).

