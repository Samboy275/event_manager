require 'csv'
require 'google/apis/civicinfo_v2'

def clean_zipcode(zipcode)
  # cleans zipcodes and truncates 0's at the start untill it reaches a five digit number
  return zipcode.to_s.rjust(5, '0')[0..4]
end


def display_legislators_by_zipcode(zipcode)
  # initlizing google civi_info client
  civi_info = Google::Apis::CivicinfoV2::CivicInfoService.new
  civi_info.key = 'AIzaSyClRzDqDh5MsXwnCWi0kOiiBivP6JsSyBw'

  # gets a string of legislators if zip code was given correctly
  begin
    # getting a response object with legislators
    legislators = civi_info.representative_info_by_address(
      address: zipcode,
      levels: 'country',
      roles: ['legislatorUpperBody', 'legislatorLowerBody']
    )

    # parsing names from response object
    legislators = legislators.officials

    legislators_names = legislators.map(&:name)

    legislator_string = legislators_names.join(', ')
  rescue
    'You can find your representatives by visiting www.commoncause.org/take-action/find-elected-officials'
  end

  legislator_string

end


puts "event manager initilized"




attendee_list = CSV.open(
  '../event_attendees.csv',
  headers: true,
  header_converters: :symbol
)


attendee_list.each do |line|
  first_name = line[:first_name]
  zipcode = clean_zipcode(line[:zipcode])

  puts "#{first_name}, #{zipcode}, #{display_legislators_by_zipcode(zipcode)}"
end
