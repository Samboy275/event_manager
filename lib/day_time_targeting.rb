require 'csv'
require 'erb'
require 'time'

def get_time_and_days()
  attendees = CSV.open("../event_attendees.csv", headers:true, header_converters: :symbol)
  time_and_days = {:hours => {}, :days => {}}
  attendees.each do |attendee|
    time = Time.strptime(attendee[:regdate], "%m/%d/%y %k:%M")
    if time_and_days[:hours].key?(time.strftime('%k'))
      time_and_days[:hours][time.strftime('%k')] += 1
    else
      time_and_days[:hours][time.strftime('%k')] = 1
    end
    if time_and_days[:days].key?(time.strftime('%A'))
      time_and_days[:days][time.strftime('%A')] += 1
    else
      time_and_days[:days][time.strftime('%A')] = 1
    end
  end
  time_and_days
end


time_targets = get_time_and_days()
puts time_targets[:hours].sort_by(&:last).reverse
puts time_targets[:days].sort_by(&:last).reverse
