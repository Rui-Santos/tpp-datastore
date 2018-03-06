# == Schema Information
#
# Table name: gtfs_calendars
#
#  id              :integer          not null, primary key
#  service_id      :string           not null
#  monday          :boolean
#  tuesday         :boolean
#  wednesday       :boolean
#  thursday        :boolean
#  friday          :boolean
#  saturday        :boolean
#  sunday          :boolean
#  start_date      :date
#  end_date        :date
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  feed_version_id :integer          not null
#
# Indexes
#
#  index_gtfs_calendars_on_end_date                        (end_date)
#  index_gtfs_calendars_on_feed_version_id                 (feed_version_id)
#  index_gtfs_calendars_on_feed_version_id_and_service_id  (feed_version_id,service_id) UNIQUE
#  index_gtfs_calendars_on_friday                          (friday)
#  index_gtfs_calendars_on_monday                          (monday)
#  index_gtfs_calendars_on_saturday                        (saturday)
#  index_gtfs_calendars_on_service_id                      (service_id)
#  index_gtfs_calendars_on_start_date                      (start_date)
#  index_gtfs_calendars_on_sunday                          (sunday)
#  index_gtfs_calendars_on_thursday                        (thursday)
#  index_gtfs_calendars_on_tuesday                         (tuesday)
#  index_gtfs_calendars_on_wednesday                       (wednesday)
#

class GTFSCalendar < ActiveRecord::Base
  belongs_to :feed_version
end
