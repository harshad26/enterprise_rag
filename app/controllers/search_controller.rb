class SearchController < ApplicationController
  def index
    @query = params[:query]

    if @query.present?
      require "faraday"
      require "json"

      conn = Faraday.new(url: "http://localhost:8000")

      response = conn.post("/search") do |req|
        req.headers["Content-Type"] = "application/json"
        req.body = { query: @query }.to_json
      end

      if response.success?
        @results = JSON.parse(response.body)
      else
        @results = []
      end
    end
  end
end
