# team_fire_project_4
Professor Dey's Website as it Should Have Been

Written by:  
------------
Wenjin Fu  
Gabby Rigol  
Michael Taylor  
Yu Xiong  

HOW TO USE
===========

Ensure all appropriate gems are installed with '$bundle install'.
Run '$bundle exec middleman build'.    
Open the firefox browser pointed to index.html via '$firefox build/index.html'.  
Browse and behold what Tamal Dey's website *could* have been.

Project Design
=============================
The website is broken into four pages and one common element (a navbar) shared between them all.

Home page
-----
This page is titled "Home", but is associated with "index.html" per standard.  

It contains both his own basic personal description and a list of classes he's taught, since that is likely what would be of highest interests of students visiting the page.  
Its data is located in the data file "teaching.yml".

Professional Activities
--------
This page is titled "Professional Activities", and is thus associated with "professional_activities.html".

It contains the content of the original "Professional Activities" section compressed into a single table.
Its data is located in the data file "professional_activities.yaml".

Research
----
This page is titled "Research", and is thus associated with "research.html".

It contains the content of the original "Research" section, but broken apart into a single column of data for greater readability.  
Its data is located in the data files "projects.yml", "software.yml", and "personnel.yml".

Literature and Education
------
This page is titled "Literature and Education", and is associated with "credibility.html" -- since it largely contains those elements that demonstrate an academics credibility.

It contains three principle elements:
1. A brief description of each book authored
2. A link to an external site describing papers and chapters authored
3. A table describing each of degrees earned, including location and time
Its data is located in the data files "books.yml" and "education.yml".

Navbar
------
Contains links to each page. Is located at the top of every page.
