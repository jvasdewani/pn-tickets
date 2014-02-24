@options = { :namespace => "scoreboard", :compress => true }
$dalli = ConnectionPool.new(:size => 10, :timeout => 5) { Dalli::Client.new('localhost:11211', @options) }
