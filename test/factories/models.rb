# ModelFormat
Factory.define(:model_format) do |f|
  f.sequence(:title) { |n| "format #{n}" }
end

# Model
Factory.define(:model) do |f|
  f.sequence(:title) { |n| "A Model #{n}" }
  f.with_project_contributor
  f.content_blobs { [Factory(:cronwright_model_content_blob)] }
end

Factory.define(:min_model, class: Model) do |f|
  f.with_project_contributor
  f.title 'A Minimal Model'
  f.projects { [Factory.build(:min_project)] }
end

Factory.define(:max_model, class: Model) do |f|
  f.with_project_contributor
  f.title 'A Maximal Model'
  f.description 'Hidden Markov Model'
  f.projects { [Factory.build(:max_project)] }
  f.assays {[Factory.build(:max_assay, policy: Factory(:public_policy))]}
  f.relationships {[Factory(:relationship, predicate: Relationship::RELATED_TO_PUBLICATION, other_object: Factory(:publication))]}
  f.content_blobs { [Factory(:cronwright_model_content_blob), Factory(:rightfield_content_blob)] }
  f.other_creators 'Blogs, Joe'
end

Factory.define(:model_2_files, parent: :model) do |f|
  f.content_blobs { [Factory(:cronwright_model_content_blob), Factory(:rightfield_content_blob)] }
end

Factory.define(:model_2_remote_files, parent: :model) do |f|
  f.content_blobs { [Factory(:url_content_blob), Factory(:url_content_blob)] }
end

Factory.define(:model_with_image, parent: :model) do |f|
  f.sequence(:title) { |n| "A Model with image #{n}" }
  f.after_create do |model|
    model.model_image = Factory(:model_image, model: model)
  end
end

Factory.define(:model_image) do |f|
  f.original_filename 'file_picture.png'
  f.image_file fixture_file_upload("#{Rails.root}/test/fixtures/files/file_picture.png", 'image/png')
  f.content_type 'image/png'
end

Factory.define(:cronwright_model, parent: :model) do |f|
  f.content_blobs { [Factory(:cronwright_model_content_blob)] }
end

Factory.define(:teusink_model, parent: :model) do |f|
  f.content_blobs { [Factory(:teusink_model_content_blob)] }
end

Factory.define(:xgmml_model, parent: :model) do |f|
  f.content_blobs { [Factory(:xgmml_content_blob)] }
end

Factory.define(:teusink_jws_model, parent: :model) do |f|
  f.content_blobs { [Factory(:teusink_jws_model_content_blob)] }
end

Factory.define(:non_sbml_xml_model, parent: :model) do |f|
  f.content_blobs { [Factory(:non_sbml_xml_content_blob)] }
end

Factory.define(:invalid_sbml_model, parent: :model) do |f|
  f.content_blobs { [Factory(:invalid_sbml_content_blob)] }
end

Factory.define(:typeless_model, parent: :model) do |f|
  f.content_blobs { [Factory(:typeless_content_blob)] }
end

Factory.define(:doc_model, parent: :model) do |f|
  f.content_blobs { [Factory(:doc_content_blob)] }
end

Factory.define(:api_model, parent: :model) do |f|
  f.content_blobs { [Factory(:blank_pdf_content_blob), Factory(:blank_xml_content_blob)] }
end

# Model::Version
Factory.define(:model_version, class: Model::Version) do |f|
  f.association :model
  f.projects { model.projects }
  f.version { model.version + 1 }
  f.title { model.title }
  f.content_blobs { [Factory(:pdf_content_blob, asset_version: version, asset_type: parent.class.name)] }
  f.after_create do |v|
    v.model.update_column(:version, v.version)
  end
end

Factory.define(:model_version_with_blob, parent: :model_version) do |f|
  f.content_blobs { [Factory(:teusink_model_content_blob, asset_version: version, asset_type: parent.class.name)] }
end
