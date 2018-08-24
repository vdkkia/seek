# Presentation
Factory.define(:presentation) do |f|
  f.sequence(:title) { |n| "A Presentation #{n}" }
  f.with_project_contributor
  f.association :content_blob, factory: :content_blob, original_filename: 'test.pdf', content_type: 'application/pdf'
end

Factory.define(:min_presentation, class: Presentation) do |f|
  f.with_project_contributor
  f.title 'A Minimal Presentation'
  f.association :content_blob, factory: :min_content_blob, original_filename: 'test.pdf', content_type: 'application/pdf'
end

Factory.define(:max_presentation, class: Presentation) do |f|
  f.with_project_contributor
  f.title 'A Maximal Presentation'
  f.description 'Non-equilibrium Free Energy Calculations and their caveats'
  f.assays {[Factory.build(:max_assay, policy: Factory(:public_policy))]}
  f.events {[Factory.build(:event, policy: Factory(:public_policy))]}
  f.relationships {[Factory(:relationship, predicate: Relationship::RELATED_TO_PUBLICATION, other_object: Factory(:publication))]}
  f.association :content_blob, factory: :min_content_blob, original_filename: 'test.pdf', content_type: 'application/pdf'
  f.other_creators 'Blogs, Joe'
end

Factory.define(:ppt_presentation, parent: :presentation) do |f|
  f.association :content_blob, factory: :ppt_content_blob
end

Factory.define(:odp_presentation, parent: :presentation) do |f|
  f.association :content_blob, factory: :odp_content_blob
end

Factory.define(:api_pdf_presentation, parent: :presentation) do |f|
  f.association :content_blob, factory: :blank_pdf_content_blob
end

# Presentation::Version
Factory.define(:presentation_version, class: Presentation::Version) do |f|
  f.association :presentation
  f.projects { presentation.projects }
  f.version { pres.version + 1 }
  f.title { pres.title }
  f.content_blob { Factory(:ppt_content_blob, asset_version: version, asset_type: parent.class.name) }
  f.after_create do |v|
    v.pres.update_column(:version, v.version)
  end
end

Factory.define(:presentation_version_with_blob, parent: :presentation_version) do |f|
  f.content_blob { Factory(:min_content_blob, original_filename: 'test.pdf', content_type: 'application/pdf',
                             asset_version: version, asset_type: parent.class.name) }
end

Factory.define(:presentation_with_specified_project, parent: :ppt_presentation) do |f|
  f.projects { [Factory(:project, title: 'Specified Project')] }
  f.with_project_contributor
  f.title 'Pres With Specified Project'
end
