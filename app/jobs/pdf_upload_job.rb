class PdfUploadJob < ApplicationJob
  queue_as :default

  def perform(document_id)
    document = Document.find_by(id: document_id)
    return unless document

    Rails.logger.info "PdfUploadJob: Processing uploaded PDF for Document ##{document.id} - #{document.title}"
    # Additional background processing logic for the PDF can go here
  end
end
