require "socket"

def parse_request(request_line)
  request_line_array = request_line.split(" ")
  http_method = request_line_array[0]

  path = request_line_array[1].split("?")[1]

  params = {}

  path.split("&").each do |query|
    s = query.split("=")
    params[s[0]] = s[1]
  end

  [http_method, path, params]
  
end

server= TCPServer.new("localhost", 3003)
loop do
  client = server.accept

  request_line = client.gets

  puts request_line

  client.puts "HTTP/1.1 200 OK\r\n\r\n"

  client.puts request_line

  http_method = parse_request(request_line)[0]
  path = parse_request(request_line)[1]
  params = parse_request(request_line)[2]


  params["rolls"].to_i.times do
    client.puts rand(params["sides"].to_i + 1)
  end

  client.puts(http_method)
  client.puts(path)
  client.puts(params)
  client.close
end

