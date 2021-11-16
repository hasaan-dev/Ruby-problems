# frozen_string_literal: true

require_relative 'Weatherman'

if ARGV.length != 3
  abort 'Arguments incomplete.'
else
  puts ARGV[0], ARGV[1], ARGV[2]
  weather_man = Weatherman.new(ARGV[0], ARGV[1], ARGV[2])
  weather_man.start
end
