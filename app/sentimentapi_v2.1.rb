require 'rubygems'
require 'grape'
require 'json'
require '3scale/client'
require "#{File.dirname(__FILE__)}/analyzer"

class SentimentApiV2_1 < Grape::API
  version 'v2.1', :using => :path, :vendor => '3scale'
  error_format :json
  
  #Links to 3scale infrastructure
  $client = ThreeScale::Client.new(:provider_key => "dda257b85eae0686d9d51908e585cae7")
  
  #Sentiment Logic component
  @@the_logic = Analyzer.new
  
  helpers do
    def authenticate!
      response = $client.authorize(:app_id => params[:app_id], :app_key => params[:app_key])
      error!('403 Unauthorized', 403) unless response.success?
    end
    
    def report!(method_name='hits', usage_value=1)      
      response = $client.report({:app_id => params[:app_id],  :usage => {method_name => usage_value}})
      error!('505 Reporting Error', 505) unless response.success?
    end
    
  end
  
  resource :words do
    get ':word' do
        authenticate!
        report!('word/get', 1)
        @@the_logic.word(params[:word]).to_json
    end
    
    post ':word' do
      authenticate!
      report!('word/post', 1)
      res =  @@the_logic.add_word(params[:word],params[:value])
      res.to_json
    end 
  end
  
  resource :sentences do
    get ':sentence' do
      authenticate!
      report!('sentence/get', 1)
      @@the_logic.sentence(params[:sentence]).to_json
    end
  end

end
