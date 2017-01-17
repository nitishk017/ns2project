set opt(chan)           Channel/WirelessChannel  ;# channel type
set opt(prop)           Propagation/TwoRayGround   ;# radio-propagation model
set opt(prop)           Propagation/Shadowing   ;# radio-propagation model
set opt(netif)          Phy/WirelessPhy          ;# network interface type
set opt(mac)            Mac/802_11               ;# MAC type
set opt(ifq)            Queue/DropTail/PriQueue  ;# interface queue type
set opt(ll)             LL                       ;# link layer type
set opt(ant)            Antenna/OmniAntenna      ;# antenna model
set opt(ifqlen)         50                       ;# max packet in ifq
set opt(nn)             3                       ;# number of mobilenodes
set opt(adhocRouting)   OLSR                     ;# routing protocol
set opt(cp)             ""                       ;# connection pattern file
set opt(sc)             ""                       ;# node movement file.
set opt(x)              1000                     ;# x coordinate of topology
set opt(y)              1000                     ;# y coordinate of topology
set opt(seed) X
set opt(stop)           50                       ;# time to stop simulation
set opt(cbr-start)      5.0
set opt(cbr-stop)       45.0
set opt(pa-start)       7.0
set opt(pa-stop)        37.0
set opt(pa1-start)      9.0
set opt(pa1-stop)       39.0
# ============================================================================

#
# check for random seed
#
############################################################
Phy/WirelessPhy set CPThresh_ 10.0
Phy/WirelessPhy set CSThresh_ 9.21756e-11 ;#550m
Phy/WirelessPhy set RXThresh_ 4.80696e-07 ;#250m
#Phy/WirelessPhy set RXThresh_ 1.56962e-05 ;#250m
Phy/WirelessPhy set bandwidth_ 512kb
#Phy/WirelessPhy set Pt_ 0.2818
Phy/WirelessPhy set Pt_ 0.281838
Phy/WirelessPhy set freq_ 2.4e+9
Phy/WirelessPhy set L_ 1.0 
Antenna/OmniAntenna set X_ 0
Antenna/OmniAntenna set Y_ 0
Antenna/OmniAntenna set Z_ 0.25
Antenna/OmniAntenna set Gt_ 18
Antenna/OmniAntenna set Gr_ 18
#############################################################

if {$opt(seed) > 0} {
    puts "Seeding Random number generator with $opt(seed)\n"
    ns-random $opt(seed)
}

Mac/802_11 set dataRate_ 11Mb
Mac/802_11 set basicRate_ 2Mb

#Propagation/Shadowing set pathlossExp_ 2.7       ;#expoente de perdas
#Propagation/Shadowing set std_db_ 4.0           ;#desvio padrao (dB)

#
# create simulator instance
#
set ns_ [new Simulator]

#
# control OLSR behaviour from this script -
# commented lines are not needed because
# those are default values
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

#
# open traces
#
$ns_ use-newtrace
set tracefd  [open wtrace.tr w]
set namtrace [open simulation.nam w]
$ns_ trace-all $tracefd
$ns_ namtrace-all-wireless $namtrace $opt(x) $opt(y)

set group [Node allocaddr]
#
# create topography object
#
set topo [new Topography]

#
# define topology
#
$topo load_flatgrid $opt(x) $opt(y)

#
# create God
#
create-god $opt(nn)

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
                 -channelType $opt(chan) \
                 -topoInstance $topo \
                 -wiredRouting OFF \
                 -agentTrace ON \
                 -routerTrace ON \
                 -macTrace ON

for {set i 1} {$i < $opt(nn)} {incr i} {
    set node_($i) [$ns_ node]
}
#
#
# positions
$node_(1) set X_ 160.0  
$node_(1) set Y_ 485.0
$node_(1) set Z_ 15.0
$ns_ at 0.0 "$node_(1) setdest 201.13080019823929 127.93648539275274 0.9949870193616882"
$ns_ at 70.34039628073151 "$node_(1) setdest 19.494188509237755 127.93648539275274 1.0845662375206948"
$ns_ at 282.5054162521774 "$node_(1) setdest 19.494188509237755 137.98086313013738 0.5198851818927442"
$ns_ at 305.65027495027107 "$node_(1) setdest 157.51867947030829 137.98086313013738 1.2095904488968137"
$ns_ at 455.62522119524374 "$node_(1) setdest 157.51867947030829 203.94091783037914 1.0767802293713966"
$node_(2) set X_ 305.0  #DI
$node_(2) set Y_ 277.0
$node_(2) set Z_ 15.0
$ns_ at 0.0 "$node_(2) setdest 102.06260565004362 157.31161957711126 1.4826885165744506"
$ns_ at 96.780524537789 "$node_(2) setdest 102.06260565004362 51.42364924781581 1.1137586036093408"
$ns_ at 225.08812028810462 "$node_(2) setdest 102.06260565004362 144.36801196934294 0.9597120584698137"
$ns_ at 410.8489297483093 "$node_(2) setdest 23.919088023688396 144.36801196934294 1.2967006909078846"
$ns_ at 479.33022671017034 "$node_(2) setdest 23.919088023688396 74.48501115435309 1.1518586113903386"

###############################################################################################################
# cores
$ns_ color 1 red
$ns_ color 2 blue
$ns_ color 3 yellow

#configure multicast protocol
#set mproto BST
#$ns_ mrtproto $mproto
#BST set RP_($group) $node_(1)
#$ns_ mrtproto BST


# Dense Mode Multicast Protocol
#set mproto DM
#set mrthandle [$ns_ mrtproto $mproto {}]

# setup UDP connection
set udp [new Agent/UDP]
$udp set class_ 1
set null [new Agent/Null]
$ns_ attach-agent $node_(1) $udp
$ns_ attach-agent $node_(2) $null
$ns_ connect $udp $null
$udp set fid_ 1

set cbr [new Application/Traffic/CBR]
$cbr set packetSize_ 40     # RTP + UDP + Payload
$cbr set rate_ 8Kb
$cbr attach-agent $udp
#$udp set dst_addr_ $group
#$udp set dst_port_ 0
$ns_ at 5.0 "$cbr start"
$ns_ at 45.0  "$cbr stop"

set udp1 [new Agent/UDP]
$udp1 set class_ 2
set null1 [new Agent/Null]
$ns_ attach-agent $node_(2) $udp1
$ns_ attach-agent $node_(1) $null1
$ns_ connect $udp1 $null1
$udp1 set fid_ 2

set cbr1 [new Application/Traffic/CBR]
$cbr1 set packetSize_ 40     # RTP + UDP + Payload
$cbr1 set rate_ 8Kb
$cbr1 attach-agent $udp1
#$udp1 set dst_addr_ $group
#$udp1 set dst_port_ 0
$ns_ at 5.0 "$cbr1 start"
$ns_ at 45.0  "$cbr1 stop"

set rcvr [new Agent/LossMonitor]

#joining and leaving group;

#$ns_ at 0.6 "$node_(1) join-group $rcvr $group"
#$ns_ at 1.3 "$node_(2) join-group $rcvr $group"
#$ns_ at 1.9 "$node_(2) leave-group $rcvr $group"
#$ns_ at 2.3 "$node_(1) leave-group $rcvr $group"
#$ns_ at 3.5 "$node_(2) join-group $rcvr $group"

#############################################################
#############################################################

## Label the Special Node in NAM
$ns_ at 0.0 "$node_(1) label Nitish"
$ns_ at 0.0 "$node_(2) label Paul"

######################################################################

$ns_ at 5.0 "[$node_(1) agent 255] print_rtable"
$ns_ at 5.0 "[$node_(2) agent 255] print_rtable"

$ns_ at 5.0 "[$node_(1) agent 255] print_linkset"
$ns_ at 5.0 "[$node_(2) agent 255] print_linkset"

$ns_ at 5.0 "[$node_(1) agent 255] print_nbset"
$ns_ at 5.0 "[$node_(2) agent 255] print_nbset"

$ns_ at 5.0 "[$node_(1) agent 255] print_nb2hopset"
$ns_ at 5.0 "[$node_(2) agent 255] print_nb2hopset"

$ns_ at 5.0 "[$node_(1) agent 255] print_mprset"
$ns_ at 5.0 "[$node_(2) agent 255] print_mprset"

$ns_ at 5.0 "[$node_(1) agent 255] print_mprselset"
$ns_ at 5.0 "[$node_(2) agent 255] print_mprselset"

$ns_ at 5.0 "[$node_(1) agent 255] print_topologyset"
$ns_ at 5.0 "[$node_(2) agent 255] print_topologyset"

######################################################################

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
# define initial node position in nam
#
for {set i 1} {$i < $opt(nn)} {incr i} {
    $ns_ initial_node_pos $node_($i) 20
}

#
# tell all nodes when the simulation ends
#
$ns_ at $opt(stop).0001 "stop"

proc stop {} {
    global ns_ tracefd namtrace
    $ns_ flush-trace
    close $tracefd
    close $namtrace
    exec nam simulation.nam &
    exit 0
}

#
# begin simulation
#
puts "Starting Simulation..."

$ns_ run
