require 'airport'

describe Airport do

let(:airport) { described_class.new}

  describe 'initialization' do
    it 'sets defualt capacity if no argument passed' do
      50.times {airport.instruct_landing(Plane.new)}
      expect{airport.instruct_landing(Plane.new)}.to raise_error 'Airport full'
    end
    it 'sets capacity to argument passed' do
      airport = Airport.new(30)
      30.times {airport.instruct_landing(Plane.new)}
      expect{airport.instruct_landing(Plane.new)}.to raise_error 'Airport full'
    end
  end

  describe '#instruct_takeoff' do
    it 'responds to instruct_takeoff' do
      expect(airport).to respond_to :instruct_takeoff
    end

    it 'instructs a plane to take off' do
      plane = Plane.new
      airport.instruct_landing(plane)
      expect(airport.instruct_takeoff).to eq plane
    end

    it 'instructs a plane to take off, which is then flying' do
      airport.instruct_landing(Plane.new)
      plane = airport.instruct_takeoff
      expect(plane).to be_flying
    end

    it 'raises an error when there are no planes to take off' do
      expect { airport.instruct_takeoff }.to raise_error 'No planes in airport'
    end

    it 'raises an error when plane tries to take off in story weather' do
      airport.instruct_landing(Plane.new)
      allow(airport).to receive(:stormy?) { true }
      expect { airport.instruct_takeoff }.to raise_error 'Stormy weather'
    end
  end

  describe '#instruct_landing' do
    it {is_expected.to respond_to(:instruct_landing).with(1).argument}

    it 'instructs a plane to land' do
      plane = Plane.new
      expect(airport.instruct_landing(plane)).to include plane
    end

    it 'instructs a plane to land, which is then no longer flying' do
      plane = Plane.new
      plane.take_off
      airport.instruct_landing(plane)
      expect(plane).not_to be_flying
    end

    # made attr_reader :planes private so can no longer test airport.planes
    #it 'instructs a plane to land and remembers which plane has landed' do
      #plane = Plane.new
      #airport.instruct_landing(plane)
      #expect(airport.planes).to include plane
    #end

    it 'raises an error when airport capacity is full' do
      plane = Plane.new
      airport.capacity.times {airport.instruct_landing(plane)}
      expect { airport.instruct_landing(plane) }.to raise_error 'Airport full'
    end

    it 'raises an error when plane tries to land in stormy weather' do
      allow(airport).to receive(:stormy?) { true }
      plane = Plane.new
      expect { airport.instruct_landing(plane) }.to raise_error 'Stormy weather'
    end
  end

  it 'has default capacity (if no capacity set at initialization' do
      expect(airport.capacity).to eq Airport::DEFAULT_CAPACITY
  end

  it 'changes capacity of airport' do
    airport.capacity = 52
    52.times {airport.instruct_landing(Plane.new)}
    expect{airport.instruct_landing(Plane.new)}.to raise_error 'Airport full'
  end

end