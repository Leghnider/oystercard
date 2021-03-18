require 'station'
require 'journey'

class Oystercard

  attr_reader :balance, :in_journey, :entry_station, :exit_station

  MAX_BALANCE = 90
  MIN_BALANCE = 1
  MIN_CHARGE = 1


  def initialize
    @balance = 0
    @in_journey = false
    @journeys ||= {}
  end

  def top_up(amount)
    fail 'Maximum balance of £90 exceeded' if amount + balance > MAX_BALANCE
    @balance += amount
  end
 
  def in_journey?
    !!entry_station
  end
  
  def touch_in(station)
    @entry_station = station
    journeys.merge!(entry_station: station)
    fail "Insufficient balance to touch in" if balance < MIN_BALANCE
  end

  def touch_out(station)
    deduct(MIN_CHARGE)
    @entry_station = nil
    @exit_station = station
    journeys.merge!(exit_station: station)
  end
  
  def journeys
    @journeys
  end

  private

  def deduct(amount)
    @balance -= amount
  end
end