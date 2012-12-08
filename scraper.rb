require 'nokogiri'
require 'pp'
require 'open-uri'

events = Array.new
link = "http://calendar.yale.edu/cal/opa/day/20121207/All/?showDetails=yes"
page = Nokogiri::HTML(open(link))
results = page.xpath("//table[@class='eventList']/tr")
results.each_with_index do |row, index|
  length = results.length - 1
  if index > 0 && index < length
    time = row.css("td")[0]
    pp "time: #{time.text}"
    details = row.css("td.description ul")
    title = details.css("li.titleEvent a")
    title = title.text.gsub(/\"/,"")
    pp "title: #{title}"
    location = details.css("li")[1]
    location = location.text.gsub(/Location:\n/,"").strip
    pp "location: #{location}"
    description = details.css("li")[3].text
    pp "description: #{description}"
  elsif index == 0
    date = row.content
    pp "date: #{date}"
  end
end