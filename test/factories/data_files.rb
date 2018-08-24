# DataFile
Factory.define(:data_file) do |f|
  f.with_project_contributor
  f.sequence(:title) { |n| "A Data File_#{n}" }
  f.association :content_blob, factory: :pdf_content_blob
end

Factory.define(:min_datafile, class: DataFile) do |f|
  f.with_project_contributor
  f.title 'A Minimal DataFile'
  f.projects { [Factory.build(:min_project)] }
  f.association :content_blob, factory: :pdf_content_blob
end

Factory.define(:max_datafile, class: DataFile) do |f|
  f.with_project_contributor
  f.title 'A Maximal DataFile'
  f.description 'Results - Sampling conformations of ATP-Mg inside the binding pocket'
  f.projects { [Factory.build(:max_project)] }
  f.assays {[Factory.build(:max_assay, policy: Factory(:public_policy))]}
  f.events {[Factory.build(:event, policy: Factory(:public_policy))]}
  f.relationships {[Factory(:relationship, predicate: Relationship::RELATED_TO_PUBLICATION, other_object: Factory(:publication))]}
  f.association :content_blob, factory: :pdf_content_blob
  f.other_creators 'Blogs, Joe'
end

Factory.define(:rightfield_datafile, parent: :data_file) do |f|
  f.association :content_blob, factory: :rightfield_content_blob
end

Factory.define(:blank_rightfield_master_template_data_file, parent: :data_file) do |f|
  f.association :content_blob, factory: :blank_rightfield_master_template
end


Factory.define(:rightfield_annotated_datafile, parent: :data_file) do |f|
  f.association :content_blob, factory: :rightfield_annotated_content_blob
end

Factory.define(:non_spreadsheet_datafile, parent: :data_file) do |f|
  f.association :content_blob, factory: :cronwright_model_content_blob
end

Factory.define(:xlsx_spreadsheet_datafile, parent: :data_file) do |f|
  f.association :content_blob, factory: :xlsx_content_blob
end

Factory.define(:xlsm_spreadsheet_datafile, parent: :data_file) do |f|
  f.association :content_blob, factory: :xlsm_content_blob
end

Factory.define(:small_test_spreadsheet_datafile, parent: :data_file) do |f|
  f.association :content_blob, factory: :small_test_spreadsheet_content_blob
end

Factory.define(:strain_sample_data_file, parent: :data_file) do |f|
  f.association :content_blob, factory: :strain_sample_data_content_blob
end

Factory.define(:jerm_data_file, class: DataFile) do |f|
  f.sequence(:title) { |n| "A Data File_#{n}" }
  f.contributor nil
  f.projects { [Factory.build(:project)] }
  f.association :content_blob, factory: :url_content_blob
end

Factory.define(:subscribable, parent: :data_file) {}

# DataFile::Version
Factory.define(:data_file_version, class: DataFile::Version) do |f|
  f.association :data_file
  f.projects { data_file.projects }
  f.version { data_file.version + 1 }
  f.title { data_file.title }
  f.content_blob { Factory(:pdf_content_blob, asset_version: version, asset_type: parent.class.name) }
  f.after_create do |v|
    v.data_file.update_column(:version, v.version)
  end
end

Factory.define(:data_file_version_with_blob, parent: :data_file_version) do |f|
  f.content_blob { Factory(:pdf_content_blob, asset_version: version, asset_type: parent.class.name) }
end

Factory.define(:api_pdf_data_file, parent: :data_file) do |f|
  f.association :content_blob, factory: :blank_pdf_content_blob
end

Factory.define(:api_txt_data_file, parent: :data_file) do |f|
  f.association :content_blob, factory: :blank_txt_content_blob
end
