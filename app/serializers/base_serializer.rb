class BaseSerializer < SimpleBaseSerializer
  include ApiHelper

  def self.rels(c, s)
    if c.name.blank?
      return
    end
    method_hash = {}
    begin
      resource_klass = c
      ['Person', 'Project', 'Institution', 'Investigation',
       'Study','Assay', 'DataFile', 'Model', 'Sop', 'Publication', 'Presentation', 'Event',
       'Workflow', 'TavernaPlayer::Run', 'Sweep', 'Strain', 'Sample'].each do |item_type|
        if item_type == 'TavernaPlayer::Run'
          method_name = 'runs'
        else
          method_name = item_type.underscore.pluralize
        end

        if resource_klass.method_defined? "related_#{method_name}"
          method_hash[item_type] = "related_#{method_name}"
        elsif resource_klass.method_defined?  "related_#{method_name.singularize}"
          method_hash[item_type] = "related_#{method_name.singularize}"
        elsif resource_klass.method_defined? method_name
          method_hash[item_type] = method_name
          # elsif item_type != 'Person' && resource_klass.method_defined? method_name.singularize # check is to avoid Person.person
          #   method_hash[item_type] = method_name
        else
          []
        end
      end
    rescue
    end
    method_hash
    unless  method_hash.blank?
      method_hash.each do |k, v|
        begin
          s.has_many v, key: k.pluralize.downcase
        end
      end
    end

  end

  def meta
    #content-blob doesn't have timestamps
    if object.respond_to?('created_at')
      created = object.created_at
      updated = object.updated_at
    end
    if object.respond_to?('uuid')
      uuid = object.uuid
    end
    {
        created: created || "",
        modified: updated || "",
        uuid: uuid || "",
        base_url: base_url
    }
  end
end