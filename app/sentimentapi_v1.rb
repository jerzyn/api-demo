require 'rubygems'
require 'grape'
require 'json'
require "#{File.dirname(__FILE__)}/analyzer"

class SentimentApiV1 < Grape::API
  version 'v1', :using => :path, :vendor => '3scale'
  error_format :json

  @@the_logic = Analyzer.new
  
  resource :words do
    get ':word' do
      #{:word => params[:word], :sentiment => "unkown"}.to_json
      @@the_logic.word(params[:word]).to_json
    end
    
    post ':word' do
      #{:word => params[:word], :result => "thinking"}.to_json
      res =  @@the_logic.add_word(params[:word],params[:value])
      res.to_json
    end 
  end
  
  resource :sentences do
    get ':sentence' do
      #{:sentence => params[:sentence], :result => "unkown"}.to_json
      @@the_logic.sentence(params[:sentence]).to_json
    end
  end

end
