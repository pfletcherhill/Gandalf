class ScrapeYaleEvents < Struct.new(:url)

  def perform
    puts("performing job")
    link = url
    page = Nokogiri::HTML(open(link))
    results = page.xpath("//table[@class='eventList']/tr")
    organization = Organization.where(:name => "Yale University").first
    results.each_with_index do |row, index|
      @event = Event.new
      @event.organization = organization
      length = results.length - 1
      if index > 0 && index < length
        time = row.css("td")[0].text
        details = row.css("td.description ul")
        title = details.css("li.titleEvent a")
        title = title.text.gsub(/\"/,"")
        @event.name = title
        location = details.css("li")[1]
        location = location.text.gsub(/Location:\n/,"").strip
        @location = Location.where(:name => location).first
        unless @location
          key = "AIzaSyDxC7qcloU94l5dvOEdAoQTZ7AijIX65gw"
          search = location.gsub(" ","+")
          map_results = JSON.parse(open("https://maps.googleapis.com/maps/api/place/textsearch/json?location=41.310362,-72.928914&radius=500&key=#{key}&query=#{search}&sensor=true").read)
          loc = map_results['results'].first
          if loc
            address = loc["formatted_address"]
            lat = loc["geometry"]["location"]["lat"]
            lng = loc["geometry"]["location"]["lng"]
          else
            address = "38 Hillhouse Avenue, New Haven, CT 06511"
            lat = "41.310362"
            lng = "-72.928914"
          end
          @location = Location.new(:name => location, :address => address, :gmaps => true, :latitude => lat, :longitude => lng)
          @location.save
        end
        pp "#{location}: #{@location.address}"
        @event.location = @location
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