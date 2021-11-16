# frozen_string_literal: true

require 'csv'
require 'colorize'

require_relative 'Constant'
require_relative 'DataExtraction'
require_relative 'Stats'

class Weatherman
  include Constant
  extend DataExtraction
  extend Stats

  def initialize(switch, year, path)
    @switch = switch
    @year = year
    @path = path
  end

  def start
    case @switch
    when '-e'
      stats_for_year(@year, @path)
    when '-a'
      stats_of_month(@year, @path)
    when '-c'
      draw_bar_chart_month(@year, @path)
    when '-cc'
      draw_single_bar_chart_month(@year, @path)
    else
      puts 'Invalid switch used.'
    end
  end

  def stats_for_year(year, path)
    data = Weatherman.extract_data_for_year(year, path)

    highest_temp_day = Weatherman.get_highest_temp_day(data)
    month_day = highest_temp_day.first.split('-')
    month = MON_TO_MONTH[month_day[1]]
    day = month_day[2]
    puts "Highest: #{highest_temp_day[1]}C on #{month} #{day}"

    lowest_temp_day = Weatherman.get_lowest_temp_day(data)
    month_day = lowest_temp_day.first.split('-')
    month = MON_TO_MONTH[month_day[1]]
    day = month_day[2]
    puts "Lowest: #{lowest_temp_day[1]}C on #{month} #{day}"

    most_humid_day = Weatherman.get_highest_humidy_day(data)
    month_day = most_humid_day.first.split('-')
    month = MON_TO_MONTH[month_day[1]]
    day = month_day[2]
    puts "Humid: #{most_humid_day[1]}% on #{month} #{day}"
  rescue Exception => e
    abort e.message
  end

  def stats_of_month(year, path)
    data = Weatherman.extract_data_for_month(year, path)
    avg_max_temp = data[0].sum / data[0].length
    avg_min_temp = data[1].sum / data[1].length
    avg_humidity = data[2].sum / data[2].length
    begin
      puts "Highest Average: #{avg_max_temp}C"
      puts "Lowest Average: #{avg_min_temp}C"
      puts "Average Humidity: #{avg_humidity}%"
    rescue Exception => e
      abort e.message
    end
  end

  def draw_bar_chart_month(year_month, path)
    data = Weatherman.extract_data_for_bar_chart(year_month, path)
    month = year_month.split('/')[1]
    month = MON_TO_MONTH[month.to_sym]
    year = year_month.split('/').first
    data.each do |k, v|
      day = k.split('-')[2]
      puts "#{day} #{'+'.red * v.first.to_i.abs} #{v.first}C"
      puts "#{day} #{'-'.blue * v.last.to_i.abs} #{v[1]}C"
    end
  rescue Exception => e
    abort e.message
  end

  def draw_single_bar_chart_month(year_month, path)
    data = Weatherman.extract_data_for_bar_chart(year_month, path)
    month = year_month.split('/')[1]
    month = MON_TO_MONTH[month]
    year = year_month.split('/').first
    data.each do |k, v|
      day = k.split('-')[2]
      puts "#{day} #{'+'.blue * v.last.to_i.abs}#{'+'.red * v.first.to_i.abs} #{v.last}C-#{v.first}C"
    end
  rescue Exception => e
    abort e.message
  end
end
