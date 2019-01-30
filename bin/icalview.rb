#!/usr/bin/env ruby

require "rubygems" # apt-get install rubygems
require "icalendar" # gem install icalendar
#require "date"

# class DateTime
#   def myformat
#     (self.offset == 0 ? self.strftime("%F %R") : self.strftime("%F %R %z"))
#   end
# end

cals = Icalendar::Calendar.parse($<)
cals.each do |cal|
  cal.events.each do |event|
    puts "Organizer: #{event.organizer}"
    puts "Event:     #{event.summary}"
    # puts "Starts:    #{event.dtstart.myformat}"
    # puts "Ends:      #{event.dtend.myformat}"
    puts "Starts:    #{event.dtstart}"
    puts "Ends:      #{event.dtend}"
    puts "Location:  #{event.location}"
    puts "Contact:   #{event.contact}"
    puts "Description:\n#{event.description}"
    puts ""
  end
end
