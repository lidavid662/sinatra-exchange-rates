# /app.rb

require "sinatra"
require "sinatra/reloader"
require "http"
require "json"

# define a route
get("/") do

  # build the API url, including the API key in the query string
  ENV.fetch("ERKEY")
  api_url = "https://api.exchangerate.host/list?access_key=#{ENV.fetch('ERKEY')}"
  #api_url = "https://api.exchangerate.host/list?access_key={ENV.fetch[\"ERKEY\"]}"

  # use HTTP.get to retrieve the API information
  raw_data = HTTP.get(api_url)

  # convert the raw request to a string
  raw_data_string = raw_data.to_s

  # convert the string to JSON
  parsed_data = JSON.parse(raw_data_string)

  # get the symbols from the JSON
  @symbols = parsed_data["currencies"]

  # render a view template where I show the symbols
  erb(:homepage)
end

get("/:firstc") do
  ENV.fetch("ERKEY")
  api_url = "https://api.exchangerate.host/list?access_key=#{ENV.fetch('ERKEY')}"
  #api_url = "https://api.exchangerate.host/list?access_key={ENV.fetch[\"ERKEY\"]}"

  # use HTTP.get to retrieve the API information
  raw_data = HTTP.get(api_url)

  # convert the raw request to a string
  raw_data_string = raw_data.to_s

  # convert the string to JSON
  parsed_data = JSON.parse(raw_data_string)
  @symbols2 = parsed_data["currencies"]
  @firstcurr=params.fetch("firstc")
  erb(:secondstage)
end

get("/:firstc/:secondc") do
  
  @firstcurr=params.fetch("firstc")
  ENV.fetch("ERKEY")
  api_url = "https://api.exchangerate.host/live?access_key=#{ENV.fetch('ERKEY')}&source=#{@firstcurr}"

  # use HTTP.get to retrieve the API information
  raw_data = HTTP.get(api_url)

  # convert the raw request to a string
  raw_data_string = raw_data.to_s

  # convert the string to JSON
  parsed_data = JSON.parse(raw_data_string)
  @symbols2 = parsed_data["currencies"]
  @secondcurr=params.fetch("secondc")
  @pair=@firstcurr+@secondcurr
  @convalue = parsed_data["quotes"]
  @convalue2= @convalue[@pair]
  
  erb(:finalstage)
end
