# Define options
set val(chan) Channel/WirelessChannel ;# channel type
set val(prop)                    Propagation/TwoRayGround      ;# radio-propagation model
set val(netif)                   Phy/WirelessPhy               ;# network interface type
set val(mac) Mac/Tdma  	 	 ;# MAC type
set val(ifq) Queue/DropTail/PriQueue ;# interface queue type
set val(ll)                          LL                                                  ;# link layer type
set val(ant) Antenna/OmniAntenna ;# antenna model
set val(ifqlen) 50 ;# max packet in ifq
set val(nn) 4 ;# number of mobilenodes
set val(rp)                          OLSR                                              ;# routing protocol
set val(x)                            500     ;# X dimension of topography
set val(y)                            400     ;# Y dimension of topography
set val(stop) 150                             ;# time of simulation end  
set ns [new Simulator] 

#
#Create the Group of Network Simulation
#
# allocate a multicast address;
set group0 [Node allocaddr]
set group1 [Node allocaddr]

########################################
#
# control OLSR behaviour from this script -
# commented lines are not needed because
# those are default values
#
#########################################
#
# TDMA (Time Division Multiple Access) Implementation
#
Mac/Tdma set slot_packet_len_ 1500
Mac/Tdma set max_node_num_ 64
Mac/Tdma set abw_ 0
Mac/Tdma set util_weight_ 10
Mac/Tdma set enableQS_ 0
Mac/Tdma set dump_alloc_ 0
Mac/Tdma set algorithm_ 2
Mac/Tdma set delayQS_ 0
Mac/Tdma set aligned_ 1
Mac/Tdma set corrupted_slots_ 0
Mac/Tdma set used_slots_ 0
Mac/Tdma set successful_slots_ 0
Mac/Tdma set total_slots_ 0
Mac/Tdma set fixed_frame_ 0
Mac/Tdma set slots1_ 20
Mac/Tdma set offset_ 0
Mac/Tdma set hub_ 0
Mac/Tdma set num_frame_ 1
Mac/Tdma set m_frame_ 1
Mac/Tdma set fragsize_ 184
Mac/Tdma set slot_num_ 0

######################################################
#
# Agent OLSR Implementation
#
Agent/OLSR set use_mac_              true
Agent/OLSR set debug_                true
Agent/OLSR set willingness           3
Agent/OLSR set hello_ival_           2
Agent/OLSR set tc_ival_              5
Agent/OLSR set mpr_algorithm_        1
Agent/OLSR set routing_algorithm_    1
Agent/OLSR set link_quality_         1
Agent/OLSR set fish_eye_             true
Agent/OLSR set link_delay_           true
Agent/OLSR set tc_redundancy_        1
Agent/OLSR set c_alpha_              0.6
##############################################################

set tracefd [open tdma.tr w]
set namtrace [open tdma.nam w] 
$ns trace-all $tracefd
$ns namtrace-all-wireless $namtrace $val(x) $val(y)
# set up topography object
set topo [new Topography]
$topo load_flatgrid $val(x) $val(y)
create-god $val(nn)
# configure the nodes
$ns node-config -adhocRouting $val(rp) \
-llType $val(ll) \
-macType $val(mac) \
-ifqType $val(ifq) \
-ifqLen $val(ifqlen) \
-antType $val(ant) \
-propType $val(prop) \
-phyType $val(netif) \
-channelType $val(chan) \
-topoInstance $topo \
-agentTrace ON \
-routerTrace ON \
-macTrace ON \
-movementTrace ON
for {set i 0} {$i < $val(nn) } { incr i } {
set node_($i) [$ns node]
}
# Provide initial location of mobilenodes
$node_(0) set X_ 5.0
$node_(0) set Y_ 5.0
$node_(0) set Z_ 0.0

$node_(1) set X_ 490.0
$node_(1) set Y_ 285.0
$node_(1) set Z_ 0.0

$node_(2) set X_ 100.0
$node_(2) set Y_ 70.0
$node_(2) set Z_ 0.0

$node_(3) set X_ 250.0
$node_(3) set Y_ 240.0
$node_(3) set Z_ 0.0
# Set a TCP connection between node_(0) and node_(1)

set tcp [new Agent/TCP/Newreno]
$tcp set class_ 2
set sink [new Agent/TCPSink]
$ns attach-agent $node_(0) $tcp
$ns attach-agent $node_(1) $sink
$ns connect $tcp $sink
set e [new Application/Traffic/CBR]
$e attach-agent $tcp
$e set packetSize_ 4800
$e set rate_ 6kb
$e set interval_ 1
#$ns at 10.0 "$e start"

#####################################################
#
#Joining and Leaving Group
#
#puts "schedule transmitting packets..."
# create receiver agents
#set rcvr0 [new Agent/LossMonitor]
#set rcvr1 [new Agent/LossMonitor]

#$ns attach-agent $node_(4) $rcvr0
#$ns attach-agent $node_(5) $rcvr1

# joining and leaving the group;
#$ns at 10.10 "$node_(4) join-group $rcvr0 $group0"
#$ns at 10.12 "$node_(5) join-group $rcvr1 $group0"
#$ns at 10.50 "$node_(4) leave-group $rcvr0 $group0"
#$ns at 10.60 "$node_(4) join-group $rcvr0 $group1"

##########################################################

#
# print (in the trace file) routing table and other
# internal data structures on a per-node basis
#
$ns at 5.0 "[$node_(0) agent 255] print_rtable"
$ns at 5.0 "[$node_(1) agent 255] print_rtable"
$ns at 5.0 "[$node_(2) agent 255] print_rtable"
$ns at 5.0 "[$node_(3) agent 255] print_rtable"

$ns at 5.0 "[$node_(0) agent 255] print_linkset"
$ns at 5.0 "[$node_(1) agent 255] print_linkset"
$ns at 5.0 "[$node_(2) agent 255] print_linkset"
$ns at 5.0 "[$node_(3) agent 255] print_linkset"

$ns at 5.0 "[$node_(0) agent 255] print_nbset"
$ns at 5.0 "[$node_(1) agent 255] print_nbset"
$ns at 5.0 "[$node_(2) agent 255] print_nbset"
$ns at 5.0 "[$node_(3) agent 255] print_nbset"

$ns at 5.0 "[$node_(0) agent 255] print_nb2hopset"
$ns at 5.0 "[$node_(1) agent 255] print_nb2hopset"
$ns at 5.0 "[$node_(2) agent 255] print_nb2hopset"
$ns at 5.0 "[$node_(3) agent 255] print_nb2hopset"

$ns at 5.0 "[$node_(0) agent 255] print_mprset"
$ns at 5.0 "[$node_(1) agent 255] print_mprset"
$ns at 5.0 "[$node_(2) agent 255] print_mprset"
$ns at 5.0 "[$node_(3) agent 255] print_mprset"

$ns at 5.0 "[$node_(0) agent 255] print_mprselset"
$ns at 5.0 "[$node_(1) agent 255] print_mprselset"
$ns at 5.0 "[$node_(2) agent 255] print_mprselset"
$ns at 5.0 "[$node_(3) agent 255] print_mprselset"

$ns at 5.0 "[$node_(0) agent 255] print_topologyset"
$ns at 5.0 "[$node_(1) agent 255] print_topologyset"
$ns at 5.0 "[$node_(2) agent 255] print_topologyset"
$ns at 5.0 "[$node_(3) agent 255] print_topologyset"
$ns at 10.0 "$e start"
# Define node initial position in nam
for {set i 0} {$i < $val(nn)} { incr i } {
# 30 defines the node size for nam
$ns initial_node_pos $node_($i) 30
}
# Telling nodes when the simulation ends
for {set i 0} {$i < $val(nn) } { incr i } {
$ns at $val(stop) "$node_($i) reset";
}
# ending nam and the simulation
$ns at $val(stop) "$ns nam-end-wireless $val(stop)"
$ns at $val(stop) "stop"
$ns at 150.01 "puts \"end simulation\" ; $ns halt" 

proc stop {} {
global ns tracefd namtrace
$ns flush-trace
close $tracefd
close $namtrace
#Execute nam on the trace file
exec nam tdma.nam &
exit 0

}

#Call the finish procedure after 5 seconds of simulation time
$ns run
