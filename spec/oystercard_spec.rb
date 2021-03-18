require 'oystercard'
require 'station'
require 'journey'

describe Oystercard do 
  let(:oyster) {Oystercard.new}
  let(:touch_in) {double :touch_in}
  let(:entry_station) {double :station}
  let(:exit_station) {double :station}
  let(:journey) { {entry_station: entry_station, exit_station: exit_station} }
  
  context 'initial state of oystercard' do
    it 'has a default balance of zero' do
      expect(oyster.balance).to eq(0)
    end
  end

  context 'topping up the oystercard' do
    it { is_expected.to respond_to(:top_up).with(1).argument }
    
    it 'can top up the balance' do 
        expect{ subject.top_up 1}.to change{ subject.balance }.by 1
    end

    it 'refuses top up when max balance is reached' do
      maximum_balance = Oystercard::MAX_BALANCE
      subject.top_up(maximum_balance)
      expect{ subject.top_up 1 }.to raise_error 'Maximum balance of £90 exceeded'
    end
  end
  
  it 'will not touch in if below minimum balance' do
    expect{ subject.touch_in(entry_station) }.to raise_error "Insufficient balance to touch in"
  end

  context 'oystercard is in journey' do
    before(:each) do
      subject.top_up(1)
      subject.touch_in(entry_station)
    end

    it { is_expected.to respond_to(:touch_in).with(1).argument } 

    it 'can touch in' do
      expect(subject).to be_in_journey
    end
    

    it 'stores the entry station' do
      expect(subject.entry_station).to eq entry_station
    end

    it 'can touch out' do
      subject.touch_out(exit_station)
      expect(subject).not_to be_in_journey
    end

    it 'stores the exit station' do
      subject.touch_out(exit_station)
      expect(subject.exit_station).to eq exit_station
    end

    it 'deducts an amount from balance' do
      expect{ subject.touch_out(exit_station) }.to change{ subject.balance }.by(-Oystercard::MIN_CHARGE)
    end
    
    it 'stores a journey' do 
      subject.touch_out(exit_station)
      expect(subject.journeys).not_to be_empty
    end
  end
  
  
end
