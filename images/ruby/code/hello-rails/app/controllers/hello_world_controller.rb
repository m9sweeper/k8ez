class HelloWorldController < ApplicationController

  def index
    render json: { data: 'Hello World !!!!!' }.to_json, status: 200
  end
end
