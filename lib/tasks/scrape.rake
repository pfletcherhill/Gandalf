namespace :db do
  desc "scrape Yale's events calendar"
  task :scrape => :environment do
    link = "http://calendar.yale.edu/cal/opa/day/20121208/All/?showDetails=yes"
    page = Nokogiri::HTML(open(link))
    results = page.xpath("//table[@class='eventList']/tr")
    organization = Organization.where(:name => "Yale University").first
    results.each_with_index do |row, index|
      @event = Event.new
      @event.organization = organization
      @event.gmaps = false
      @event.address = "1111 Chapel Street, New Haven, CT 06511"
      length = results.length - 1
      if index > 0 && index < length
        time = row.css("td")[0].text
        details = row.css("td.description ul")
        title = details.css("li.titleEvent a")
        title = title.text.gsub(/\"/,"")
        pp title
        @event.name = title
        location = details.css("li")[1]
        location = location.text.gsub(/Location:\n/,"").strip
        @event.location = location
        description = details.css("li")[3].text
        @event.description = description
        if time.include? "All day"
          time = "all-day"
        elsif time.include? "/"
          time = "multi-day"
        elsif time.include? " - "
          time = time.split(" - ")
          start_at = @date + "," + time[0]
          start_at = DateTime.parse start_at
          end_at = @date + "," + time[1]
          end_at = DateTime.parse end_at
          @event.start_at = start_at
          @event.end_at = end_at
          @event.save
        else
          start_at = Time.new time
          end_at = nil
        end
      elsif index == 0
        @date = row.content
        pp "date: #{@date}"
      end
    end
  end
end