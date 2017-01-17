# ======================================================================
# Define options
# ======================================================================
set opt(chan) Channel/WirelessChannel ;# channel type
set opt(prop) Propagation/TwoRayGround ;# radio-propagation model
set opt(netif) Phy/WirelessPhy ;# network interface type
set opt(mac) Mac/802_11 ;# MAC type
set opt(ifq) Queue/DropTail/PriQueue ;# interface queue type
set opt(ll) LL ;# link layer type
set opt(ant) Antenna/OmniAntenna ;# antenna model
set opt(ifqlen) 50 ;# max packet in ifq
set opt(nn) 2 ;# number of mobilenodes
#set opt(adhocRouting) OLSR ;# routing protocol
set opt(adhocRouting) KMANET ;# routing protocol
set opt(cp) "" ;# connection pattern file
set opt(sc) "" ;# node movement file.
set opt(x) 400 ;#
set opt(y) 600 ;#
set opt(seed) 0.0 ;#
set opt(stop) 45 ;#
set opt(cbr-start) 20.0
# ============================================================================
#
# check for random seed
#
if {$opt(seed) > 0} {
puts "Seeding Random number generator with $opt(seed)\n"
ns-random $opt(seed)
}
#
# create simulator instance
#
set ns_ [new Simulator]
#
# control OLSR behaviour from this script -
# commented lines are not needed because
# those are default values
#
#Agent/OLSR set use_mac_ true
#Agent/OLSR set debug_ true
#Agent/OLSR set willingness 3
Agent/OLSR set hello_ival_ 3
#Agent/OLSR set tc_ival_ 6
#
# open traces
#
set tracefd [open olsr_example.tr w]
set namtrace [open olsr_example.nam w]
$ns_ trace-all $tracefd
$ns_ namtrace-all-wireless $namtrace $opt(x) $opt(y)
#
# create topography object
set topo [new Topography]
#
# define topology
#
$topo load_flatgrid $opt(x) $opt(y)
#
# create God
#
create-god $opt(nn)

set chan_1_ [new $opt(chan)]

#
# configure mobile nodes
#

$ns_ node-config -adhocRouting $opt(adhocRouting) \
		-llType $opt(ll) \
		-macType $opt(mac) \
		-ifqType $opt(ifq) \
		-ifqLen $opt(ifqlen) \
		-antType $opt(ant) \
		-propType $opt(prop) \
		-phyType $opt(netif) \
		-channel $chan_1_ \
		-topoInstance $topo \
		-wiredRouting ON \
		-agentTrace ON \
		-routerTrace ON \
		-macTrace ON
#for {set i 0} {$i < $opt(nn)} {incr i} {
#set node_($i) [$ns_ node]
#}

#
# define initial node position in nam
#
#for {set i 0} {$i < $opt(nn)} {incr i} {
#	$ns_ initial_node_pos $node_($i) 20
#}

set node_(0) [$ns_ node]
set node_(1) [$ns_ node]
#set node_(2) [$ns_ node]
#set node_(3) [$ns_ node]
#set node_(4) [$ns_ node]

#$ns_ initial_node_pos $node_(0) 30
#$ns_ initial_node_pos $node_(1) 30
#$ns_ initial_node_pos $node_(2) 30
#$ns_ initial_node_pos $node_(3) 30
#$ns_ initial_node_pos $node_(4) 30

for {set i 0} {$i < $opt(nn)} {incr i} {
	$ns_ initial_node_pos $node_($i) 20
}

#
# positions
#
$node_(0) set X_ 350.0
$node_(0) set Y_ 200.0
$node_(0) set Z_ 0.0
$node_(1) set X_ 200.0
$node_(1) set Y_ 350.0
$node_(1) set Z_ 0.0
#$node_(2) set X_ 200.0
#$node_(2) set Y_ 550.0
#$node_(2) set Z_ 0.0
#$node_(3) set X_ 50.0
#$node_(3) set Y_ 200.0
#$node_(3) set Z_ 0.0
#$node_(4) set X_ 200.0
#$node_(4) set Y_ 50.0
#$node_(4) set Z_ 0.0
#
# setup UDP connection
set udp [new Agent/UDP]
set null [new Agent/Null]
$ns_ attach-agent $node_(0) $udp
$ns_ attach-agent $node_(1) $null
$ns_ connect $udp $null
set cbr [new Application/Traffic/CBR]
#$cbr set packetSize_ 512
#$cbr set rate_ 20Kb
$cbr attach-agent $udp
$ns_ at $opt(cbr-start) "$cbr start"

set udp1 [new Agent/UDP]
set null1 [new Agent/Null]
$ns_ attach-agent $node_(1) $udp1
$ns_ attach-agent $node_(0) $null1
$ns_ connect $udp1 $null1
set cbr1 [new Application/Traffic/CBR]
#$cbr1 set packetSize_ 512
#$cbr1 set rate_ 20Kb
$cbr1 attach-agent $udp1
$ns_ at $opt(cbr-start) "$cbr1 start"
#
# print (in the trace file) routing table and other
# internal data structures on a per-node basis
#
puts "**********Priting Table Operation***************"

#$ns_ at 10.0 "[$node_(0) agent 255] print_rtable"
#$ns_ at 15.0 "[$node_(0) agent 255] print_linkset"
#$ns_ at 20.0 "[$node_(0) agent 255] print_nbset"
#$ns_ at 25.0 "[$node_(0) agent 255] print_nb2hopset"
#$ns_ at 30.0 "[$node_(0) agent 255] print_mprset"
#$ns_ at 35.0 "[$node_(0) agent 255] print_mprselset"
#$ns_ at 40.0 "[$node_(0) agent 255] print_topologyset"

#$ns_ at 10.0 "[$node_(1) agent 255] print_rtable"
#$ns_ at 15.0 "[$node_(1) agent 255] print_linkset"
#$ns_ at 20.0 "[$node_(1) agent 255] print_nbset"
#$ns_ at 25.0 "[$node_(1) agent 255] print_nb2hopset"
#$ns_ at 30.0 "[$node_(1) agent 255] print_mprset"
#$ns_ at 35.0 "[$node_(1) agent 255] print_mprselset"
#$ns_ at 40.0 "[$node_(1) agent 255] print_topologyset"
#
# source connection-pattern and node-movement scripts
#
if { $opt(cp) == "" } {
puts "*** NOTE: no connection pattern specified."
set opt(cp) "none"
} else {
puts "Loading connection pattern..."
source $opt(cp)
}
if { $opt(sc) == "" } {
puts "*** NOTE: no scenario file specified."
set opt(sc) "none"
} else {
puts "Loading scenario file..."
source $opt(sc)
puts "Load complete..."
}
#
# tell all nodes when the simulation ends
#
#for {set i 0} {$i < $opt(nn) } {incr i} {
#	$ns_ at $opt(stop) "$node_($i) reset";
#}
#$ns_ at $opt(stop) "puts \"NS EXITING...\" ; $ns_ halt"
$ns_ at $opt(stop) "stop"
#$ns_ at $opt(stop) "finish"
#puts olsr_example.tr 

proc stop {} {
	global ns_ tracefd namtrace
	$ns_ flush-trace
	close $tracefd
	close $namtrace
	exec nam olsr_example.nam &
	exit 0
}
puts "Starting Simulation..."
$ns_ run


