require 'station'
require 'oystercard'

class Journey 
    attr_accessor :entry_station, :exit_station
    MIN_CHARGE = 1
    PENALTY_FARE = 6 

    def initialize(entry_station = nil, exit_station = nil)
         @entry_station = entry_station
         @exit_station = exit_station
    end

    def start(station)
        self.entry_station = station
    end

    def finish(station)
        @exit_station = station
        {:entry_station => @entry_station, :exit_station => exit_station}
    end
    
    def complete?
        @entry_station && @exit_station
    end

    def fare
        if @exit_station != nil
            MIN_CHARGE
        else
            PENALTY_FARE
        end
    end

    def calculate_fare
        1
    end
end