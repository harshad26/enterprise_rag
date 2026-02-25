class Document < ApplicationRecord
  belongs_to :user

  has_one_attached :pdf

  validates :title, presence: true
  validates :pdf, presence: true

  after_commit :enqueue_upload_job, on: :create
  after_commit :enqueue_deletion_job, on: :destroy

  private

  def enqueue_upload_job
    PdfUploadJob.perform_later(self.id)
  end

  def enqueue_deletion_job
    PdfDeletionJob.perform_later(self.id, self.title)
  end
end
