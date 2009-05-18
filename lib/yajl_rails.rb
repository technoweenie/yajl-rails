require 'stringio'

module ActiveSupport::JSON
  ParseError = Yajl::ParseError
end
  
module YajlRails
  extend self

  # Converts a JSON string into a Ruby object.
  def decode(json)
    if !json.respond_to?(:read)
      json = StringIO.new(json)
    end
    data = ::Yajl::Stream.parse(json)
    if ActiveSupport.parse_json_times
      convert_dates_from(data)
    else
      data
    end
  end

private
  def convert_dates_from(data)
    case data
      when ActiveSupport::JSON::DATE_REGEX
        DateTime.parse(data)
      when Array
        data.map! { |d| convert_dates_from(d) }
      when Hash
        data.each do |key, value|
          data[key] = convert_dates_from(value)
        end
      else data
    end
  end
end
