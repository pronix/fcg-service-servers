class FCG::SimpleDB < SimpleRecord::Base
  def to_hash
    self.serializable_hash.inject({}) do |result, (key, value)|
      case value
      when Date, DateTime, Time
        value = value.to_s
      end
      result[key] = value
      result
    end
  end

  def to_msgpack(*args)
    self.to_hash.to_msgpack(*args)
  end
end