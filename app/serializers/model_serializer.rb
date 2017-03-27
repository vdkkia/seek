class ModelSerializer < BaseSerializer
  attributes :id, :title, :description, :latest_version, :version, :versions
  attributes :model_type, :model_format
  attribute :environment do
    object.recommended_environment
  end

  has_many :content_blob do
    object.content_blobs
  end
end
