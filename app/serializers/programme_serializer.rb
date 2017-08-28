class ProgrammeSerializer < AvatarObjSerializer

  # include AssociationsHelper
  #
  attribute :title
  attribute :description
  attribute :web_page
  attribute :funding_details
  attribute :tags do
    serialize_annotations(object, context='funding_code')
    end

  BaseSerializer.rels(Programme, ProgrammeSerializer)
end
