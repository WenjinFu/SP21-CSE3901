# Activate and configure extensions
# https://middlemanapp.com/advanced/configuration/#configuring-extensions

activate :autoprefixer do |prefix|
  prefix.browsers = "last 2 versions"
end


# Per-page layout changes
page '/*.xml', layout: false
page '/*.json', layout: false
page '/*.txt', layout: false



###
# Site settings
###
set :site_url, 'http://web.cse.ohio-state.edu/~dey.8/'
set :site_title, 'Tamal Krishna Dey'
set :site_subtitle, 'Professor'
set :homepage_text, 'As of August 17, 2020 I will be joining the Department of Computer Science at Purdue University.'
set :site_author, 'Tamal K Dey'


# Usernames
set :ACM, 'ACM Fellow'
set :IEEE, 'IEEE Fellow'
set :SMA, 'SMA Fellow'
set :OSU, 'tamaldey@cse.ohio-state.edu'
set :Purdue, 'tamaldey@purdue.edu'


# Build-specific configuration
# https://middlemanapp.com/advanced/configuration/#environment-specific-settings

configure :build do
  activate :minify_css
  activate :minify_javascript
end
