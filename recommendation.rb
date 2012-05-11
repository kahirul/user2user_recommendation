require 'rubygems'
require 'sinatra'
require 'json'
require './user_recommendation'

get "/recommendation/:user_id/:product_id/json" do
  content_type :json
  user_rec = UserRecommendation.new(params[:user_id], params[:product_id]).products
  if user_rec
    JSON.generate(user_rec)
  else
    JSON.generate([])
  end
end
