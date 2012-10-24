require 'rubygems'
require 'grape'
require 'json'
require '3scale/client'
require "#{File.dirname(__FILE__)}/analyzer"

class SentimentApiV2 < Grape::API
  version 'v2', :using => :path, :vendor => '3scale'
  error_format :json
  
  #Links to 3scale infrastructure
  $client = ThreeScale::Client.new(:provider_key => "db0e2b4bb3f2ceb3fbb00302a39f2cf8")
  
  #Sentiment Logic component
  @@the_logic = Analyzer.new
  
  helpers do
    def authenticate!
      response = $client.authorize(:app_id => params[:app_id], :app_key => params[:app_key])
      error!('403 Unauthorized', 403) unless response.success?
    end
  end
  
  resource :words do
    get ':word' do
        authenticate!
        @@the_logic.word(params[:word]).to_json
    end
    
    post ':word' do
      authenticate!
      res =  @@the_logic.add_word(params[:word],params[:value])
      res.to_json
    end 
  end
  
  resource :sentences do
    get ':sentence' do
      authenticate!
      @@the_logic.sentence(params[:sentence]).to_json
    end
  end

end
