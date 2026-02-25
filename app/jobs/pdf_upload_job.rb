class PdfUploadJob < ApplicationJob
  queue_as :default

  def perform(document_id)
    require "faraday/multipart"
    document = Document.find_by(id: document_id)

    conn = Faraday.new(url: "http://localhost:8000") do |f|
      f.request :multipart
      f.request :url_encoded
      f.adapter Faraday.default_adapter
    end

    document.pdf.open do |tempfile|
      conn.post("/process-pdf") do |req|
        req.headers["Content-Type"] = "multipart/form-data"
        req.body = {
          document_id: document_id,
          file: Faraday::Multipart::FilePart.new(
            tempfile.path,
            "application/pdf",
            document.pdf.filename.to_s
          )
        }
      end
    end

    Rails.logger.info "PdfUploadJob: Processing uploaded PDF for Document ##{document.id} - #{document.title}"
  end
end
