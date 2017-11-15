class ProjectSerializer < AvatarObjSerializer

  include PolicyHelper

  # class ProjectSerializer < ActiveModel::Serializer
  attributes :title, :description,
             :web_page, :wiki_page
  attribute :default_policy, if: :administerable?

  def default_policy
    { 'access' => default_access,
    'permissions' => permits }
  end

  def default_access
    return access_type_key object.default_policy.access_type
  end

  def permits
    result = []
    object.default_policy.permissions.each do |p|
    result.append ({'resource_type' => p.contributor_type.downcase.pluralize,
                    'resource_id' => p.contributor_id,
                    'access' => explicit_access(p.access_type) } )
    end
    return result
  end

  def administerable?
    answer = false
    begin
      answer = object.can_be_administered_by?(current_user)
    rescue
    end
    return answer
  end

  def explicit_access access_type
    return access_type_key access_type
  end

  has_many :organisms,  include_data: true

  has_many :people
  has_many :institutions
  has_many :programmes
  has_many :investigations
  has_many :studies
  has_many :assays
  has_many :data_files
  has_many :models
  has_many :sops
  has_many :publications
  has_many :presentations
  has_many :events
  has_many :strains
  has_many :samples
end
