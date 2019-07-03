#Default values required for the automated unit, functional and integration testing to behave as expected.
Seek::Config.default :is_virtualliver, false
Seek::Config.default :project_hierarchy_enabled, true
Seek::Config.default :project_name, 'Sysmo'

Seek::Config.default :noreply_sender,"no-reply@sysmo-db.org"
Seek::Config.default :support_email_address, 'support@seek.org'

Seek::Config.default :crossref_api_email, "sowen@cs.man.ac.uk"

Seek::Config.default :jws_enabled, true
Seek::Config.default :events_enabled, true
Seek::Config.default :jws_online_root, "http://jws.sysmo-db.org"
Seek::Config.default :internal_help_enabled, false
Seek::Config.default :external_help_url, "http://seek4science.github.io/seek/help"
Seek::Config.default :workflows_enabled, true

Seek::Config.default :email_enabled, true
Seek::Config.default :solr_enabled, false

Seek::Config.default :publish_button_enabled, true
Seek::Config.default :auth_lookup_enabled, false
Seek::Config.default :project_browser_enabled, true
Seek::Config.default :experimental_features_enabled, true
Seek::Config.default :filestore_path, "tmp/testing-filestore"
Seek::Config.default :tagging_enabled, true
Seek::Config.default :authorization_checks_enabled, true
Seek::Config.default :magic_guest_enabled, false
Seek::Config.default :modelling_analysis_enabled, true
Seek::Config.default :assays_enabled, true
Seek::Config.default :models_enabled, true
Seek::Config.default :show_as_external_link_enabled, false
Seek::Config.default :biosamples_enabled, true
Seek::Config.default :publications_enabled, true
Seek::Config.default :factors_studied_enabled, true
Seek::Config.default :experimental_conditions_enabled, true
Seek::Config.default :programmes_enabled, true
Seek::Config.default :programme_user_creation_enabled, true
Seek::Config.default :project_hierarchy_enabled, true
Seek::Config.default :tabs_lazy_load_enabled, false

Seek::Config.default :project_link, 'http://www.sysmo.net'
Seek::Config.default :application_name, 'Sysmo SEEK'
Seek::Config.default :dm_project_name, "SysMO-DB"
Seek::Config.default :dm_project_link, "http://www.sysmo-db.org"
Seek::Config.default :project_type, 'Consortium'
Seek::Config.default :header_image_enabled, true
Seek::Config.default :header_image_title,  "SysMO-DB"
Seek::Config.default :header_image_link, "http://www.sysmo-db.org"
Seek::Config.default :bioportal_api_key, "fish"

Seek::Config.default :technology_type_ontology_file, "file:#{Rails.root}/test/fixtures/files/JERM-test.rdf"
Seek::Config.default :modelling_analysis_type_ontology_file, "file:#{Rails.root}/test/fixtures/files/JERM-test.rdf"
Seek::Config.default :assay_type_ontology_file, "file:#{Rails.root}/test/fixtures/files/JERM-test.rdf"

Seek::Config.default :doi_minting_enabled, true
Seek::Config.default :doi_prefix, "10.5072"
Seek::Config.default :doi_suffix, "Sysmo.SEEK"
Seek::Config.default :datacite_url, "https://test.datacite.org/mds/"
Seek::Config.default :datacite_username, 'test'
Seek::Config.default :datacite_password, 'test'
Seek::Config.default :time_lock_doi_for, 0

Seek::Config.fixed :css_prepended,''
Seek::Config.fixed :css_appended,''
Seek::Config.fixed :main_layout,'application'

Seek::Config.default :faceted_browsing_enabled, false
Seek::Config.default :facet_enable_for_pages, {:people => true, :projects => false, :institutions => false, :programmes => false, :investigations => false,:studies => false, :assays => true, :data_files => true, :models => true,:sops => true, :publications => true,:events => false, :strains => false, :presentations => false}
Seek::Config.default :faceted_search_enabled,  false

Seek::Config.default :recaptcha_enabled, true

#enable solr for testing, but use mockup sunspot session
Seek::Config.default :solr_enabled, true
Sunspot.session = SunspotMatchers::SunspotSessionSpy.new(Sunspot.session)

Seek::Config.default :imprint_enabled,  false
Seek::Config.default :imprint_description,  'Here is imprint example'

Seek::Config.default :zenodo_publishing_enabled, true
Seek::Config.default :zenodo_api_url, "https://sandbox.zenodo.org/api"
Seek::Config.default :zenodo_oauth_url, "https://sandbox.zenodo.org/oauth"

Seek::Config.default :cache_remote_files, true
Seek::Config.default :max_cachable_size, 2000
Seek::Config.default :hard_max_cachable_size, 5000

Seek::Config.default :orcid_required, false
Seek::Config.default :site_base_host, "http://localhost:3000"
Seek::Config.default :session_store_timeout, 30.minutes

Seek::Config.default :default_all_visitors_access_type, Policy::NO_ACCESS
Seek::Config.default :max_all_visitors_access_type, Policy::MANAGING

Seek::Config.default :openbis_enabled, true
Seek::Config.default :openbis_debug, false
Seek::Config.default :openbis_autosync, true
Seek::Config.default :openbis_check_new_arrivals, true

Seek::Config.default :nels_enabled, true
Seek::Config.default :nels_api_url, 'https://test-fe.cbu.uib.no/nels-api'
Seek::Config.default :nels_oauth_url, 'https://test-fe.cbu.uib.no/oauth2'
Seek::Config.default :nels_permalink_base, 'https://test-fe.cbu.uib.no/nels/pages/sbi/sbi.xhtml'
Seek::Config.default :nels_use_dummy_client, false
