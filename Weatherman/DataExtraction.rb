# frozen_string_literal: true

require_relative 'Constant'

module DataExtraction
  include Constant

  def extract_data_for_year(year, path)
    extracted_data = {}
    city = path.split('/')[1]
    NUM_TO_MON.each_value do |month|
      line_count = 0
      CSV.foreach("#{path}/#{city}_#{year}_#{month}.txt", col_sep: ',') do |row|
        if line_count.zero?
          line_count += 1
        elsif (row.length.to_i > 1) && line_count.positive? && (row[0] && row[1] && row[3] && row[7])
          # row[0]: GST, row[1] : Max TemperatureC, row[3]: Min TemperatureC, row[7]: Max Humidity
          ext_str = "#{row[1]},#{row[3]},#{row[7]}"
          extracted_data[row[0]] = ext_str.split(',')
          line_count += 1
        end
      rescue Exception => e
        puts e.message
        next
      end
    end
    extracted_data
  end

  def extract_data_for_month(year_month, path)
    month = nil
    year = nil
    city = nil
    avg_max_temp = nil
    avg_min_temp = nil
    avg_humidity = nil
    begin
      month = year_month.split('/')[1]
      month = NUM_TO_MON[month.to_sym]
      year = year_month.split('/')[0]
    rescue Exception
      abort 'Argument Missing: Check year and month.'
    end
    city = path.split('/')[1]
    max_temp = []
    min_temp = []
    mean_humidity = []

    begin
      line_count = 0
      CSV.foreach("#{path}/#{city}_#{year}_#{month}.txt", col_sep: ',') do |row|
        if line_count.zero?
          line_count += 1
        elsif (row.length > 1) && line_count.positive?
          # row[0]: GST, row[1] : Max TemperatureC, row[3]: Min TemperatureC, row[8]: Mean Humidity
          if row[1] || row[3] || row[8]
            max_temp.append(row[1].to_i)
            min_temp.append(row[3].to_i)
            mean_humidity.append(row[8].to_i)
          end
          line_count += 1
        end
      end
      return max_temp, min_temp, mean_humidity
    rescue Exception => e
      abort e.message
    end
  end

  def extract_data_for_bar_chart(year_month, path)
    month = nil
    year = nil
    begin
      month = year_month.split('/')[1]
      month = NUM_TO_MON[month.to_sym]
      year = year_month.split('/')[0]
      city = path.split('/')[1]
      extracted_data = {}

      line_count = 0
      CSV.foreach("#{path}/#{city}_#{year}_#{month}.txt", col_sep: ',') do |row|
        if line_count.zero?
          line_count += 1
        else
          # row[0]: GST, row[1] : Max TemperatureC, row[3]: Min TemperatureC
          if (row.length > 1) && line_count > 1 && (row[1] && row[3])
            ext_str = "#{row[1]},#{row[3]}"
            extracted_data[row[0]] = ext_str.split(',')
          end
          line_count += 1
        end
      end
      extracted_data
    rescue SystemCallError
      abort 'Data Not Found!'
    rescue Exception
      abort 'Invalid Arguments.'
    end
  end
end
