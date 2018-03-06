# == Schema Information
#
# Table name: gtfs_routes
#
#  id               :integer          not null, primary key
#  route_id         :string           not null
#  route_short_name :string
#  route_long_name  :string
#  route_desc       :string
#  route_type       :integer
#  route_url        :string
#  route_color      :string
#  route_text_color :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  feed_version_id  :integer          not null
#  entity_id        :integer
#  agency_id        :integer
#
# Indexes
#
#  index_gtfs_routes_on_agency_id         (agency_id)
#  index_gtfs_routes_on_entity_id         (entity_id)
#  index_gtfs_routes_on_feed_version_id   (feed_version_id)
#  index_gtfs_routes_on_route_desc        (route_desc)
#  index_gtfs_routes_on_route_id          (route_id)
#  index_gtfs_routes_on_route_long_name   (route_long_name)
#  index_gtfs_routes_on_route_short_name  (route_short_name)
#  index_gtfs_routes_on_route_type        (route_type)
#  index_gtfs_routes_unique               (feed_version_id,route_id) UNIQUE
#

class GTFSRoute < ActiveRecord::Base
  belongs_to :feed_version
  belongs_to :entity, class_name: 'Route'
end
