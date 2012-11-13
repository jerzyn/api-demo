require 'rubygems'
require 'grape'
require 'json'

class SentimentApiV1 < Grape::API
  version 'v1', :using => :path, :vendor => '3scale'
  error_format :json
  
  resource :words do
    get ':word' do
        {:word => params[:word], :sentiment => "unkown"}.to_json
    end
    
    post ':word' do
      {:word => params[:word], :result => "thinking"}.to_json
    end 
  end
  
  resource :sentences do
    get ':sentence' do
      {:sentence => params[:sentence], :result => "unkown"}.to_json
    end
  end

end
