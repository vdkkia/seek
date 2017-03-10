class InstitutionSerializer < BaseSerializer
  attributes :id, :title,
             :country, :city, :address,
             :web_page, :avatars

  has_many :associated do
    associated_resources(object) # ||  { "data": [] }
  end
end


# using active_model_serializer - if we switch to RAILS >= 4
# class InstitutionSerializer < ActiveModel::Serializer
#   attributes :id, :title, :country, :city, :web_page
#   has_many :projects
#   has_many :people
# end