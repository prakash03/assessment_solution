class CustomTime
  class InvalidInputError < StandardError; end
  MINUTES_IN_A_DAY = 24 * 60
  TWELVE_HOURS = 12 * 60

  # Public - Adds a given number of Integer minutes to the input time String in `[H]H:MM {AM|PM}`` format.
  #
  # time_input - Input time String in `[H]H:MM {AM|PM}` format
  # add_minutes - A Signed Integer representing number of minutes to add
  #
  # Returns - Updated time String in `[H]H:MM {AM|PM}` format.
  def self.add_minutes(time_input:, add_minutes:)
    validate_time_input(time_input: time_input, add_minutes: add_minutes)

    net_minutes = (add_minutes >= 0) ? (add_minutes % MINUTES_IN_A_DAY) : ((add_minutes * -1) % MINUTES_IN_A_DAY)

    # When minutes to add is negative, we can add the difference in minutes instead of subtracting it.
    net_minutes = (add_minutes >= 0) ? net_minutes : MINUTES_IN_A_DAY - net_minutes

    if net_minutes >= TWELVE_HOURS
      updated_time = add_twelve_hours(time_input: time_input)
      return add_minutes(time_input: updated_time, add_minutes: net_minutes - 720)
    end

    time, session = time_input.split(' ')
    hours, minutes = time.split(':')
    hours = Integer(hours)
    minutes = Integer(minutes)

    result_minutes = minutes + (net_minutes % 60)

    carry_hours = 0
    if result_minutes >= 60
      result_minutes -= 60
      carry_hours = 1
    end

    result_hours = hours + (net_minutes/60) + carry_hours

    if session == 'PM' && result_hours >= 12
      if hours == 12
        result_hours = 12
      else
        session = 'AM'
        result_hours = result_hours -= 12
      end
    elsif session == 'AM' && result_hours >= 12
      session = 'PM'
      result_hours = (result_hours >= 13) ? (result_hours - 12) : 12
    end

    "#{sprintf '%02d', result_hours}:#{sprintf '%02d', result_minutes} #{session}"
  end

  # Private - Adds 12 hours to the given input time
  #
  # time_input - Input time String in `[H]H:MM {AM|PM}` format
  #
  # Returns -  Updated time String in `[H]H:MM {AM|PM}` format.
  private_class_method def self.add_twelve_hours(time_input:)
    time, session = time_input.split(' ')
    hours, minutes = time.split(':')
    hours = Integer(hours)
    minutes = Integer(minutes)

    hours = 0 if hours == 12 && session == 'PM'
    hours = 12 if hours == 0 && session == 'AM'

    session = (session == 'PM') ? 'AM' : 'PM'

    "#{sprintf '%02d', hours}:#{sprintf '%02d', minutes} #{session}"
  end

  # Private - Validates the input parameters and raises an error if inputs are not as expected.
  #
  # time_input - Input time String in `[H]H:MM {AM|PM}` format
  # add_minutes - A Signed Integer representing number of minutes to add
  #
  # Raises - InvalidInputError when the `time_input` doesn't have the expected `[H]H:MM {AM|PM}` format
  #          or if `add_minutes` is not an Integer.
  private_class_method def self.validate_time_input(time_input:, add_minutes:)
    begin
      Integer(add_minutes)
      time, session = time_input.split(' ')
      hours, minutes = time.split(':')
      hours = Integer(hours)
      minutes = Integer(minutes)
      return if session == 'AM' || session == 'PM'

      raise InvalidInputError, "AM/ PM must be specified for the time input #{time_input}."
    rescue ArgumentError, TypeError => exception
      raise InvalidInputError, "Invalid inputs provided. Error: #{exception.message}"
    end
  end
end
