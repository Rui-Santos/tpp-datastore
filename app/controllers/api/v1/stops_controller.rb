class Api::V1::StopsController < Api::V1::BaseApiController
  include JsonCollectionPagination

  before_action :set_stop, only: [:show]

  def index
    @stops = Stop.includes(:stop_identifiers).where('') # TODO: check performance against eager_load, joins, etc.
    if params[:identifier].present?
      @stops = @stops.joins(:stop_identifiers).where("stop_identifiers.identifier = ?", params[:identifier])
    end
    if [params[:lat], params[:lon]].map(&:present?).all?
      point = Stop::GEOFACTORY.point(params[:lon], params[:lat])
      r = params[:r] || 100 # meters TODO: move this to a more logical place
      @stops = @stops.where{st_dwithin(geometry, point, r)}.order{st_distance(geometry, point)}
    end
    if params[:bbox].present? && params[:bbox].split(',').length == 4
      bbox_coordinates = params[:bbox].split(',')
      @stops = @stops.where{geometry.op('&&', st_makeenvelope(bbox_coordinates[0], bbox_coordinates[1], bbox_coordinates[2], bbox_coordinates[3], Stop::GEOFACTORY.srid))}
    end

    respond_to do |format|
      format.json do
        render paginated_json_collection(
          @stops,
          Proc.new { |params| api_v1_stops_url(params) },
          params[:offset],
          Stop::PER_PAGE
        )
      end
      format.geojson do
        render json: stop_collection_geojson(@stops)
      end
    end
  end

  def show
    render json: @stop
  end

  private

  def set_stop
    @stop = Stop.find_by_onestop_id!(params[:id])
  end

  def stop_collection_geojson(stops)
    # TODO: paginate or serve as GeoJSON tiles, perhaps for consumption by
    # https://github.com/glenrobertson/leaflet-tilelayer-geojson
    factory = RGeo::GeoJSON::EntityFactory.instance
    features = stops.map do |stop|
      factory.feature(
        stop.geometry,
        stop.onestop_id,
        {
          name: stop.name,
          created_at: stop.created_at,
          updated_at: stop.updated_at,
          tags: stop.tags,
          identifiers: stop.stop_identifiers.map do |stop_identifier|
            {
              identifier: stop_identifier.identifier,
              tags: stop_identifier.tags,
              created_at: stop_identifier.created_at,
              updated_at: stop_identifier.updated_at
            }
          end
        }
      )
    end
    RGeo::GeoJSON.encode(factory.feature_collection(features))
  end
end
