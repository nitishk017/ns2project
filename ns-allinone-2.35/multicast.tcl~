set ns [new Simulator -multicast on]

# Dense Mode Multicast Protocol
set mproto DM
set mrthandle [$ns mrtproto $mproto {}]

# allocate a multicast address;
set group0 [Node allocaddr]
set group1 [Node allocaddr]

# Open nam tracefile
set nf [open prob1.nam w]

# Open tracefile
set nt [open trace.tr w]

$ns namtrace-all $nf
$ns trace-all $nt

$ns color 1 red
# the nam colors for the prune packets
$ns color 30 purple
# the nam colors for the graft packets
$ns color 31 green

#Define a 'finish' procedure
proc finish {} {
global ns nf nt
$ns flush-trace
close $nf
close $nt
puts "running nam..."
exec nam -a prob1.nam &
exit 0
}

# create 5 nodes
puts "create 5 nodes now....."

set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]

puts "create connections now....."

# Create connection
$ns duplex-link $n1 $n2 1Mb 5ms DropTail
$ns duplex-link $n2 $n3 1Mb 5ms DropTail
$ns duplex-link $n3 $n4 1Mb 5ms DropTail
$ns duplex-link $n2 $n4 1Mb 5ms DropTail
$ns duplex-link $n2 $n5 1Mb 5ms DropTail

# Node orientation
$ns duplex-link-op $n1 $n2 orient right
$ns duplex-link-op $n2 $n3 orient right
$ns duplex-link-op $n3 $n4 orient right
$ns duplex-link-op $n2 $n4 orient down
$ns duplex-link-op $n2 $n5 orient up

puts "Create agents and attach to appropriate nodes..."

# Create agents and attach to appropriate nodes
set udp0 [new Agent/UDP]
$ns attach-agent $n1 $udp0
$udp0 set dst_addr_ $group0
$udp0 set dst_port_ 0
set cbr0 [new Application/Traffic/CBR]
$cbr0 attach-agent $udp0

set udp1 [new Agent/UDP]
$ns attach-agent $n3 $udp1
$udp1 set dst_addr_ $group1
$udp1 set dst_port_ 1
set cbr1 [new Application/Traffic/CBR]
$cbr1 attach-agent $udp1

puts "schedule transmitting packets..."
# create receiver agents
set rcvr0 [new Agent/LossMonitor]
set rcvr1 [new Agent/LossMonitor]

$ns attach-agent $n4 $rcvr0
$ns attach-agent $n5 $rcvr1

# joining and leaving the group;
$ns at 0.10 "$n4 join-group $rcvr0 $group0"
$ns at 0.12 "$n5 join-group $rcvr1 $group0"
$ns at 0.50 "$n4 leave-group $rcvr0 $group0"
$ns at 0.60 "$n4 join-group $rcvr0 $group1"

$ns at 0.05 "$cbr0 start"
$ns at 0.05 "$cbr1 start"
$ns at 0.80 "finish"
$ns run

