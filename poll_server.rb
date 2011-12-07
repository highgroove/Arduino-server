require 'serialport'
require 'pry'
require 'net/http'
require 'json'

class Arduino
  # Params for serial port
  PORT      = "/dev/tty.usbmodemfa131"
  DATA_BITS = 8
  STOP_BITS = 1
  BAUD_RATE = 9600
  PARITY    = SerialPort::NONE
  
  def initialize
    @sp = SerialPort.new(PORT, BAUD_RATE, DATA_BITS, STOP_BITS, PARITY)
  end
  
  def write_to_pin(number, high = true)
    @sp.write(("A".ord + number - 1).chr + (high ? ?1 : ?0 ) + "\r\n")
  end
  
  def led_on
    write_to_pin(13, true)
  end
  
  def led_off
    write_to_pin(13, false)
  end
end

arduino = Arduino.new

uri = URI.parse("http://ec2-50-19-60-252.compute-1.amazonaws.com/query.json")

current_state = {:led => false}
while true do
  response = Net::HTTP.get_response(uri)
  result   = JSON.parse(response.body)
  
  if result && result["led"] != current_state[:led]
    current_state[:led] = result["led"]
    puts "Change detected! LED is now #{current_state[:led] ? "on" : "off"}"
    
    current_state[:led] ? arduino.led_on : arduino.led_off
  end
  
  sleep 2
end
