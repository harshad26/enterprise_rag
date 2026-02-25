class DocumentsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_admin!, only: [ :new, :create, :destroy ]

  def index
    @documents = Document.all.order(created_at: :desc)
  end

  def show
    @document = Document.find(params[:id])
  end

  def new
    @document = Document.new
  end

  def create
    @document = current_user.documents.build(document_params)
    if @document.save
      redirect_to documents_path, notice: "Document successfully uploaded."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @document = Document.find(params[:id])
    @document.destroy
    redirect_to documents_path, notice: "Document successfully deleted."
  end

  private

  def ensure_admin!
    redirect_to root_path, alert: "Not authorized." unless current_user.admin?
  end

  def document_params
    params.require(:document).permit(:title, :pdf)
  end
end
