require 'csv'
require 'google/apis/civicinfo_v2'
require 'erb'

def get_attendees_data()
  Dir.chdir '../'
  puts "#{Dir.pwd}, #{Dir.exists? "/home/sam/Desktop/Personal_Files/the odin project/ruby/repos/event_manager/event_attendees.csv"}"
  csv_url = 'https://raw.githubusercontent.com/TheOdinProject/curriculum/main/ruby/files_and_serialization/event_attendees.csv'
  get_attendees_data = `curl -o event_attendees.csv #{csv_url}`

  puts get_attendees_data
  Dir.chdir 'lib'
end

def clean_zipcode(zipcode)
  # cleans zipcodes and truncates 0's at the start untill it reaches a five digit number
  return zipcode.to_s.rjust(5, '0')[0..4]
end


def legislators_by_zipcode(zipcode)
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
    ).officials
  rescue
    'You can find your representatives by visiting www.commoncause.org/take-action/find-elected-officials'
  end
end


puts "event manager initilized"

# gets data if data doesnt exist locally
get_attendees_data() unless File.exists? '../event_attendees.csv'

attendee_list = CSV.open(
  '../event_attendees.csv',
  headers: true,
  header_converters: :symbol
)


Dir.chdir '../letters'
attendee_list.each do |line|
  first_name = line[:first_name]
  zipcode = clean_zipcode(line[:zipcode])
  legislators = legislators_by_zipcode(zipcode)

  # reading the letter template file
  attendee_letter = ERB.new File.open('../templates/letter_template.erb').read
  # injecting data into the template letter
  output = attendee_letter.result(binding)
  # getting id
  id = line[0]
  # outputting letter to a letters/letter
  lettr_name = "thanks_#{id}.html"
  File.open(lettr_name , 'w') {|file| file.write(output)}
end
