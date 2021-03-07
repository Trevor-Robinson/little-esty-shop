require 'holidays'

class NagerService

  def upcoming_holidays
    get_data('https://date.nager.at/Api/v2/NextPublicHolidays/us')
  end

  def get_data(url)
    response = Faraday.get(url)
    data = response.body
    JSON.parse(data, symbolize_names: true)
  end

  def holiday_list
    upcoming_holidays[0..2].map do |holiday|
      Holiday.new(holiday)
    end
  end

end
