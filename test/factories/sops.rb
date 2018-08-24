# Sop
Factory.define(:sop) do |f|
  f.title 'This Sop'
  f.with_project_contributor
  f.association :content_blob, factory: :content_blob, original_filename: 'sop.pdf', content_type: 'application/pdf'
end

Factory.define(:min_sop, class: Sop) do |f|
  f.with_project_contributor
  f.title 'A Minimal Sop'
  f.projects { [Factory.build(:min_project)] }
  f.association :content_blob, factory: :min_content_blob, content_type: 'application/pdf'
end

Factory.define(:max_sop, class: Sop) do |f|
  f.with_project_contributor
  f.title 'A Maximal Sop'
  f.description 'How to run a simulation in GROMACS'
  f.projects { [Factory.build(:max_project)] }
  f.assays {[Factory.build(:max_assay, policy: Factory(:public_policy))]}
  f.relationships {[Factory(:relationship, predicate: Relationship::RELATED_TO_PUBLICATION, other_object: Factory(:publication))]}
  f.association :content_blob, factory: :min_content_blob, content_type: 'application/pdf'
  f.other_creators 'Blogs, Joe'
end

Factory.define(:doc_sop, parent: :sop) do |f|
  f.association :content_blob, factory: :doc_content_blob
end

Factory.define(:odt_sop, parent: :sop) do |f|
  f.association :content_blob, factory: :odt_content_blob
end

Factory.define(:pdf_sop, parent: :sop) do |f|
  f.association :content_blob, factory: :pdf_content_blob
end

# A SOP that has been registered as a URI
Factory.define(:url_sop, parent: :sop) do |f|
  f.association :content_blob, factory: :url_content_blob
end

# Sop::Version
Factory.define(:sop_version, class: Sop::Version) do |f|
  f.association :sop
  f.projects { sop.projects }
  f.version { sop.version + 1 }
  f.title { sop.title }
  f.content_blob { Factory(:pdf_content_blob, asset_version: version, asset_type: parent.class.name) }
  f.after_create do |v|
    v.sop.update_column(:version, v.version)
  end
end

Factory.define(:sop_version_with_blob, parent: :sop_version) do |f|
  f.content_blob { Factory(:pdf_content_blob, asset_version: version, asset_type: parent.class.name) }
end

# ExperimentalCondition
Factory.define(:experimental_condition) do |f|
  f.start_value 1
  f.sop_version 1
  f.association :measured_item, factory: :measured_item
  f.association :unit, factory: :unit
  f.association :sop, factory: :sop
  f.experimental_condition_links { [ExperimentalConditionLink.new(substance: Factory(:compound))] }
end

# ExperimentalConditionLink
Factory.define(:experimental_condition_link) do |f|
  f.association :substance, factory: :compound
  f.association :experimental_condition
end

# StudiedFactor
Factory.define(:studied_factor) do |f|
  f.start_value 1
  f.end_value 10
  f.standard_deviation 2
  f.data_file_version 1
  f.association :measured_item, factory: :measured_item
  f.association :unit, factory: :unit
  f.studied_factor_links { [StudiedFactorLink.new(substance: Factory(:compound))] }
  f.association :data_file, factory: :data_file
end

# StudiedFactorLink
Factory.define(:studied_factor_link) do |f|
  f.association :substance, factory: :compound
  f.association :studied_factor
end

# MeasuredItem
Factory.define(:measured_item) do |f|
  f.title 'concentration'
end

# Compound
Factory.define(:compound) do |f|
  f.sequence(:name) { |n| "glucose #{n}" }
end

# Synonym
Factory.define :synonym do |f|
  f.name 'coffee'
  f.association :substance, factory: :compound
end

# MappingLink
Factory.define :mapping_link do |f|
  f.association :substance, factory: :compound
  f.association :mapping, factory: :mapping
end

# Mapping
Factory.define :mapping do |f|
  f.chebi_id '12345'
  f.kegg_id '6789'
  f.sabiork_id '4'
end

Factory.define(:api_pdf_sop, parent: :sop) do |f|
  f.association :content_blob, factory: :blank_pdf_content_blob
end
