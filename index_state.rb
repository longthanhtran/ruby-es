require 'elasticsearch'
require 'json'
require_relative './read_json'

ES_HOST = "localhost:9200"

module ES
  include GetUS
  def ES.idx(filename)
    begin
      in_json = JSON.parse(open(filename).read)
    rescue
      raise IOError, "Issue while read #{filename}"
    end
    # raise TypeError, "Data array not valid" if in_json.empty?
    raise TypeError, "Data array is not valid" unless ! in_json.empty?
    #ES.idx_bulk in_json rescue raise TypeError, "Data array is not valid"
    ES.idx_bulk in_json
  end

  def ES.idx_bulk arr_data
    es_config = {
      host: "http://#{ES_HOST}",
      transport_options: {
        request: { timeout: 20 }
      },
    }

    client = Elasticsearch::Client.new es_config #log: true

    data = []
    ops = { index: { _index: 'us_state_v1', _type: 'state' } }

    arr_data.each do |item|
      data.push ops
      data.push item
    end

    client.bulk body: data

  end

  def ES.idx_all_state(filename)
    states = GetUS.get_state_name(filename)
    states.each do |state|
      file = Dir.pwd + "/json-data/#{state}.json"
      puts "Processing file #{file}"
      ES.idx(file) rescue next
    end
  end
end

# ES::idx_test

# client.index index: 'myindex', type: 'mytype', body: { first_name: 'Long', last_name: 'Tran' }
#
ES.idx_all_state(Dir.pwd + "/us-state.json")

# state_file = Dir.pwd + "/json-data/tx.json"
# ES::idx(state_file)
