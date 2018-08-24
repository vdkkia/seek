# Document
Factory.define(:document) do |f|
  f.title 'This Document'
  f.with_project_contributor
  f.association :content_blob, factory: :content_blob, content_type: 'application/pdf'
end

Factory.define(:public_document, parent: :document) do |f|
  f.policy { Factory(:downloadable_public_policy) }
end

Factory.define(:private_document, parent: :document) do |f|
  f.policy { Factory(:private_policy) }
end

Factory.define(:min_document, class: Document) do |f|
  f.with_project_contributor
  f.title 'A Minimal Document'
  f.policy { Factory(:downloadable_public_policy) }
  f.association :content_blob, factory: :min_content_blob, content_type: 'application/pdf'
end

Factory.define(:max_document, class: Document) do |f|
  f.with_project_contributor
  f.title 'A Maximal Document'
  f.description 'The important report we did for ~important-milestone~'
  f.policy { Factory(:downloadable_public_policy) }
  f.assays {[Factory.build(:max_assay, policy: Factory(:public_policy))]}
  f.relationships {[Factory(:relationship, predicate: Relationship::RELATED_TO_PUBLICATION, other_object: Factory(:publication))]}
  f.association :content_blob, factory: :min_content_blob, content_type: 'application/pdf'
  f.other_creators 'Blogs, Joe'
end

Factory.define(:api_pdf_document, parent: :document) do |f|
  f.association :content_blob, factory: :blank_pdf_content_blob
end

# Factory::Version
Factory.define(:document_version, class: Document::Version) do |f|
  f.association :document
  f.projects { document.projects }
  f.version { document.version + 1 }
  f.title { document.title }
  f.content_blob { Factory(:pdf_content_blob, asset_version: version, asset_type: parent.class.name) }
  f.after_create do |v|
    v.document.update_column(:version, v.version)
  end
end
