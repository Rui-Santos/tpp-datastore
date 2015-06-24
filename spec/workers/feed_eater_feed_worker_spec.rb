require 'sidekiq/testing'
Sidekiq::Testing.fake!

describe FeedEaterFeedWorker do
  before(:each) do
    @feedids = ['f-9q9-caltrain', 'f-9q9-bayarearapidtransit']
    @feeds = @feedids.map {|feedid| Feed.new(onestop_id:feedid)}
  end

  it 'accept single onestop_id' do
    expect {
      FeedEaterFeedWorker.perform_async(@feedids.first)
    }.to change(FeedEaterFeedWorker.jobs, :size).by(1)  
    Sidekiq::Worker.clear_all    
  end
  
  it 'returns if feed matches previous hash' do
    allow(Feed).to receive(:find_by) { @feeds.first }
    allow_any_instance_of(Feed).to receive(:fetch_and_check_for_updated_version) { false }
    FeedEaterFeedWorker.perform_async(@feedids.first)
    FeedEaterFeedWorker.drain
    Sidekiq::Worker.clear_all    
  end
    
  it 'creates FeedImport record' do
    allow(Figaro.env).to receive(:transitland_feed_data_path) { 'abcd' }
    allow(Feed).to receive(:find_by) { @feeds.first }
    allow_any_instance_of(Feed).to receive(:fetch_and_check_for_updated_version) { true }
    allow_any_instance_of(Feed).to receive(:file_sha1_hash) { 'abcd1234' }
    allow_any_instance_of(FeedEaterFeedWorker).to receive(:run_python) { false }
    FeedEaterFeedWorker.perform_async(@feedids.first)
    # Check we created a FeedImport record
    expect {
      FeedEaterFeedWorker.drain
    }.to change(FeedImport, :count).by(1)
    Sidekiq::Worker.clear_all
  end

  # TODO: Additional testing
  #   failure cases
  #   log file upload
  
end
