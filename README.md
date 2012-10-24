## 3scale Example Sentiment API - V2: Adding Sentiments and Analytics

This is an example API which returns the sentiment value of a word or a sentence and is part of an Example series - find the other versions of the API which each illustrate something on the <a href="blob/directories/README.md">example homepage</a>. You can define the sentiment value of any additional word that is not in the dictionary.

##  Version 2

This is version 2. See the full version lists [here](https://github.com/3scale/sentiment-api-example/blob/master/README.md).

This version takes version 1 and adds proper sentiment responses to method calls and simple analytics tracking for the API with 3scale. 

## Adding 3scale

The demo uses 3scale authentication for API calls. To set this up you need a free account and key from http://www.3scale.net/. 

 * Create a free account. 

 * Navigate to the "Account" page (top right of the screen) to retrieve you provider key.

 * Navigate to the "Accounts" listing (main menu) to retrieve a sample _AppID_ and _AppKey_ for the example calls.

## Configuration (Generic)

Generic Setup is as follows: 

 * Change to the directory of the version you want to execute for local execution (version_1, version_2 etc.)

 * Ensure you have the right base Gems available:

	$ gem install grape
	$ gem install 3scale_client
	
   If you're using Bundler, add the gem to Gemfile (there is a sample Gemfile in the repository)
	
	gem 'grape'
	gem '3scale_client'
	
 * Also make sure you have some JSON helpers available 

	$ gem install json
	
   If you're using Bundler, add the gem to Gemfile (there is a sample Gemfile in the repository)
	
	gem 'json'

 * In app/sentimentapi.rb code ensure you're requiring the right gems:
 
	require 'grape'
	require 'json'
	require '3scale_client'
	
 * Start the API...

	$ exec rackup
	

## Configuration (Heroku)

If you're using Heroku, follow these instructions (based on https://devcenter.heroku.com/articles/quickstart, https://devcenter.heroku.com/articles/ruby).

Note that Heroku requires the config.ru, procfile etc. to be in the top level directory, so you'll need to make sure the symlinks there are all updated to point to the right version. When you check out the bundle they will always point to the latest version of the API. Check <a href="">here</a> for more information on symlinks.


 * Make sure you have the "Heroku toolbelt":https://toolbelt.heroku.com/ installed.

 * Login to Heroku

	$ heroku login
	
 * Check the Gemfile is present and correct (in the repository).

 * Check the Procfile is present and correct (in the repository). It should contain a line like:

	web: bundle exec rackup config.ru -p $PORT

 * Run this with foreman - by default it will run on port 5000

	$ foreman start
	
Once you have tested it works locally, you can deploy to Heroku in the normal way:

 * Add to Git:

	$ git init
	$ git add .
	$ git commit -m "init"
	
 * Create the app:

	$ heroku create
	
 * Push and Launch

	$ git push heroku master
	
 * Check it is running: 

	$ heroku ps
	
 * Check the logs:

	$ heroku logs
	
You can visit the app with "$ heroku open" - however, you will likely get a 404 error on the home page - you need to navigate to the right resource URLs (below). See the "Heroku ruby pages":https://devcenter.heroku.com/articles/ruby for more details on deployment and trouble shooting.

## Usage

Using one of the methods above, your API should now be ready for use. 

Call one method of the API with curl (or with your browser if you want)

	curl -X GET -g "http://localhost:5000/v2/words/fantastic.json

The above call returns 

	{"word:"fantastic","sentiment":"unkown"}






