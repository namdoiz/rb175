require "socket"

def parse_request(request_line)
  http_method, path_and_params, http = request_line.split(" ")
  path, params = path_and_params.split("?")

  params = (params || "").split("&").each_with_object({}) do |pair, hash|
    key, value = pair.split("=")
    hash[key] = value
  end

  [http_method, path, params]
end

server= TCPServer.new("localhost", 3003)

loop do
  client = server.accept

  request_line = client.gets
  next if !request_line || request_line =~ /favicon/
  next unless request_line

  http_method = parse_request(request_line)[0]
  path = parse_request(request_line)[1]
  params = parse_request(request_line)[2]

  client.puts "HTTP/1.1 200 OK"
  client.puts "Content-Type: text/html"
  client.puts
  client.puts "<html>"
  client.puts "<body>"
  client.puts "<pre>"
  client.puts http_method
  client.puts path
  client.puts params
  client.puts "</pre>"

  client.puts "<h1>Counter</h1>"
  number = params["number"]
  client.puts "<p> The current number is #{number}.</p>"

  client.puts "<a href='?number=#{number.to_i + 1}'>Add one</a>"
  client.puts "<a href='?number=#{number.to_i - 1}'>Subtract one</a>"

  client.puts "</body>"
  client.puts "</html>"
  client.close
end
