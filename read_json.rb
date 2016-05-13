require 'json'
require 'net/http'

module GetUS
  def GetUS::get_state_name(filename)
    begin
      state_file = File.read(filename)
    rescue
      raise IOError, "Could not read file #{filename}"
    end
    state_2_char = []

    state_json = JSON.parse(state_file)

    state_json.each do |state|
      state_2_char.push(state['alpha-2'].downcase)
    end

    state_2_char
  end

  def GetUS::print_state_arr(array)
    puts array
  end

  def GetUS::get_state_json(state)
    # http://api.sba.gov/geodata/city_links_for_state_of/#{state}.json
    begin
      uri = URI("http://api.sba.gov/geodata/city_links_for_state_of/#{state}.json")
      state_str = Net::HTTP.get(uri)
    rescue
      Net:HTTPExceptions, "Something wrong with the request for #{state}"
    end

    fp = File.open("#{state}.json", 'w')
    fp.write(state_str)
    fp.close
  end
end

STATE_JSON = 'us-state.json'

# Test the first get_state_name
# state_arr = GetUS::get_state_name(STATE_JSON)
# state_arr.each do |state|
#   puts "We process with state: #{state}"
#   GetUS::get_state_json(state)
#   sleep(5)
# end

