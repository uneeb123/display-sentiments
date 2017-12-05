require 'aws-sdk'
require 'json'

CREDENTIALS_FILE = 'aws.json'.freeze


class WelcomeController < ApplicationController
  def index
    credentials = get_credentials_from_file
    
    Aws.config.update({
      region: "us-west-2",
      endpoint: "http://localhost:8000",
      credentials: Aws::Credentials.new(credentials['akid'], credentials['secret'])
    })

    dynamodb = Aws::DynamoDB::Client.new

    initial_date = (Time.now - 1.day).to_i
    response = dynamodb.scan(table_name: 'Sentiments2')
    all_items = response.items
=begin
    query_params = {
      table_name: 'Sentiments2',
      key_condition_expression: 'created_on > :date',
      expression_attribute_values: {
        ':date' => initial_date,
      }
    }
    byebug
    response = dynamodb.query(query_params)
=end

    @sentiments = []
    all_items.each do |item|
      element = []
      next unless item["created_on"].to_i > initial_date
      element << item["created_on"].to_i
      element << item["sentiment"].to_f
      @sentiments << element
    end
  end

  def get_credentials_from_file
    JSON.parse(File.read(CREDENTIALS_FILE))
  end
end
