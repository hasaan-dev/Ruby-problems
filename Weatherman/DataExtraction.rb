# frozen_string_literal: true

require_relative 'Constant'

module DataExtraction
  include Constant

  def extract_data_for_year(year, path)
    extracted_data = {}
    city = path.split('/')[1]
    NUM_TO_MON.each_value do |month|
      CSV.foreach("#{path}/#{city}_#{year}_#{month}.txt", headers: true, skip_blanks: true) do |row|
        extracted_data[row[0]] = [row[1], row[3], row[7]]
      end
    end
    extracted_data
  end

  def extract_data_for_month(year_month, path)
    mon = year_month.split('/').last
    month = NUM_TO_MON[mon.to_sym]
    year = year_month.split('/').first
    city = path.split('/').last
    csv = CSV.read("#{path}/#{city}_#{year}_#{month}.txt",  headers: true, skip_blanks: true) 
    return csv['Max TemperatureC'].map!{|x| x.to_i}, csv['Min TemperatureC'].map!{|x| x.to_i}, csv['Mean Humidity'].map!{|x| x.to_i} 
  rescue Exception => e
    abort e.message
  end

  def extract_data_for_bar_chart(year_month, path)
    extracted_data = {}
    mon = year_month.split('/').last
    month = NUM_TO_MON[mon.to_sym]
    year = year_month.split('/').first
    city = path.split('/').last
    CSV.foreach("#{path}/#{city}_#{year}_#{month}.txt",  headers: true, skip_blanks: true) do |row|
      extracted_data[row['PKT']] = [row['Max TemperatureC'], row['Min TemperatureC']]
    end
    return extracted_data
  rescue Exception => e
    abort e.message
  end
end
