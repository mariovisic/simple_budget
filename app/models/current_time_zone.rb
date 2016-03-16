class CurrentTimeZone
  @@current_timezone_name = Rails.configuration.time_zone

  def self.set(timezone_string)
    timezone = Time.find_zone(timezone_string)

    if timezone.present?
      @@current_timezone_name = timezone.name
    end
  end

  def self.to_s
    @@current_timezone_name
  end

  def self.reset
    @@current_timezone_name = Rails.configuration.time_zone
  end

  def self.with_current(&blk)
    Time.use_zone(@@current_timezone_name, &blk)
  end
end
