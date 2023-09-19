require 'csv'
require 'erb'
require 'time'

def get_time_and_days()
  attendees = CSV.open("../event_attendees.csv", headers:true, header_converters: :symbol)
  times = attendees.map do |attendee|
    time = Time.strptime(attendee[:regdate], "%m/%d/%y %k:%M")
    time
  end
  times
end

def format_hours_ranges(times)
  time_of_day = {
    'from 00:00 to 6:00' => 0,
    'from 6:00 to 12:00' => 0,
    'from 12:00 to 18:00' => 0,
    'from 18:00 to 00:00' => 0
  }
  times.each do |time|
    if time.hour.between?(6,12)
      time_of_day['from 6:00 to 12:00'] += 1
    elsif  time.hour.between?(12,18)
      time_of_day['from 12:00 to 18:00'] += 1
    elsif time.hour.between?(18,24)
      time_of_day['from 18:00 to 00:00'] += 1
    else
      time_of_day['from 00:00 to 6:00'] += 1
    end
  end
  time_of_day.sort_by{|k,v| -v}.to_h
end

def format_hours_individually(times)
  hours = {}
  times.each do |time|
    hours[time.hour.to_s] = 0 unless hours.key?(time.hour.to_s)
    hours[time.hour.to_s] += 1
  end
  hours.sort_by {|k,v| -v}.to_h
end

def format_days(times)
  days_hash = {}
  times.each do |time|
    day_name = time.strftime("%A")
    if days_hash.key?(day_name)
      days_hash[day_name] += 1
    else
      days_hash[day_name] = 1
    end
  end
  days_hash.sort_by{|k,v| -v}.to_h
end

def output_to_template(hours_ranges, days, individual_hours)
  template_file = File.read('../templates/time_report_template.erb')
  erb_template = ERB.new template_file
  output = erb_template.result(binding)
  Dir.mkdir '../reports' unless Dir.exists? '../reports'
  File.open('../reports/time_report.html', 'w'){|file| file.write(output)}
end

times = get_time_and_days()

days = format_days(times)

hours_ranges = format_hours_ranges(times)

individual_hours = format_hours_individually(times)

output_to_template(hours_ranges, days, individual_hours)
