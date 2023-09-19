require 'erb'
require  'csv'

def clean_phone(phone)
  phone.gsub!(/\D/, '')
  # good number if digits = 10 or digits = 11 and first number is 1
  if phone.length == 10 or (phone.length == 11 and phone.chars[0] == '1')
    phone = phone.chars[1..-1].join unless phone.length == 10
    phone
  else
    # bad number is digist < 10 or > 11 or = 11 and first number not 1
    "invalid number"
  end
end

def save_sms_info(attendees)
  sms_template = File.read('../templates/sms_template.erb')
  sms_erb_temp = ERB.new sms_template
  output = sms_erb_temp.result(binding)
  Dir.mkdir '../reports' unless Dir.exists? "../reports"
  File.open('../reports/phone_numbers.html', 'w'){|file| file.write(output)}
end


attendee_list = CSV.open('../event_attendees.csv',
  headers: true,
  header_converters: :symbol
)

attendees = attendee_list.map do |attendee|
  attendee_hash = {:name => '', :phone => ''}
  phone = attendee[:homephone]
  name = attendee[:first_name] + ' ' + attendee[:last_name]

  attendee_hash[:name] = name
  # filtering numbers from string
  attendee_hash[:phone] = clean_phone(phone)

  attendee_hash
end

save_sms_info(attendees)
