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

def format_hours(times)

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
  days_hash
end

def output_to_template(hours, days)
  template_file = File.read('../templates/time_report_template.erb')
  erb_template = ERB.new template_file
  output = erb_template.result(binding)
  Dir.mkdir '../user_data' unless Dir.exists? '../user_data'
  File.open('../user_data/time_report.html', 'w'){|file| file.write(output)}
end

times = get_time_and_days()

puts format_days(times)

