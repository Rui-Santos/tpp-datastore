describe Api::V1::RoutesController do
  before(:each) do
    @richmond_millbrae_route = create(
      :route,
      name: 'Richmond - Daly City/Millbrae',
      onestop_id: 'r-9q8y-richmond~dalycity~millbrae',
      geometry: {
        coordinates: [
          [[-122.353165,37.936887],[-122.317269,37.925655],[-122.2992715,37.9030588],[-122.283451,37.87404],[-122.268045,37.869867],[-122.26978,37.853024],[-122.267227,37.828415],[-122.269029,37.80787],[-122.271604,37.803664],[-122.2945822,37.80467476],[-122.396742,37.792976],[-122.401407,37.789256],[-122.406857,37.784991],[-122.413756,37.779528],[-122.419694,37.765062],[-122.418466,37.752254],[-122.434092,37.732921],[-122.4474142,37.72198087],[-122.4690807,37.70612055],[-122.466233,37.684638],[-122.444116,37.664174],[-122.416038,37.637753],[-122.38666,37.599787]],
          [[-122.4690807,37.70612055],[-122.4474142,37.72198087],[-122.434092,37.732921],[-122.418466,37.752254],[-122.419694,37.765062],[-122.413756,37.779528],[-122.406857,37.784991],[-122.401407,37.789256],[-122.396742,37.792976],[-122.2945822,37.80467476],[-122.271604,37.803664],[-122.269029,37.80787],[-122.267227,37.828415],[-122.26978,37.853024],[-122.268045,37.869867],[-122.283451,37.87404],[-122.2992715,37.9030588],[-122.317269,37.925655],[-122.353165,37.936887]]
        ],
        type: 'MultiLineString'
      }
    )
  end

  describe 'GET index' do
    context 'as JSON' do
      it 'returns all current routes when no parameters provided' do
        get :index
        expect_json_types({ routes: :array }) # TODO: remove root node?
        expect_json({ routes: -> (routes) {
          expect(routes.length).to eq 1
        }})
      end

      it 'returns route within a bounding box' do
        get :index, bbox: '-122.4228858947754,37.59043119366754,-122.34460830688478,37.62374937200642'
        expect_json({ routes: -> (routes) {
          expect(routes.first[:onestop_id]).to eq 'r-9q8y-richmond~dalycity~millbrae'
        }})
      end

      it 'returns no routes when none in bounding box' do
        get :index, bbox: '-122.25783348083498,37.61280361684656,-122.17955589294435,37.64611177340781'
        expect_json({ routes: -> (routes) {
          expect(routes.length).to eq 0
        }})
      end
    end
  end

  describe 'GET show' do
    it 'returns stops by OnestopID' do
      get :show, id: 'r-9q8y-richmond~dalycity~millbrae'
      expect_json_types({
        onestop_id: :string,
        geometry: :object,
        name: :string,
        created_at: :date,
        updated_at: :date
      })
      expect_json({ onestop_id: -> (onestop_id) {
        expect(onestop_id).to eq 'r-9q8y-richmond~dalycity~millbrae'
      }})
    end

    it 'returns a 404 when not found' do
      get :show, id: 'ntd9015-2053'
      expect(response.status).to eq 404
    end
  end
end