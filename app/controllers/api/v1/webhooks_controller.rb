class Api::V1::WebhooksController < Api::V1::BaseApiController
  before_filter :require_api_auth_token

  def feed_fetcher
    if params[:feed_onestop_id].present?
      feed_onestop_ids = params[:feed_onestop_id].split(',')
      feeds = Feed.find_by_onestop_ids!(params[:feed_onestop_ids])
    else
      feeds = Feed.where('')
    end
    workers = [
      FeedFetcherService.fetch_these_feeds_async(feeds)
    ]
    if workers
      render json: {
        code: 200,
        message: "FeedFetcherWorkers #{workers.join(', ')} enqueued.",
        errors: []
      }
    else
      raise 'FeedFetcherWorkers could not be created or enqueued.'
    end
  end

  def feed_eater
    feed = Feed.find_by_onestop_id!(params[:feed_onestop_id])
    feed_version_sha1 = params[:feed_version_sha1]
    if feed_version_sha1.present?
      feed_version = feed.feed_versions.find_by(sha1: feed_version_sha1)
    else
      feed_version = feed.feed_versions.first!
    end
    import_level = params[:import_level].present? ? params[:import_level].to_i : 0
    feed_eater_worker = FeedEaterWorker.perform_async(feed.onestop_id, feed_version.sha1, import_level)
    if feed_eater_worker
      render json: {
        code: 200,
        message: "FeedEaterWorker ##{feed_eater_worker} has been enqueued.",
        errors: []
      }
    else
      raise 'FeedEaterWorker could not be created or enqueued.'
    end
  end

end
