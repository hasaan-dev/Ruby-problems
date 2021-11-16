# frozen_string_literal: true

module Stats
  def get_highest_temp_day(data)
    output = [nil, -999_999]
    data.each do |k, v|
      if v[0].to_i >= output[1].to_i
        output[0] = k
        output[1] = v[0]
      end
    end
    output
  end

  def get_lowest_temp_day(data)
    output = [nil, 999_999]
    data.each do |k, v|
      if v[1].to_i <= output[1].to_i
        output[0] = k
        output[1] = v[0]
      end
    end
    output
  end

  def get_highest_humidy_day(data)
    output = [nil, -999_999]
    data.each do |k, v|
      if v[2].to_i >= output[1].to_i
        output[0] = k
        output[1] = v[0]
      end
    end
    output
  end
end
