require 'journey'
require 'oystercard'


describe Journey do
    subject(:journey) { described_class.new }
        min = Oystercard::MIN_BALANCE
        amount = 10
        fare = 6

    let(:station) { double :station, zone: 1}
    let(:entry_station) { double :station}
    let(:exit_station) { double :station }
    let(:journey) {Journey.new(entry_station)}
    

    it "knows if journey is not complete" do
        expect(journey).not_to be_complete
    end 

    it 'has a penalty fare by default' do
        expect(journey.fare).to eq Journey::PENALTY_FARE
    end
    
    it 'returns itself when exiting a journey' do
        expect(journey.finish(exit_station)).to eq({entry_station: entry_station, exit_station: exit_station})
    end

    context 'given an entry station' do

        it 'has an entry station' do
            journey.start(station)
            expect(journey.entry_station).to eq station
        end

        it "returns a penalty fare if no exit station is given" do
            expect(subject.fare).to eq Journey::PENALTY_FARE
        end

        context 'given an exit station' do
      
            before do
              journey.start(entry_station)
              journey.finish(exit_station)
            end
      
            it 'calculates a fare' do
              expect(journey.fare).to eq 1
            end
      
            it "knows if a journey is complete" do
              expect(journey).to be_complete
            end
          end
    end
end
