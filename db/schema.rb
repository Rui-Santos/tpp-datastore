# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20180113021001) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "postgis"
  enable_extension "hstore"

  create_table "change_payloads", force: :cascade do |t|
    t.json     "payload"
    t.integer  "changeset_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "change_payloads", ["changeset_id"], name: "index_change_payloads_on_changeset_id", using: :btree

  create_table "changesets", force: :cascade do |t|
    t.text     "notes"
    t.boolean  "applied"
    t.datetime "applied_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "feed_id"
    t.integer  "feed_version_id"
  end

  add_index "changesets", ["feed_id"], name: "index_changesets_on_feed_id", using: :btree
  add_index "changesets", ["feed_version_id"], name: "index_changesets_on_feed_version_id", using: :btree
  add_index "changesets", ["user_id"], name: "index_changesets_on_user_id", using: :btree

  create_table "current_feeds", force: :cascade do |t|
    t.string    "onestop_id"
    t.string    "url"
    t.string    "feed_format"
    t.hstore    "tags"
    t.datetime  "last_fetched_at"
    t.datetime  "last_imported_at"
    t.string    "license_name"
    t.string    "license_url"
    t.string    "license_use_without_attribution"
    t.string    "license_create_derived_product"
    t.string    "license_redistribute"
    t.integer   "version"
    t.datetime  "created_at"
    t.datetime  "updated_at"
    t.integer   "created_or_updated_in_changeset_id"
    t.geography "geometry",                           limit: {:srid=>4326, :type=>"geometry", :geographic=>true}
    t.text      "license_attribution_text"
    t.integer   "active_feed_version_id"
    t.string    "edited_attributes",                                                                              default: [], array: true
    t.string    "name"
  end

  add_index "current_feeds", ["active_feed_version_id"], name: "index_current_feeds_on_active_feed_version_id", using: :btree
  add_index "current_feeds", ["created_or_updated_in_changeset_id"], name: "index_current_feeds_on_created_or_updated_in_changeset_id", using: :btree
  add_index "current_feeds", ["geometry"], name: "index_current_feeds_on_geometry", using: :gist
  add_index "current_feeds", ["onestop_id"], name: "index_current_feeds_on_onestop_id", unique: true, using: :btree

  create_table "current_operators", force: :cascade do |t|
    t.string    "name"
    t.hstore    "tags"
    t.datetime  "created_at"
    t.datetime  "updated_at"
    t.string    "onestop_id"
    t.geography "geometry",                           limit: {:srid=>4326, :type=>"geometry", :geographic=>true}
    t.integer   "created_or_updated_in_changeset_id"
    t.integer   "version"
    t.string    "timezone"
    t.string    "short_name"
    t.string    "website"
    t.string    "country"
    t.string    "state"
    t.string    "metro"
    t.string    "edited_attributes",                                                                              default: [], array: true
  end

  add_index "current_operators", ["created_or_updated_in_changeset_id"], name: "#c_operators_cu_in_changeset_id_index", using: :btree
  add_index "current_operators", ["geometry"], name: "index_current_operators_on_geometry", using: :gist
  add_index "current_operators", ["onestop_id"], name: "index_current_operators_on_onestop_id", unique: true, using: :btree
  add_index "current_operators", ["tags"], name: "index_current_operators_on_tags", using: :btree
  add_index "current_operators", ["updated_at"], name: "index_current_operators_on_updated_at", using: :btree

  create_table "current_operators_in_feed", force: :cascade do |t|
    t.string   "gtfs_agency_id"
    t.integer  "version"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "operator_id"
    t.integer  "feed_id"
    t.integer  "created_or_updated_in_changeset_id"
  end

  add_index "current_operators_in_feed", ["created_or_updated_in_changeset_id"], name: "current_oif", using: :btree
  add_index "current_operators_in_feed", ["feed_id"], name: "index_current_operators_in_feed_on_feed_id", using: :btree
  add_index "current_operators_in_feed", ["operator_id"], name: "index_current_operators_in_feed_on_operator_id", using: :btree

  create_table "current_operators_serving_stop", force: :cascade do |t|
    t.integer  "stop_id",                            null: false
    t.integer  "operator_id",                        null: false
    t.hstore   "tags"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "created_or_updated_in_changeset_id"
    t.integer  "version"
  end

  add_index "current_operators_serving_stop", ["created_or_updated_in_changeset_id"], name: "#c_operators_serving_stop_cu_in_changeset_id_index", using: :btree
  add_index "current_operators_serving_stop", ["operator_id"], name: "index_current_operators_serving_stop_on_operator_id", using: :btree
  add_index "current_operators_serving_stop", ["stop_id", "operator_id"], name: "index_current_operators_serving_stop_on_stop_id_and_operator_id", unique: true, using: :btree

  create_table "current_route_stop_patterns", force: :cascade do |t|
    t.string    "onestop_id"
    t.geography "geometry",                           limit: {:srid=>4326, :type=>"geometry", :geographic=>true}
    t.hstore    "tags"
    t.string    "stop_pattern",                                                                                   default: [],              array: true
    t.integer   "version"
    t.datetime  "created_at",                                                                                                  null: false
    t.datetime  "updated_at",                                                                                                  null: false
    t.integer   "created_or_updated_in_changeset_id"
    t.integer   "route_id"
    t.float     "stop_distances",                                                                                 default: [],              array: true
    t.string    "edited_attributes",                                                                              default: [],              array: true
    t.string    "geometry_source"
  end

  add_index "current_route_stop_patterns", ["created_or_updated_in_changeset_id"], name: "c_rsp_cu_in_changeset", using: :btree
  add_index "current_route_stop_patterns", ["onestop_id"], name: "index_current_route_stop_patterns_on_onestop_id", unique: true, using: :btree
  add_index "current_route_stop_patterns", ["route_id"], name: "index_current_route_stop_patterns_on_route_id", using: :btree
  add_index "current_route_stop_patterns", ["stop_pattern"], name: "index_current_route_stop_patterns_on_stop_pattern", using: :gin

  create_table "current_routes", force: :cascade do |t|
    t.string    "onestop_id"
    t.string    "name"
    t.hstore    "tags"
    t.integer   "operator_id"
    t.integer   "created_or_updated_in_changeset_id"
    t.integer   "version"
    t.datetime  "created_at"
    t.datetime  "updated_at"
    t.geography "geometry",                           limit: {:srid=>4326, :type=>"geometry", :geographic=>true}
    t.integer   "vehicle_type"
    t.string    "color"
    t.string    "edited_attributes",                                                                              default: [],        array: true
    t.string    "wheelchair_accessible",                                                                          default: "unknown"
    t.string    "bikes_allowed",                                                                                  default: "unknown"
  end

  add_index "current_routes", ["bikes_allowed"], name: "index_current_routes_on_bikes_allowed", using: :btree
  add_index "current_routes", ["created_or_updated_in_changeset_id"], name: "c_route_cu_in_changeset", using: :btree
  add_index "current_routes", ["geometry"], name: "index_current_routes_on_geometry", using: :gist
  add_index "current_routes", ["onestop_id"], name: "index_current_routes_on_onestop_id", unique: true, using: :btree
  add_index "current_routes", ["operator_id"], name: "index_current_routes_on_operator_id", using: :btree
  add_index "current_routes", ["tags"], name: "index_current_routes_on_tags", using: :btree
  add_index "current_routes", ["updated_at"], name: "index_current_routes_on_updated_at", using: :btree
  add_index "current_routes", ["vehicle_type"], name: "index_current_routes_on_vehicle_type", using: :btree
  add_index "current_routes", ["wheelchair_accessible"], name: "index_current_routes_on_wheelchair_accessible", using: :btree

  create_table "current_routes_serving_stop", force: :cascade do |t|
    t.integer  "route_id"
    t.integer  "stop_id"
    t.hstore   "tags"
    t.integer  "created_or_updated_in_changeset_id"
    t.integer  "version"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "current_routes_serving_stop", ["created_or_updated_in_changeset_id"], name: "c_rss_cu_in_changeset", using: :btree
  add_index "current_routes_serving_stop", ["route_id"], name: "index_current_routes_serving_stop_on_route_id", using: :btree
  add_index "current_routes_serving_stop", ["stop_id"], name: "index_current_routes_serving_stop_on_stop_id", using: :btree

  create_table "current_schedule_stop_pairs", id: :bigserial, force: :cascade do |t|
    t.integer  "origin_id"
    t.integer  "destination_id"
    t.integer  "route_id"
    t.string   "trip"
    t.integer  "created_or_updated_in_changeset_id"
    t.integer  "version"
    t.string   "trip_headsign"
    t.string   "origin_arrival_time"
    t.string   "origin_departure_time"
    t.string   "destination_arrival_time"
    t.string   "destination_departure_time"
    t.string   "frequency_start_time"
    t.string   "frequency_end_time"
    t.hstore   "tags"
    t.date     "service_start_date"
    t.date     "service_end_date"
    t.date     "service_added_dates",                default: [],              array: true
    t.date     "service_except_dates",               default: [],              array: true
    t.boolean  "service_days_of_week",               default: [],              array: true
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.string   "block_id"
    t.string   "trip_short_name"
    t.float    "shape_dist_traveled"
    t.string   "origin_timezone"
    t.string   "destination_timezone"
    t.string   "window_start"
    t.string   "window_end"
    t.string   "origin_timepoint_source"
    t.string   "destination_timepoint_source"
    t.integer  "operator_id"
    t.boolean  "wheelchair_accessible"
    t.boolean  "bikes_allowed"
    t.string   "pickup_type"
    t.string   "drop_off_type"
    t.integer  "route_stop_pattern_id"
    t.float    "origin_dist_traveled"
    t.float    "destination_dist_traveled"
    t.integer  "feed_id"
    t.integer  "feed_version_id"
    t.string   "frequency_type"
    t.integer  "frequency_headway_seconds"
  end

  add_index "current_schedule_stop_pairs", ["created_or_updated_in_changeset_id"], name: "c_ssp_cu_in_changeset", using: :btree
  add_index "current_schedule_stop_pairs", ["destination_id"], name: "c_ssp_destination", using: :btree
  add_index "current_schedule_stop_pairs", ["feed_id", "id"], name: "index_current_schedule_stop_pairs_on_feed_id_and_id", using: :btree
  add_index "current_schedule_stop_pairs", ["feed_version_id", "id"], name: "index_current_schedule_stop_pairs_on_feed_version_id_and_id", using: :btree
  add_index "current_schedule_stop_pairs", ["frequency_type"], name: "index_current_schedule_stop_pairs_on_frequency_type", using: :btree
  add_index "current_schedule_stop_pairs", ["operator_id", "id"], name: "index_current_schedule_stop_pairs_on_operator_id_and_id", using: :btree
  add_index "current_schedule_stop_pairs", ["origin_departure_time"], name: "index_current_schedule_stop_pairs_on_origin_departure_time", using: :btree
  add_index "current_schedule_stop_pairs", ["origin_id"], name: "c_ssp_origin", using: :btree
  add_index "current_schedule_stop_pairs", ["route_id"], name: "c_ssp_route", using: :btree
  add_index "current_schedule_stop_pairs", ["route_stop_pattern_id"], name: "index_current_schedule_stop_pairs_on_route_stop_pattern_id", using: :btree
  add_index "current_schedule_stop_pairs", ["service_end_date"], name: "c_ssp_service_end_date", using: :btree
  add_index "current_schedule_stop_pairs", ["service_start_date"], name: "c_ssp_service_start_date", using: :btree
  add_index "current_schedule_stop_pairs", ["trip"], name: "c_ssp_trip", using: :btree
  add_index "current_schedule_stop_pairs", ["updated_at"], name: "index_current_schedule_stop_pairs_on_updated_at", using: :btree

  create_table "current_stop_transfers", force: :cascade do |t|
    t.string   "transfer_type"
    t.integer  "min_transfer_time"
    t.hstore   "tags"
    t.integer  "stop_id"
    t.integer  "to_stop_id"
    t.integer  "created_or_updated_in_changeset_id"
    t.integer  "version"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "current_stop_transfers", ["created_or_updated_in_changeset_id"], name: "index_current_stop_transfers_changeset_id", using: :btree
  add_index "current_stop_transfers", ["min_transfer_time"], name: "index_current_stop_transfers_on_min_transfer_time", using: :btree
  add_index "current_stop_transfers", ["stop_id"], name: "index_current_stop_transfers_on_stop_id", using: :btree
  add_index "current_stop_transfers", ["to_stop_id"], name: "index_current_stop_transfers_on_to_stop_id", using: :btree
  add_index "current_stop_transfers", ["transfer_type"], name: "index_current_stop_transfers_on_transfer_type", using: :btree

  create_table "current_stops", force: :cascade do |t|
    t.string    "onestop_id"
    t.geography "geometry",                           limit: {:srid=>4326, :type=>"geometry", :geographic=>true}
    t.hstore    "tags"
    t.datetime  "created_at"
    t.datetime  "updated_at"
    t.string    "name"
    t.integer   "created_or_updated_in_changeset_id"
    t.integer   "version"
    t.string    "timezone"
    t.datetime  "last_conflated_at"
    t.string    "type"
    t.integer   "parent_stop_id"
    t.integer   "osm_way_id"
    t.string    "edited_attributes",                                                                              default: [], array: true
    t.boolean   "wheelchair_boarding"
    t.integer   "directionality"
    t.geography "geometry_reversegeo",                limit: {:srid=>4326, :type=>"st_point", :geographic=>true}
  end

  add_index "current_stops", ["created_or_updated_in_changeset_id"], name: "#c_stops_cu_in_changeset_id_index", using: :btree
  add_index "current_stops", ["geometry"], name: "index_current_stops_on_geometry", using: :gist
  add_index "current_stops", ["geometry_reversegeo"], name: "index_current_stops_on_geometry_reversegeo", using: :gist
  add_index "current_stops", ["onestop_id"], name: "index_current_stops_on_onestop_id", unique: true, using: :btree
  add_index "current_stops", ["parent_stop_id"], name: "index_current_stops_on_parent_stop_id", using: :btree
  add_index "current_stops", ["tags"], name: "index_current_stops_on_tags", using: :btree
  add_index "current_stops", ["updated_at"], name: "index_current_stops_on_updated_at", using: :btree
  add_index "current_stops", ["wheelchair_boarding"], name: "index_current_stops_on_wheelchair_boarding", using: :btree

  create_table "entities_imported_from_feed", force: :cascade do |t|
    t.integer  "entity_id"
    t.string   "entity_type"
    t.integer  "feed_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "feed_version_id"
    t.string   "gtfs_id"
  end

  add_index "entities_imported_from_feed", ["entity_type", "entity_id"], name: "index_entities_imported_from_feed_on_entity_type_and_entity_id", using: :btree
  add_index "entities_imported_from_feed", ["feed_id"], name: "index_entities_imported_from_feed_on_feed_id", using: :btree
  add_index "entities_imported_from_feed", ["feed_version_id"], name: "index_entities_imported_from_feed_on_feed_version_id", using: :btree

  create_table "entities_with_issues", force: :cascade do |t|
    t.integer  "entity_id"
    t.string   "entity_type"
    t.string   "entity_attribute"
    t.integer  "issue_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "entities_with_issues", ["entity_type", "entity_id"], name: "index_entities_with_issues_on_entity_type_and_entity_id", using: :btree

  create_table "feed_schedule_imports", force: :cascade do |t|
    t.boolean  "success"
    t.text     "import_log"
    t.text     "exception_log"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "feed_version_import_id"
  end

  add_index "feed_schedule_imports", ["feed_version_import_id"], name: "index_feed_schedule_imports_on_feed_version_import_id", using: :btree

  create_table "feed_version_imports", force: :cascade do |t|
    t.integer  "feed_version_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "success"
    t.text     "import_log"
    t.text     "exception_log"
    t.text     "validation_report"
    t.integer  "import_level"
    t.json     "operators_in_feed"
  end

  add_index "feed_version_imports", ["feed_version_id"], name: "index_feed_version_imports_on_feed_version_id", using: :btree

  create_table "feed_version_infos", force: :cascade do |t|
    t.string   "type"
    t.json     "data"
    t.integer  "feed_version_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "feed_version_infos", ["feed_version_id", "type"], name: "index_feed_version_infos_on_feed_version_id_and_type", unique: true, using: :btree
  add_index "feed_version_infos", ["feed_version_id"], name: "index_feed_version_infos_on_feed_version_id", using: :btree

  create_table "feed_versions", force: :cascade do |t|
    t.integer  "feed_id"
    t.string   "feed_type"
    t.string   "file"
    t.date     "earliest_calendar_date"
    t.date     "latest_calendar_date"
    t.string   "sha1"
    t.string   "md5"
    t.hstore   "tags"
    t.datetime "fetched_at"
    t.datetime "imported_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "import_level",           default: 0
    t.string   "url"
    t.string   "file_raw"
    t.string   "sha1_raw"
    t.string   "md5_raw"
    t.string   "file_feedvalidator"
  end

  add_index "feed_versions", ["earliest_calendar_date"], name: "index_feed_versions_on_earliest_calendar_date", using: :btree
  add_index "feed_versions", ["feed_type", "feed_id"], name: "index_feed_versions_on_feed_type_and_feed_id", using: :btree
  add_index "feed_versions", ["latest_calendar_date"], name: "index_feed_versions_on_latest_calendar_date", using: :btree

  create_table "gtfs_agencies", force: :cascade do |t|
    t.string   "agency_id",       null: false
    t.string   "agency_name"
    t.string   "agency_url"
    t.string   "agency_timezone"
    t.string   "agency_lang"
    t.string   "agency_phone"
    t.string   "agency_fare_url"
    t.string   "agency_email"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "feed_version_id", null: false
    t.integer  "entity_id"
  end

  add_index "gtfs_agencies", ["agency_id"], name: "index_gtfs_agencies_on_agency_id", using: :btree
  add_index "gtfs_agencies", ["agency_name"], name: "index_gtfs_agencies_on_agency_name", using: :btree
  add_index "gtfs_agencies", ["entity_id"], name: "index_gtfs_agencies_on_entity_id", using: :btree
  add_index "gtfs_agencies", ["feed_version_id", "agency_id"], name: "index_gtfs_agencies_unique", unique: true, using: :btree
  add_index "gtfs_agencies", ["feed_version_id"], name: "index_gtfs_agencies_on_feed_version_id", using: :btree

  create_table "gtfs_calendar_dates", force: :cascade do |t|
    t.string   "service_id",      null: false
    t.date     "date",            null: false
    t.integer  "exception_type"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "feed_version_id", null: false
  end

  add_index "gtfs_calendar_dates", ["date"], name: "index_gtfs_calendar_dates_on_date", using: :btree
  add_index "gtfs_calendar_dates", ["exception_type"], name: "index_gtfs_calendar_dates_on_exception_type", using: :btree
  add_index "gtfs_calendar_dates", ["feed_version_id", "service_id", "date"], name: "index_gtfs_calendar_dates_unique", unique: true, using: :btree
  add_index "gtfs_calendar_dates", ["feed_version_id"], name: "index_gtfs_calendar_dates_on_feed_version_id", using: :btree
  add_index "gtfs_calendar_dates", ["service_id"], name: "index_gtfs_calendar_dates_on_service_id", using: :btree

  create_table "gtfs_calendars", force: :cascade do |t|
    t.string   "service_id",      null: false
    t.boolean  "monday"
    t.boolean  "tuesday"
    t.boolean  "wednesday"
    t.boolean  "thursday"
    t.boolean  "friday"
    t.boolean  "saturday"
    t.boolean  "sunday"
    t.date     "start_date"
    t.date     "end_date"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "feed_version_id", null: false
  end

  add_index "gtfs_calendars", ["end_date"], name: "index_gtfs_calendars_on_end_date", using: :btree
  add_index "gtfs_calendars", ["feed_version_id", "service_id"], name: "index_gtfs_calendars_on_feed_version_id_and_service_id", unique: true, using: :btree
  add_index "gtfs_calendars", ["feed_version_id"], name: "index_gtfs_calendars_on_feed_version_id", using: :btree
  add_index "gtfs_calendars", ["friday"], name: "index_gtfs_calendars_on_friday", using: :btree
  add_index "gtfs_calendars", ["monday"], name: "index_gtfs_calendars_on_monday", using: :btree
  add_index "gtfs_calendars", ["saturday"], name: "index_gtfs_calendars_on_saturday", using: :btree
  add_index "gtfs_calendars", ["service_id"], name: "index_gtfs_calendars_on_service_id", using: :btree
  add_index "gtfs_calendars", ["start_date"], name: "index_gtfs_calendars_on_start_date", using: :btree
  add_index "gtfs_calendars", ["sunday"], name: "index_gtfs_calendars_on_sunday", using: :btree
  add_index "gtfs_calendars", ["thursday"], name: "index_gtfs_calendars_on_thursday", using: :btree
  add_index "gtfs_calendars", ["tuesday"], name: "index_gtfs_calendars_on_tuesday", using: :btree
  add_index "gtfs_calendars", ["wednesday"], name: "index_gtfs_calendars_on_wednesday", using: :btree

  create_table "gtfs_fare_attributes", force: :cascade do |t|
    t.string   "fare_id",           null: false
    t.float    "price"
    t.string   "currency_type"
    t.integer  "payment_method"
    t.integer  "transfers"
    t.integer  "transfer_duration"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.integer  "feed_version_id",   null: false
    t.integer  "agency_id"
  end

  add_index "gtfs_fare_attributes", ["agency_id"], name: "index_gtfs_fare_attributes_on_agency_id", using: :btree
  add_index "gtfs_fare_attributes", ["fare_id"], name: "index_gtfs_fare_attributes_on_fare_id", using: :btree
  add_index "gtfs_fare_attributes", ["feed_version_id", "fare_id"], name: "index_gtfs_fare_attributes_unique", unique: true, using: :btree
  add_index "gtfs_fare_attributes", ["feed_version_id"], name: "index_gtfs_fare_attributes_on_feed_version_id", using: :btree

  create_table "gtfs_fare_rules", force: :cascade do |t|
    t.string   "fare_id",         null: false
    t.string   "contains_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "feed_version_id", null: false
    t.integer  "route_id"
    t.integer  "origin_id"
    t.integer  "destination_id"
  end

  add_index "gtfs_fare_rules", ["destination_id"], name: "index_gtfs_fare_rules_on_destination_id", using: :btree
  add_index "gtfs_fare_rules", ["fare_id"], name: "index_gtfs_fare_rules_on_fare_id", using: :btree
  add_index "gtfs_fare_rules", ["feed_version_id"], name: "index_gtfs_fare_rules_on_feed_version_id", using: :btree
  add_index "gtfs_fare_rules", ["origin_id"], name: "index_gtfs_fare_rules_on_origin_id", using: :btree
  add_index "gtfs_fare_rules", ["route_id"], name: "index_gtfs_fare_rules_on_route_id", using: :btree

  create_table "gtfs_feed_infos", force: :cascade do |t|
    t.string   "feed_publisher_name"
    t.string   "feed_publisher_url"
    t.string   "feed_lang"
    t.date     "feed_start_date"
    t.date     "feed_end_date"
    t.string   "feed_version_name"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.integer  "feed_version_id",     null: false
  end

  add_index "gtfs_feed_infos", ["feed_version_id"], name: "index_gtfs_feed_info_unique", unique: true, using: :btree

  create_table "gtfs_frequencies", force: :cascade do |t|
    t.integer  "start_time"
    t.integer  "end_time"
    t.integer  "headway_secs"
    t.integer  "exact_times"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "feed_version_id", null: false
    t.integer  "trip_id"
  end

  add_index "gtfs_frequencies", ["end_time"], name: "index_gtfs_frequencies_on_end_time", using: :btree
  add_index "gtfs_frequencies", ["feed_version_id"], name: "index_gtfs_frequencies_on_feed_version_id", using: :btree
  add_index "gtfs_frequencies", ["headway_secs"], name: "index_gtfs_frequencies_on_headway_secs", using: :btree
  add_index "gtfs_frequencies", ["start_time"], name: "index_gtfs_frequencies_on_start_time", using: :btree
  add_index "gtfs_frequencies", ["trip_id"], name: "index_gtfs_frequencies_on_trip_id", using: :btree

  create_table "gtfs_routes", force: :cascade do |t|
    t.string   "route_id",         null: false
    t.string   "route_short_name"
    t.string   "route_long_name"
    t.string   "route_desc"
    t.integer  "route_type"
    t.string   "route_url"
    t.string   "route_color"
    t.string   "route_text_color"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.integer  "feed_version_id",  null: false
    t.integer  "entity_id"
    t.integer  "agency_id"
  end

  add_index "gtfs_routes", ["agency_id"], name: "index_gtfs_routes_on_agency_id", using: :btree
  add_index "gtfs_routes", ["entity_id"], name: "index_gtfs_routes_on_entity_id", using: :btree
  add_index "gtfs_routes", ["feed_version_id", "route_id"], name: "index_gtfs_routes_unique", unique: true, using: :btree
  add_index "gtfs_routes", ["feed_version_id"], name: "index_gtfs_routes_on_feed_version_id", using: :btree
  add_index "gtfs_routes", ["route_desc"], name: "index_gtfs_routes_on_route_desc", using: :btree
  add_index "gtfs_routes", ["route_id"], name: "index_gtfs_routes_on_route_id", using: :btree
  add_index "gtfs_routes", ["route_long_name"], name: "index_gtfs_routes_on_route_long_name", using: :btree
  add_index "gtfs_routes", ["route_short_name"], name: "index_gtfs_routes_on_route_short_name", using: :btree
  add_index "gtfs_routes", ["route_type"], name: "index_gtfs_routes_on_route_type", using: :btree

  create_table "gtfs_shapes", force: :cascade do |t|
    t.string    "shape_id",                                                                                     null: false
    t.geography "geometry",        limit: {:srid=>4326, :type=>"line_string", :has_m=>true, :geographic=>true}
    t.datetime  "created_at",                                                                                   null: false
    t.datetime  "updated_at",                                                                                   null: false
    t.integer   "feed_version_id",                                                                              null: false
  end

  add_index "gtfs_shapes", ["feed_version_id", "shape_id"], name: "index_gtfs_shapes_unique", unique: true, using: :btree
  add_index "gtfs_shapes", ["feed_version_id"], name: "index_gtfs_shapes_on_feed_version_id", using: :btree
  add_index "gtfs_shapes", ["shape_id"], name: "index_gtfs_shapes_on_shape_id", using: :btree

  create_table "gtfs_stop_times", id: :bigserial, force: :cascade do |t|
    t.integer  "stop_sequence",            null: false
    t.string   "stop_headsign"
    t.integer  "pickup_type"
    t.integer  "drop_off_type"
    t.float    "shape_dist_traveled"
    t.integer  "timepoint"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.integer  "feed_version_id",          null: false
    t.integer  "trip_id",                  null: false
    t.integer  "origin_id"
    t.integer  "destination_id"
    t.integer  "origin_departure_time"
    t.integer  "destination_arrival_time"
  end

  add_index "gtfs_stop_times", ["destination_id"], name: "index_gtfs_stop_times_on_destination_id", using: :btree
  add_index "gtfs_stop_times", ["feed_version_id", "trip_id", "stop_sequence"], name: "index_gtfs_stop_times_unique", unique: true, using: :btree
  add_index "gtfs_stop_times", ["feed_version_id"], name: "index_gtfs_stop_times_on_feed_version_id", using: :btree
  add_index "gtfs_stop_times", ["origin_id"], name: "index_gtfs_stop_times_on_origin_id", using: :btree
  add_index "gtfs_stop_times", ["stop_headsign"], name: "index_gtfs_stop_times_on_stop_headsign", using: :btree
  add_index "gtfs_stop_times", ["stop_sequence"], name: "index_gtfs_stop_times_on_stop_sequence", using: :btree
  add_index "gtfs_stop_times", ["trip_id"], name: "index_gtfs_stop_times_on_trip_id", using: :btree

  create_table "gtfs_stops", force: :cascade do |t|
    t.string   "stop_id",                                                   null: false
    t.string   "stop_code"
    t.string   "stop_name"
    t.string   "stop_desc"
    t.string   "zone_id"
    t.string   "stop_url"
    t.integer  "location_type"
    t.string   "stop_timezone"
    t.integer  "wheelchair_boarding"
    t.geometry "geometry",            limit: {:srid=>0, :type=>"st_point"}
    t.datetime "created_at",                                                null: false
    t.datetime "updated_at",                                                null: false
    t.integer  "feed_version_id",                                           null: false
    t.integer  "entity_id"
    t.integer  "parent_station_id"
  end

  add_index "gtfs_stops", ["entity_id"], name: "index_gtfs_stops_on_entity_id", using: :btree
  add_index "gtfs_stops", ["feed_version_id", "stop_id"], name: "index_gtfs_stops_unique", unique: true, using: :btree
  add_index "gtfs_stops", ["feed_version_id"], name: "index_gtfs_stops_on_feed_version_id", using: :btree
  add_index "gtfs_stops", ["geometry"], name: "index_gtfs_stops_on_geometry", using: :btree
  add_index "gtfs_stops", ["location_type"], name: "index_gtfs_stops_on_location_type", using: :btree
  add_index "gtfs_stops", ["parent_station_id"], name: "index_gtfs_stops_on_parent_station_id", using: :btree
  add_index "gtfs_stops", ["stop_code"], name: "index_gtfs_stops_on_stop_code", using: :btree
  add_index "gtfs_stops", ["stop_desc"], name: "index_gtfs_stops_on_stop_desc", using: :btree
  add_index "gtfs_stops", ["stop_id"], name: "index_gtfs_stops_on_stop_id", using: :btree
  add_index "gtfs_stops", ["stop_name"], name: "index_gtfs_stops_on_stop_name", using: :btree

  create_table "gtfs_transfers", force: :cascade do |t|
    t.integer  "transfer_type"
    t.integer  "min_transfer_time"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.integer  "feed_version_id",   null: false
    t.integer  "from_stop_id"
    t.integer  "to_stop_id"
  end

  add_index "gtfs_transfers", ["feed_version_id"], name: "index_gtfs_transfers_on_feed_version_id", using: :btree
  add_index "gtfs_transfers", ["from_stop_id"], name: "index_gtfs_transfers_on_from_stop_id", using: :btree
  add_index "gtfs_transfers", ["min_transfer_time"], name: "index_gtfs_transfers_on_min_transfer_time", using: :btree
  add_index "gtfs_transfers", ["to_stop_id"], name: "index_gtfs_transfers_on_to_stop_id", using: :btree
  add_index "gtfs_transfers", ["transfer_type"], name: "index_gtfs_transfers_on_transfer_type", using: :btree

  create_table "gtfs_trips", force: :cascade do |t|
    t.string   "service_id"
    t.string   "trip_id",               null: false
    t.string   "trip_headsign"
    t.string   "trip_short_name"
    t.integer  "direction_id"
    t.string   "block_id"
    t.integer  "wheelchair_accessible"
    t.integer  "bikes_allowed"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.integer  "feed_version_id",       null: false
    t.integer  "entity_id"
    t.integer  "route_id"
    t.integer  "shape_id"
  end

  add_index "gtfs_trips", ["entity_id"], name: "index_gtfs_trips_on_entity_id", using: :btree
  add_index "gtfs_trips", ["feed_version_id", "trip_id"], name: "index_gtfs_trips_unique", unique: true, using: :btree
  add_index "gtfs_trips", ["feed_version_id"], name: "index_gtfs_trips_on_feed_version_id", using: :btree
  add_index "gtfs_trips", ["route_id"], name: "index_gtfs_trips_on_route_id", using: :btree
  add_index "gtfs_trips", ["shape_id"], name: "index_gtfs_trips_on_shape_id", using: :btree
  add_index "gtfs_trips", ["trip_headsign"], name: "index_gtfs_trips_on_trip_headsign", using: :btree
  add_index "gtfs_trips", ["trip_id"], name: "index_gtfs_trips_on_trip_id", using: :btree
  add_index "gtfs_trips", ["trip_short_name"], name: "index_gtfs_trips_on_trip_short_name", using: :btree

  create_table "issues", force: :cascade do |t|
    t.integer  "created_by_changeset_id"
    t.integer  "resolved_by_changeset_id"
    t.string   "details"
    t.string   "issue_type"
    t.boolean  "open",                     default: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "old_feeds", force: :cascade do |t|
    t.string    "onestop_id"
    t.string    "url"
    t.string    "feed_format"
    t.hstore    "tags"
    t.datetime  "last_fetched_at"
    t.datetime  "last_imported_at"
    t.string    "license_name"
    t.string    "license_url"
    t.string    "license_use_without_attribution"
    t.string    "license_create_derived_product"
    t.string    "license_redistribute"
    t.integer   "version"
    t.datetime  "created_at"
    t.datetime  "updated_at"
    t.integer   "current_id"
    t.integer   "created_or_updated_in_changeset_id"
    t.integer   "destroyed_in_changeset_id"
    t.geography "geometry",                           limit: {:srid=>4326, :type=>"geometry", :geographic=>true}
    t.text      "license_attribution_text"
    t.integer   "active_feed_version_id"
    t.string    "edited_attributes",                                                                              default: [], array: true
    t.string    "action"
    t.string    "name"
  end

  add_index "old_feeds", ["active_feed_version_id"], name: "index_old_feeds_on_active_feed_version_id", using: :btree
  add_index "old_feeds", ["created_or_updated_in_changeset_id"], name: "index_old_feeds_on_created_or_updated_in_changeset_id", using: :btree
  add_index "old_feeds", ["current_id"], name: "index_old_feeds_on_current_id", using: :btree
  add_index "old_feeds", ["destroyed_in_changeset_id"], name: "index_old_feeds_on_destroyed_in_changeset_id", using: :btree
  add_index "old_feeds", ["geometry"], name: "index_old_feeds_on_geometry", using: :gist

  create_table "old_operators", force: :cascade do |t|
    t.string    "name"
    t.hstore    "tags"
    t.datetime  "created_at"
    t.datetime  "updated_at"
    t.string    "onestop_id"
    t.geography "geometry",                           limit: {:srid=>4326, :type=>"geometry", :geographic=>true}
    t.integer   "created_or_updated_in_changeset_id"
    t.integer   "destroyed_in_changeset_id"
    t.integer   "current_id"
    t.integer   "version"
    t.string    "timezone"
    t.string    "short_name"
    t.string    "website"
    t.string    "country"
    t.string    "state"
    t.string    "metro"
    t.string    "edited_attributes",                                                                              default: [], array: true
    t.string    "action"
  end

  add_index "old_operators", ["created_or_updated_in_changeset_id"], name: "o_operators_cu_in_changeset_id_index", using: :btree
  add_index "old_operators", ["current_id"], name: "index_old_operators_on_current_id", using: :btree
  add_index "old_operators", ["destroyed_in_changeset_id"], name: "operators_d_in_changeset_id_index", using: :btree
  add_index "old_operators", ["geometry"], name: "index_old_operators_on_geometry", using: :gist

  create_table "old_operators_in_feed", force: :cascade do |t|
    t.string   "gtfs_agency_id"
    t.integer  "version"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "operator_id"
    t.string   "operator_type"
    t.integer  "feed_id"
    t.string   "feed_type"
    t.integer  "current_id"
    t.integer  "created_or_updated_in_changeset_id"
    t.integer  "destroyed_in_changeset_id"
  end

  add_index "old_operators_in_feed", ["created_or_updated_in_changeset_id"], name: "old_oif", using: :btree
  add_index "old_operators_in_feed", ["current_id"], name: "index_old_operators_in_feed_on_current_id", using: :btree
  add_index "old_operators_in_feed", ["destroyed_in_changeset_id"], name: "index_old_operators_in_feed_on_destroyed_in_changeset_id", using: :btree
  add_index "old_operators_in_feed", ["feed_type", "feed_id"], name: "index_old_operators_in_feed_on_feed_type_and_feed_id", using: :btree
  add_index "old_operators_in_feed", ["operator_type", "operator_id"], name: "index_old_operators_in_feed_on_operator_type_and_operator_id", using: :btree

  create_table "old_operators_serving_stop", force: :cascade do |t|
    t.integer  "stop_id"
    t.integer  "operator_id"
    t.hstore   "tags"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "created_or_updated_in_changeset_id"
    t.integer  "destroyed_in_changeset_id"
    t.integer  "current_id"
    t.integer  "version"
    t.string   "stop_type"
    t.string   "operator_type"
  end

  add_index "old_operators_serving_stop", ["created_or_updated_in_changeset_id"], name: "o_operators_serving_stop_cu_in_changeset_id_index", using: :btree
  add_index "old_operators_serving_stop", ["current_id"], name: "index_old_operators_serving_stop_on_current_id", using: :btree
  add_index "old_operators_serving_stop", ["destroyed_in_changeset_id"], name: "operators_serving_stop_d_in_changeset_id_index", using: :btree
  add_index "old_operators_serving_stop", ["operator_type", "operator_id"], name: "operators_serving_stop_operator", using: :btree
  add_index "old_operators_serving_stop", ["stop_type", "stop_id"], name: "operators_serving_stop_stop", using: :btree

  create_table "old_route_stop_patterns", force: :cascade do |t|
    t.string    "onestop_id"
    t.geography "geometry",                           limit: {:srid=>4326, :type=>"geometry", :geographic=>true}
    t.hstore    "tags"
    t.string    "stop_pattern",                                                                                   default: [],              array: true
    t.integer   "version"
    t.datetime  "created_at",                                                                                                  null: false
    t.datetime  "updated_at",                                                                                                  null: false
    t.integer   "created_or_updated_in_changeset_id"
    t.integer   "destroyed_in_changeset_id"
    t.integer   "route_id"
    t.string    "route_type"
    t.integer   "current_id"
    t.float     "stop_distances",                                                                                 default: [],              array: true
    t.string    "edited_attributes",                                                                              default: [],              array: true
    t.string    "action"
    t.string    "geometry_source"
  end

  add_index "old_route_stop_patterns", ["created_or_updated_in_changeset_id"], name: "o_rsp_cu_in_changeset", using: :btree
  add_index "old_route_stop_patterns", ["current_id"], name: "index_old_route_stop_patterns_on_current_id", using: :btree
  add_index "old_route_stop_patterns", ["onestop_id"], name: "index_old_route_stop_patterns_on_onestop_id", using: :btree
  add_index "old_route_stop_patterns", ["route_type", "route_id"], name: "index_old_route_stop_patterns_on_route_type_and_route_id", using: :btree
  add_index "old_route_stop_patterns", ["stop_pattern"], name: "index_old_route_stop_patterns_on_stop_pattern", using: :gin

  create_table "old_routes", force: :cascade do |t|
    t.string    "onestop_id"
    t.string    "name"
    t.hstore    "tags"
    t.integer   "operator_id"
    t.string    "operator_type"
    t.integer   "created_or_updated_in_changeset_id"
    t.integer   "destroyed_in_changeset_id"
    t.integer   "current_id"
    t.integer   "version"
    t.datetime  "created_at"
    t.datetime  "updated_at"
    t.geography "geometry",                           limit: {:srid=>4326, :type=>"geometry", :geographic=>true}
    t.integer   "vehicle_type"
    t.string    "color"
    t.string    "edited_attributes",                                                                              default: [],        array: true
    t.string    "wheelchair_accessible",                                                                          default: "unknown"
    t.string    "bikes_allowed",                                                                                  default: "unknown"
    t.string    "action"
  end

  add_index "old_routes", ["bikes_allowed"], name: "index_old_routes_on_bikes_allowed", using: :btree
  add_index "old_routes", ["created_or_updated_in_changeset_id"], name: "o_route_cu_in_changeset", using: :btree
  add_index "old_routes", ["current_id"], name: "index_old_routes_on_current_id", using: :btree
  add_index "old_routes", ["destroyed_in_changeset_id"], name: "o_route_d_in_changeset", using: :btree
  add_index "old_routes", ["geometry"], name: "index_old_routes_on_geometry", using: :gist
  add_index "old_routes", ["operator_type", "operator_id"], name: "index_old_routes_on_operator_type_and_operator_id", using: :btree
  add_index "old_routes", ["vehicle_type"], name: "index_old_routes_on_vehicle_type", using: :btree
  add_index "old_routes", ["wheelchair_accessible"], name: "index_old_routes_on_wheelchair_accessible", using: :btree

  create_table "old_routes_serving_stop", force: :cascade do |t|
    t.integer  "route_id"
    t.string   "route_type"
    t.integer  "stop_id"
    t.string   "stop_type"
    t.hstore   "tags"
    t.integer  "created_or_updated_in_changeset_id"
    t.integer  "destroyed_in_changeset_id"
    t.integer  "current_id"
    t.integer  "version"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "old_routes_serving_stop", ["created_or_updated_in_changeset_id"], name: "o_rss_cu_in_changeset", using: :btree
  add_index "old_routes_serving_stop", ["current_id"], name: "index_old_routes_serving_stop_on_current_id", using: :btree
  add_index "old_routes_serving_stop", ["destroyed_in_changeset_id"], name: "o_rss_d_in_changeset", using: :btree
  add_index "old_routes_serving_stop", ["route_type", "route_id"], name: "index_old_routes_serving_stop_on_route_type_and_route_id", using: :btree
  add_index "old_routes_serving_stop", ["stop_type", "stop_id"], name: "index_old_routes_serving_stop_on_stop_type_and_stop_id", using: :btree

  create_table "old_schedule_stop_pairs", id: :bigserial, force: :cascade do |t|
    t.integer  "origin_id"
    t.string   "origin_type"
    t.integer  "destination_id"
    t.string   "destination_type"
    t.integer  "route_id"
    t.string   "route_type"
    t.string   "trip"
    t.integer  "current_id"
    t.integer  "created_or_updated_in_changeset_id"
    t.integer  "destroyed_in_changeset_id"
    t.integer  "version"
    t.string   "trip_headsign"
    t.string   "origin_arrival_time"
    t.string   "origin_departure_time"
    t.string   "destination_arrival_time"
    t.string   "destination_departure_time"
    t.string   "frequency_start_time"
    t.string   "frequency_end_time"
    t.hstore   "tags"
    t.date     "service_start_date"
    t.date     "service_end_date"
    t.date     "service_added_dates",                default: [],              array: true
    t.date     "service_except_dates",               default: [],              array: true
    t.boolean  "service_days_of_week",               default: [],              array: true
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.string   "block_id"
    t.string   "trip_short_name"
    t.float    "shape_dist_traveled"
    t.string   "origin_timezone"
    t.string   "destination_timezone"
    t.string   "window_start"
    t.string   "window_end"
    t.string   "origin_timepoint_source"
    t.string   "destination_timepoint_source"
    t.integer  "operator_id"
    t.boolean  "wheelchair_accessible"
    t.boolean  "bikes_allowed"
    t.string   "pickup_type"
    t.string   "drop_off_type"
    t.integer  "route_stop_pattern_id"
    t.float    "origin_dist_traveled"
    t.float    "destination_dist_traveled"
    t.integer  "feed_id"
    t.integer  "feed_version_id"
    t.string   "frequency_type"
    t.integer  "frequency_headway_seconds"
  end

  add_index "old_schedule_stop_pairs", ["created_or_updated_in_changeset_id"], name: "o_ssp_cu_in_changeset", using: :btree
  add_index "old_schedule_stop_pairs", ["current_id"], name: "index_old_schedule_stop_pairs_on_current_id", using: :btree
  add_index "old_schedule_stop_pairs", ["destination_type", "destination_id"], name: "o_ssp_destination", using: :btree
  add_index "old_schedule_stop_pairs", ["destroyed_in_changeset_id"], name: "o_ssp_d_in_changeset", using: :btree
  add_index "old_schedule_stop_pairs", ["feed_id"], name: "index_old_schedule_stop_pairs_on_feed_id", using: :btree
  add_index "old_schedule_stop_pairs", ["feed_version_id"], name: "index_old_schedule_stop_pairs_on_feed_version_id", using: :btree
  add_index "old_schedule_stop_pairs", ["frequency_type"], name: "index_old_schedule_stop_pairs_on_frequency_type", using: :btree
  add_index "old_schedule_stop_pairs", ["operator_id"], name: "index_old_schedule_stop_pairs_on_operator_id", using: :btree
  add_index "old_schedule_stop_pairs", ["origin_type", "origin_id"], name: "o_ssp_origin", using: :btree
  add_index "old_schedule_stop_pairs", ["route_stop_pattern_id"], name: "index_old_schedule_stop_pairs_on_route_stop_pattern_id", using: :btree
  add_index "old_schedule_stop_pairs", ["route_type", "route_id"], name: "o_ssp_route", using: :btree
  add_index "old_schedule_stop_pairs", ["service_end_date"], name: "o_ssp_service_end_date", using: :btree
  add_index "old_schedule_stop_pairs", ["service_start_date"], name: "o_ssp_service_start_date", using: :btree
  add_index "old_schedule_stop_pairs", ["trip"], name: "o_ssp_trip", using: :btree

  create_table "old_stop_transfers", force: :cascade do |t|
    t.string   "transfer_type"
    t.integer  "min_transfer_time"
    t.hstore   "tags"
    t.integer  "stop_id"
    t.integer  "to_stop_id"
    t.integer  "created_or_updated_in_changeset_id"
    t.integer  "version"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "destroyed_in_changeset_id"
    t.integer  "current_id"
  end

  add_index "old_stop_transfers", ["created_or_updated_in_changeset_id"], name: "index_old_stop_transfers_changeset_id", using: :btree
  add_index "old_stop_transfers", ["current_id"], name: "index_old_stop_transfers_on_current_id", using: :btree
  add_index "old_stop_transfers", ["destroyed_in_changeset_id"], name: "index_old_stop_transfers_on_destroyed_in_changeset_id", using: :btree
  add_index "old_stop_transfers", ["min_transfer_time"], name: "index_old_stop_transfers_on_min_transfer_time", using: :btree
  add_index "old_stop_transfers", ["stop_id"], name: "index_old_stop_transfers_on_stop_id", using: :btree
  add_index "old_stop_transfers", ["to_stop_id"], name: "index_old_stop_transfers_on_to_stop_id", using: :btree
  add_index "old_stop_transfers", ["transfer_type"], name: "index_old_stop_transfers_on_transfer_type", using: :btree

  create_table "old_stops", force: :cascade do |t|
    t.string    "onestop_id"
    t.geography "geometry",                           limit: {:srid=>4326, :type=>"geometry", :geographic=>true}
    t.hstore    "tags"
    t.datetime  "created_at"
    t.datetime  "updated_at"
    t.string    "name"
    t.integer   "created_or_updated_in_changeset_id"
    t.integer   "destroyed_in_changeset_id"
    t.integer   "current_id"
    t.integer   "version"
    t.string    "timezone"
    t.datetime  "last_conflated_at"
    t.string    "type"
    t.integer   "parent_stop_id"
    t.integer   "osm_way_id"
    t.string    "edited_attributes",                                                                              default: [], array: true
    t.boolean   "wheelchair_boarding"
    t.string    "action"
    t.integer   "directionality"
    t.geography "geometry_reversegeo",                limit: {:srid=>4326, :type=>"st_point", :geographic=>true}
  end

  add_index "old_stops", ["created_or_updated_in_changeset_id"], name: "o_stops_cu_in_changeset_id_index", using: :btree
  add_index "old_stops", ["current_id"], name: "index_old_stops_on_current_id", using: :btree
  add_index "old_stops", ["destroyed_in_changeset_id"], name: "stops_d_in_changeset_id_index", using: :btree
  add_index "old_stops", ["geometry"], name: "index_old_stops_on_geometry", using: :gist
  add_index "old_stops", ["geometry_reversegeo"], name: "index_old_stops_on_geometry_reversegeo", using: :gist
  add_index "old_stops", ["parent_stop_id"], name: "index_old_stops_on_parent_stop_id", using: :btree
  add_index "old_stops", ["wheelchair_boarding"], name: "index_old_stops_on_wheelchair_boarding", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                                  null: false
    t.string   "name"
    t.string   "affiliation"
    t.string   "user_type"
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.boolean  "admin",                  default: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "change_payloads", "changesets"
end
