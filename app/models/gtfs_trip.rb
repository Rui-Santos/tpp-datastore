# == Schema Information
#
# Table name: gtfs_trips
#
#  id                    :integer          not null, primary key
#  service_id            :string
#  trip_id               :string           not null
#  trip_headsign         :string
#  trip_short_name       :string
#  direction_id          :integer
#  block_id              :string
#  wheelchair_accessible :integer
#  bikes_allowed         :integer
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  feed_version_id       :integer          not null
#  entity_id             :integer
#  route_id              :integer
#  shape_id              :integer
#
# Indexes
#
#  index_gtfs_trips_on_entity_id        (entity_id)
#  index_gtfs_trips_on_feed_version_id  (feed_version_id)
#  index_gtfs_trips_on_route_id         (route_id)
#  index_gtfs_trips_on_shape_id         (shape_id)
#  index_gtfs_trips_on_trip_headsign    (trip_headsign)
#  index_gtfs_trips_on_trip_id          (trip_id)
#  index_gtfs_trips_on_trip_short_name  (trip_short_name)
#  index_gtfs_trips_unique              (feed_version_id,trip_id) UNIQUE
#

class GTFSTrip < ActiveRecord::Base
  belongs_to :feed_version
  belongs_to :entity, class_name: 'RouteStopPattern'
end
