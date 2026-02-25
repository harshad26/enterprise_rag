class PdfDeletionJob < ApplicationJob
  queue_as :default

  def perform(document_id, document_title)
    Rails.logger.info "PdfDeletionJob: Clean up tasks for deleted Document ##{document_id} - #{document_title}"
    # Logic for when a PDF is deleted (e.g., removing from a vector database)
  end
end
