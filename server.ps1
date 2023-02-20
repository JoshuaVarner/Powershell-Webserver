# Define the port number to listen on
$port = 80

# Define the path to the index.html file
$filePath = Join-Path $PSScriptRoot "index.html"

# Read the contents of the index.html file
$response = Get-Content $filePath -Raw

# Create a listener socket
$listener = New-Object System.Net.Sockets.TcpListener([IPAddress]::Any, $port)

# Start listening for incoming requests
$listener.Start()

# Loop to handle incoming requests
while ($true) {
    # Wait for a client to connect
    $client = $listener.AcceptTcpClient()

    # Read the incoming request data
    $stream = $client.GetStream()
    $reader = New-Object System.IO.StreamReader($stream)
    $data = $reader.ReadLine()

    # Send the response back to the client
    $writer = New-Object System.IO.StreamWriter($stream)
    $writer.WriteLine("HTTP/1.1 200 OK")
    $writer.WriteLine("Content-Length: " + $response.Length)
    $writer.WriteLine("Content-Type: text/html; charset=UTF-8")
    $writer.WriteLine()
    $writer.Write($response)
    $writer.Flush()

    # Close the connection
    $stream.Close()
    $client.Close()
}
