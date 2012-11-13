require 'rubygems'
require 'grape'
require 'json'
require '3scale/client'
require "#{File.dirname(__FILE__)}/analyzer"

class SentimentApiV2_1 < Grape::API
  version 'v2.1', :using => :path, :vendor => '3scale'
  error_format :json
  
  #Links to 3scale infrastructure
  $client = ThreeScale::Client.new(:provider_key => "f7bf6b41a6c0fda7a9c8c0cf00e0f611")
  
  #Sentiment Logic component
  @@the_logic = Analyzer.new

  ##~ sapi = source2swagger.namespace("sentiment_api_v2.1")
  ##~ sapi.basePath = "sentiment-test.herokuapp.com"
  ##~ sapi.apiVersion = "v2.1"
  ##
  ## -- Parameters
  ##~ @par_app_id = {:name => "app_id", :description => "Your access application id", :dataType => "string", :paramType => "query", :threescale_name => "app_ids"}
  ##~ @par_app_key = {:name => "app_key", :description => "Your access application key", :dataType => "string", :paramType => "query", :threescale_name => "app_keys"}
  ##
  ##~ a = sapi.apis.add
  ##~ a.set :path => "/v2.1/words/{word}.json"
  ##~ op = a.operations.add
  ##~ op.set :httpMethod => "GET"
  ##~ op.summary = "Returns the sentiment value of a given word"
  ##~ op.description = "<p>This operation returns the sentiment value on a scale from -5 to +5 of the given word.<p>For instance, the word \"awesome\" returns {\"word\":\"awesome\",\"sentiment\":4} with a positive connotation whereas \"damnit\" is less positive {\"word\":\"damnit\",\"sentiment\":-4}"
  ##~ op.group = "words"
  ##~ op.parameters.add :name => "word", :description => "The word whose sentiment is returned", :dataType => "string", :required => true, :paramType => "path"
  ##~ op.parameters.add @par_app_id
  ##~ op.parameters.add @par_app_key
  ## 
  
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

    ##~ op = a.operations.add
    ##~ op.set :httpMethod => "POST"
    ##~ op.summary = "Sets the sentiment value of a given word"
    ##~ op.description = "<p>This operation allows you to set the sentiment value to a word.<p>The sentiment value needs to be on the range -5 to +5."
    ##~ op.group = "words"
    ##~ op.parameters.add :name => "word", :description => "The word whose sentiment is returned", :dataType => "string", :required => true, :paramType => "path"
    ##~ op.parameters.add :name => "value", :description => "The sentiment value of the word, must be -5 to -1 for negative or to +1 to +5 for positive connotations", :allowableValues => {:values => ["-5","-4","-3","-2","-1","1","2","3","4","5"], :valueType => "LIST"}, :dataType => "string", :required => true, :defaultValue => "1", :paramType => "query"
    ##~ op.parameters.add @par_app_id
    ##~ op.parameters.add @par_app_key
    ##
    
    post ':word' do
      authenticate!
      report!('word/post', 1)
      res =  @@the_logic.add_word(params[:word],params[:value])
      res.to_json
    end 
  end
  
  ##~ a = sapi.apis.add
  ##~ a.set :path => "/v2.1/sentences/{sentence}.json"
  ##~ op = a.operations.add
  ##~ op.set :httpMethod => "GET"
  ##~ op.summary = "Returns the aggregated sentiment of a sentence"
  ##~ op.description = "<p>This operation returns the aggregated value of a sentence based on the individual sentiment values of the words of the sentence.<p>The result for \"3scale rocks\" would be {\"sentence\":\"3scale rocks\",\"count\":2,\"certainty\":0.5,\"sentiment\":4.0}, overall sentiment of 4 in a -5 to +5 scale with certainty of 50% because only one word had a defined sentiment value."
  ##~ op.group = "sentence"
  ##~ op.parameters.add :name => "sentence", :description => "The sentence to be analyzed", :dataType => "string", :required => true, :paramType => "path"
  ##~ op.parameters.add @par_app_id
  ##~ op.parameters.add @par_app_key
  ##

  resource :sentences do
    get ':sentence' do
      authenticate!
      report!('sentence/get', 1)
      @@the_logic.sentence(params[:sentence]).to_json
    end
  end

end
