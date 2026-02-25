class User < ApplicationRecord
  devise :database_authenticatable, :validatable

  has_many :documents, dependent: :destroy
end
