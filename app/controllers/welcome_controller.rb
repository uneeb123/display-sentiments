require 'mongo'

DATABASE_URL = ENV['DB_SENTIMENTS'] || 'mongodb://127.0.0.1:27017/test'

class WelcomeController < ApplicationController
  def index
    initial_date = (Time.now - 1.day).to_i
    db_client = Mongo::Client.new(DATABASE_URL)
    sentiments_collection = db_client[:sentiment2]
    @sentiments = []
    sentiments_collection.find(:time => {:$gte => initial_date}).each do |document|
      element = []
      element << document["time"]
      element << document["overall_sentiment"]
      @sentiments << element
    end

    @hello = "Mr. Bond"
  end
end
