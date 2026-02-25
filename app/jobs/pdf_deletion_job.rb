class PdfDeletionJob < ApplicationJob
  queue_as :default

  # Background process to POST API call to delete the PDF from the AI service
  def perform(document_id, document_title)
    require "faraday"
    require "json"

    conn = Faraday.new(url: "http://localhost:8000") do |f|
      f.request :json
      f.response :json
      f.adapter Faraday.default_adapter
    end

    response = conn.post("/delete-pdf") do |req|
      req.headers["Content-Type"] = "application/json"
      req.body = { document_id: document_id }
    end

    if response.success?
      Rails.logger.info "AI Delete Success: #{response.body}"
    else
      Rails.logger.error "AI Delete Failed: #{response.status} - #{response.body}"
    end
  end
end
