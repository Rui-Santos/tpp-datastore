# == Schema Information
#
# Table name: gtfs_feed_infos
#
#  id                  :integer          not null, primary key
#  feed_publisher_name :string
#  feed_publisher_url  :string
#  feed_lang           :string
#  feed_start_date     :date
#  feed_end_date       :date
#  feed_version_name   :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  feed_version_id     :integer          not null
#
# Indexes
#
#  index_gtfs_feed_info_unique  (feed_version_id) UNIQUE
#

class GTFSFeedInfo < ActiveRecord::Base
  belongs_to :feed_version
end
