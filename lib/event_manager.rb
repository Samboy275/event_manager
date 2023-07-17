require 'csv'

def clean_zipcode(zipcode)
  # cleans zipcodes and truncates 0's at the start untill it reaches a five digit number
  return zipcode.to_s.rjust(5, '0')[0..4]
end

attendee_list = CSV.open(
  '../event_attendees.csv',
  headers: true,
  header_converters: :symbol
)


attendee_list.each do |line|
  first_name = line[:first_name]
  zipcode = clean_zipcode(line[:zipcode])
  puts "#{first_name}, #{zipcode}"
end
