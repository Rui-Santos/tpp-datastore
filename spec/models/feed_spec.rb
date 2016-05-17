# == Schema Information
#
# Table name: current_feeds
#
#  id                                 :integer          not null, primary key
#  onestop_id                         :string
#  url                                :string
#  feed_format                        :string
#  tags                               :hstore
#  last_fetched_at                    :datetime
#  last_imported_at                   :datetime
#  license_name                       :string
#  license_url                        :string
#  license_use_without_attribution    :string
#  license_create_derived_product     :string
#  license_redistribute               :string
#  version                            :integer
#  created_at                         :datetime
#  updated_at                         :datetime
#  created_or_updated_in_changeset_id :integer
#  geometry                           :geography({:srid geometry, 4326
#  latest_fetch_exception_log         :text
#  license_attribution_text           :text
#  active_feed_version_id             :integer
#
# Indexes
#
#  index_current_feeds_on_active_feed_version_id              (active_feed_version_id)
#  index_current_feeds_on_created_or_updated_in_changeset_id  (created_or_updated_in_changeset_id)
#  index_current_feeds_on_geometry                            (geometry)
#

require 'sidekiq/testing'

describe Feed do
  context 'changesets' do
    before(:each) do
      @changeset1 = create(:changeset, payload: {
        changes: [
          {
            action: 'createUpdate',
            operator: {
              onestopId: 'o-9q9-caltrain',
              name: 'Caltrain',
              identifiedBy: ['usntd://9134'],
              geometry: { type: "Polygon", coordinates:[[[-121.56649700000001,37.00360599999999],[-122.23195700000001,37.48541199999998],[-122.38653400000001,37.600005999999965],[-122.412018,37.63110599999998],[-122.39432299999996,37.77643899999997],[-121.65072100000002,37.12908099999998],[-121.61080899999999,37.085774999999984],[-121.56649700000001,37.00360599999999]]]}
            }
          },
          {
            action: 'createUpdate',
            feed: {
              onestopId: 'f-9q9-caltrain',
              url: 'http://www.caltrain.com/Assets/GTFS/caltrain/GTFS-Caltrain-Devs.zip',
              licenseUrl: 'http://www.caltrain.com/developer/Developer_License_Agreement_and_Privacy_Policy.html',
              licenseUseWithoutAttribution: 'yes',
              licenseCreateDerivedProduct: 'yes',
              licenseRedistribute: 'yes',
              includesOperators: [
                {
                  operatorOnestopId: 'o-9q9-caltrain',
                  gtfsAgencyId: 'caltrain-ca-us'
                }
              ]
            }
          }
        ]
      })
    end

    it 'can create a feed' do
      @changeset1.apply!
      expect(Operator.first.name).to eq "Caltrain"
      expect(Feed.first.url).to eq 'http://www.caltrain.com/Assets/GTFS/caltrain/GTFS-Caltrain-Devs.zip'
      expect(Feed.first.operators).to match_array([Operator.first])
      expect(@changeset1.feeds_created_or_updated).to match_array([Feed.first])
    end

    it 'can modify a feed, modifying model attributes' do
      changeset2 = create(:changeset, payload: {
        changes: [
          {
            action: 'createUpdate',
            feed: {
              onestopId: 'f-9q9-caltrain',
              licenseRedistribute: 'no'
            }
          }
        ]
      })
      @changeset1.apply!
      changeset2.apply!
      expect(Feed.first.operators).to match_array([Operator.first])
      expect(Feed.first.license_redistribute).to eq 'no'
      expect(changeset2.feeds_created_or_updated).to match_array([Feed.first])
    end

    it 'can modify a feed, modifying a GTFS agency ID' do
      changeset2 = create(:changeset, payload: {
        changes: [
          {
            action: 'createUpdate',
            feed: {
              onestopId: 'f-9q9-caltrain',
              includesOperators: [
                {
                  operatorOnestopId: 'o-9q9-caltrain',
                  gtfsAgencyId: 'new-id'
                }
              ]
            }
          }
        ]
      })
      @changeset1.apply!
      changeset2.apply!
      expect(Feed.first.operators).to match_array([Operator.first])
      expect(Feed.first.operators_in_feed.first.gtfs_agency_id).to eq 'new-id'
      expect(changeset2.feeds_created_or_updated).to match_array([Feed.first])
    end

    it 'can modify a feed, adding another operator' do
      changeset2 = create(:changeset, payload: {
        changes: [
          {
            action: 'createUpdate',
            operator: {
              onestopId: 'o-9q9-caltrain~dbtn',
              name: 'Caltrain Dumbarton',
              geometry: { type: "Polygon", coordinates:[[[-121.56649700000001,37.00360599999999],[-122.23195700000001,37.48541199999998],[-122.38653400000001,37.600005999999965],[-122.412018,37.63110599999998],[-122.39432299999996,37.77643899999997],[-121.65072100000002,37.12908099999998],[-121.61080899999999,37.085774999999984],[-121.56649700000001,37.00360599999999]]]}
            }
          },
          {
            action: 'createUpdate',
            feed: {
              onestopId: 'f-9q9-caltrain',
              includesOperators: [
                {
                  operatorOnestopId: 'o-9q9-caltrain~dbtn',
                  gtfsAgencyId: 'dumbarton'
                }
              ]
            }
          }
        ]
      })
      @changeset1.apply!
      changeset2.apply!
      expect(Feed.first.operators).to match_array([Operator.first, Operator.last])
      expect(Feed.first.operators_in_feed.map(&:gtfs_agency_id)).to match_array(['caltrain-ca-us', 'dumbarton'])
    end

    it 'can modify a feed, removing an operator relationship' do
      changeset2 = create(:changeset, payload: {
        changes: [
          {
            action: 'createUpdate',
            feed: {
              onestopId: 'f-9q9-caltrain',
              doesNotIncludeOperators: [
                {
                  operatorOnestopId: 'o-9q9-caltrain'
                }
              ]
            }
          }
        ]
      })
      @changeset1.apply!
      changeset2.apply!
      expect(Feed.first.operators).to match_array([])
      expect(Operator.first.feeds).to match_array([])
      expect(changeset2.operators_in_feed_destroyed).to match_array([OldOperatorInFeed.last])
    end

    it 'can delete a feed' do
      changeset2 = create(:changeset, payload: {
        changes: [
          {
            action: 'destroy',
            feed: {
              onestopId: 'f-9q9-caltrain'
            }
          }
        ]
      })
      @changeset1.apply!
      changeset2.apply!
      expect(Feed.count).to eq 0
      expect(Operator.count).to eq 1
      expect(OldFeed.count).to eq 1
      expect(OldFeed.first.old_operators_in_feed.first.operator).to eq Operator.first
      # TODO: figure out why this isn't working: expect(OldFeed.first.operators.first).to eq Operator.first
    end
  end

  context 'fetch_and_return_feed_version' do
    it 'creates a feed version the first time a file is downloaded' do
      feed = create(:feed_caltrain)
      expect(feed.feed_versions.count).to eq 0
      VCR.use_cassette('feed_fetch_caltrain') do
        feed.fetch_and_return_feed_version
      end
      expect(feed.feed_versions.count).to eq 1
    end

    it "does not create a duplicate, if remote file hasn't changed since last download" do
      feed = create(:feed_caltrain)
      VCR.use_cassette('feed_fetch_caltrain') do
        @feed_version1 = feed.fetch_and_return_feed_version
      end
      expect(feed.feed_versions.count).to eq 1
      VCR.use_cassette('feed_fetch_caltrain') do
        @feed_version2 = feed.fetch_and_return_feed_version
      end
      expect(feed.feed_versions.count).to eq 1
      expect(@feed_version1).to eq @feed_version2
    end

    it 'logs fetch errors' do
      feed = create(:feed_caltrain, url: 'http://httpbin.org/status/404')
      expect(feed.feed_versions.count).to eq 0
      VCR.use_cassette('feed_fetch_404') do
        feed.fetch_and_return_feed_version
      end
      expect(feed.feed_versions.count).to eq 0
      expect(feed.latest_fetch_exception_log).to be_present
      expect(feed.latest_fetch_exception_log).to include('404')
    end
  end

  context '#async_fetch_feed_version' do
    it 'enqueues FeedFetcher job' do
      # Fix rspec/sidekiq/reddis unique problems
      # Sidekiq::Testing.fake! do
      #   feed = create(:feed_caltrain)
      #   expect {
      #     feed.async_fetch_feed_version
      #   }.to change(FeedFetcherWorker.jobs, :size).by(1)
      #   FeedFetcherWorker.jobs.clear
      # end
    end
    it 'can auto-enqueue FeedFetcher job in after_create callback' do
      # Fix rspec/sidekiq/reddis unique problems
      # allow(Figaro.env).to receive(:auto_fetch_feed_version) { 'true' }
      # Sidekiq::Testing.fake! do
      #   expect {
      #     feed = create(:feed_caltrain)
      #   }.to change(FeedFetcherWorker.jobs, :size).by(1)
      #   FeedFetcherWorker.jobs.clear
      # end
    end
  end

  it 'gets a bounding box around all its stops' do
    feed = build(:feed)
    stops = []
    stops << build(:stop, geometry: "POINT (-121.902181 37.329392)")
    stops << build(:stop, geometry: "POINT (-122.030742 37.378427)")
    stops << build(:stop, geometry: "POINT (-122.076327 37.393879)")
    stops << build(:stop, geometry: "POINT (-122.1649 37.44307)")
    feed.set_bounding_box_from_stops(stops)
    expect(feed.geometry(as: :geojson)).to eq({
      type: "Polygon",
      coordinates: [
        [
          [-122.1649, 37.329392],
          [-121.902181, 37.329392],
          [-121.902181, 37.44307],
          [-122.1649, 37.44307],
          [-122.1649, 37.329392]
        ]
      ]
    })
  end

  context 'import status' do
    it 'handles never imported' do
      feed = create(:feed)
      expect(feed.import_status).to eq :never_imported
    end

    it 'handles most recent failed' do
      feed = create(:feed)
      create(:feed_version_import, feed: feed, success: true)
      create(:feed_version_import, feed: feed, success: false)
      expect(feed.import_status).to eq :most_recent_failed
    end

    it 'handles most recent succeeded' do
      feed = create(:feed)
      create(:feed_version_import, feed: feed, success: false)
      create(:feed_version_import, feed: feed, success: true)
      expect(feed.import_status).to eq :most_recent_succeeded
    end

    it 'handles in progress' do
      feed = create(:feed)
      create(:feed_version_import, feed: feed, success: true)
      create(:feed_version_import, feed: feed, success: false)
      create(:feed_version_import, feed: feed, success: nil)
      expect(feed.import_status).to eq :in_progress
    end
  end

  context 'active feed version' do
    it 'sets the active feed version' do
      feed = create(:feed)
      fv = create(:feed_version, feed: feed)
      expect(feed.active_feed_version).to be nil
      feed.activate_feed_version(fv.sha1, 1)
      expect(feed.active_feed_version).to eq(fv)
    end

    it 'sets the active feed version and deactivates previous feed version' do
      feed = create(:feed)
      fv1 = create(:feed_version, feed: feed)
      feed.activate_feed_version(fv1.sha1, 1)
      expect(feed.active_feed_version).to eq(fv1)
      fv2 = create(:feed_version, feed: feed)
      feed.activate_feed_version(fv2.sha1, 1)
      expect(feed.active_feed_version).to eq(fv2)
    end
  end

  context '.where_active_feed_version_import_level' do
    it 'finds active feed version with import_level' do
      fv1 = create(:feed_version, import_level: 2)
      feed1 = fv1.feed
      feed1.update!(active_feed_version: fv1)
      fv2 = create(:feed_version, import_level: 4)
      feed2 = fv2.feed
      feed2.update!(active_feed_version: fv2)
      expect(Feed.where_active_feed_version_import_level(0)).to match_array([])
      expect(Feed.where_active_feed_version_import_level(2)).to match_array([feed1])
      expect(Feed.where_active_feed_version_import_level(4)).to match_array([feed2])
    end
  end

  context '.where_active_feed_version_valid' do
    before(:each) do
      date0 = Date.parse('2014-01-01')
      date1 = Date.parse('2015-01-01')
      date2 = Date.parse('2016-01-01')
      feed = create(:feed)
      fv1 = create(:feed_version, feed: feed, earliest_calendar_date: date0, latest_calendar_date: date1)
      fv2 = create(:feed_version, feed: feed, earliest_calendar_date: date1, latest_calendar_date: date2)
      feed.update(active_feed_version: fv2)
    end

    it 'finds valid active_feed_version' do
      expect(Feed.where_active_feed_version_valid('2015-06-01').count).to eq(1)
    end

    it 'expired active_feed_version' do
      expect(Feed.where_active_feed_version_valid('2016-06-01').count).to eq(0)
    end

    it 'active_feed_version that has not started' do
      expect(Feed.where_active_feed_version_valid('2014-06-01').count).to eq(0)
    end
  end

  context '.where_newer_feed_version' do
    before(:each) do
      date0 = Date.parse('2014-01-01')
      date1 = Date.parse('2015-01-01')
      date2 = Date.parse('2016-01-01')
      # 3 feed versions, 2 newer
      @feed0 = create(:feed)
      fv0 = create(:feed_version, feed: @feed0, created_at: date0)
      fv1 = create(:feed_version, feed: @feed0, created_at: date1)
      fv2 = create(:feed_version, feed: @feed0, created_at: date2)
      @feed0.update!(active_feed_version: fv0)
      # 3 feed versions, 1 newer, 1 older
      @feed1 = create(:feed)
      fv3 = create(:feed_version, feed: @feed1, created_at: date0)
      fv4 = create(:feed_version, feed: @feed1, created_at: date1)
      fv5 = create(:feed_version, feed: @feed1, created_at: date2)
      @feed1.update!(active_feed_version: fv4)
      # 3 feed versions, 2 newer
      @feed2 = create(:feed)
      fv6 = create(:feed_version, feed: @feed2, created_at: date0)
      fv7 = create(:feed_version, feed: @feed2, created_at: date1)
      fv8 = create(:feed_version, feed: @feed2, created_at: date2)
      @feed2.update!(active_feed_version: fv8)
      # 1 feed version, current
      @feed3 = create(:feed)
      fv9 = create(:feed_version, feed: @feed3, created_at: date0)
      @feed3.update!(active_feed_version: fv9)
    end

    it 'finds superseded feeds' do
      expect(Feed.where_active_feed_version_update).to match_array([@feed0, @feed1])
    end
  end

end
