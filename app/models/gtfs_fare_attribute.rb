# == Schema Information
#
# Table name: gtfs_fare_attributes
#
#  id                :integer          not null, primary key
#  fare_id           :string           not null
#  price             :float
#  currency_type     :string
#  payment_method    :integer
#  transfers         :integer
#  transfer_duration :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  feed_version_id   :integer          not null
#  agency_id         :integer
#
# Indexes
#
#  index_gtfs_fare_attributes_on_agency_id        (agency_id)
#  index_gtfs_fare_attributes_on_fare_id          (fare_id)
#  index_gtfs_fare_attributes_on_feed_version_id  (feed_version_id)
#  index_gtfs_fare_attributes_unique              (feed_version_id,fare_id) UNIQUE
#

class GTFSFareAttribute < ActiveRecord::Base
  belongs_to :feed_version
end
