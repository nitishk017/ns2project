# Define options
set val(chan)              Channel/WirelessChannel                  	;# channel type
set val(prop)              Propagation/TwoRayGround            		;# radio-propagation model
set val(netif)             Phy/WirelessPhy                               ;# network interface type
set val(mac)               Mac/802_11                                     ;# MAC type
set val(ifq)               Queue/DropTail/PriQueue                 	;# interface queue type
set val(ll)                LL                                                     ;# link layer type
set val(ant)               Antenna/OmniAntenna                       		;# antenna model
set val(ifqlen)            50                                                     ;# max packet in ifq
set val(nn)                8                                                       ;# number of mobilenodes
#set val(rp)               OLSR                                               	;# routing protocol
set val(adhocRouting)      OLSR                     ;# routing protocol
set val(x)                 500                                                     ;# X dimension of topography
set val(y)                 400                                                     ;# Y dimension of topography 
set val(stop)              10                                                       ;# time of simulation end

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
Antenna/OmniAntenna set Gt_ 1
Antenna/OmniAntenna set Gr_ 1

#############################################################

# Creating simulation
set ns  [new Simulator -multicast on]

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
Agent/OLSR set c_alpha_              0.6                                                         ;

set f [open out.tr w]
$ns trace-all $f
$ns namtrace-all [open out.nam w]
$ns color 1 red
$ns color 30 purple     
$ns color 31 green

set group [Node allocaddr]
set nod 6
#create multicast capable nodes
for {set i 1} {$i <= $nod} {incr i} {
set n($i) [$ns node]
}


#
# create topography object
#
set topo [new Topography]
#
# configure mobile nodes
#
$ns node-config -adhocRouting $val(adhocRouting) \
                 -llType $val(ll) \
                 -macType $val(mac) \
                 -ifqType $val(ifq) \
                 -ifqLen $val(ifqlen) \
                 -antType $val(ant) \
                 -propType $val(prop) \
                 -phyType $val(netif) \
                 -channelType $val(chan) \
                -topoInstance $topo \
                 -wiredRouting OFF \
                 -agentTrace ON \
                 -routerTrace ON \
                 -macTrace ON

#create links between nodes
$ns duplex-link $n(1) $n(2) 0.3Mb 10ms DropTail
$ns duplex-link $n(2) $n(3) 0.3Mb 10ms DropTail
$ns duplex-link $n(2) $n(4) 0.5Mb 10ms DropTail
$ns duplex-link $n(2) $n(5) 0.3Mb 10ms DropTail
$ns duplex-link $n(3) $n(4) 0.3Mb 10ms DropTail
$ns duplex-link $n(4) $n(5) 0.5Mb 10ms DropTail
$ns duplex-link $n(4) $n(6) 0.5Mb 10ms DropTail
$ns duplex-link $n(5) $n(6) 0.5Mb 10ms DropTail

#configure multicast protocol
BST set RP_($group) $n(2)
$ns mrtproto BST

set udp1 [new Agent/UDP]
set udp2 [new Agent/UDP]

$ns attach-agent $n(1) $udp1
$ns attach-agent $n(2) $udp2

# setup UDP connection
set udp1 [new Agent/UDP]
$udp1 set class_ 1
set null [new Agent/Null]
$ns attach-agent $n(1) $udp1
$ns attach-agent $n(2) $null
$ns connect $udp1 $null
$udp1 set fid_ 1

set src1 [new Application/Traffic/CBR]
$src1 attach-agent $udp1
$udp1 set dst_addr_ $group
$udp1 set dst_port_ 0
$src1 set random_ false

set udp2 [new Agent/UDP]
$udp2 set class_ 2
set null1 [new Agent/Null]
$ns attach-agent $n(2) $udp2
$ns attach-agent $n(1) $null1
$ns connect $udp2 $null1
$udp2 set fid_ 2

set src2 [new Application/Traffic/CBR]
$src2 attach-agent $udp2
$udp2 set dst_addr_ $group
$udp2 set dst_port_ 1
$src1 set random_ false

#set rcvr [new Agent/LossMonitor]  #create receiver agent
set rcvr [new Agent/LossMonitor]
#joining and leaving group;

$ns at 0.6 "$n(3) join-group $rcvr $group"
$ns at 1.3 "$n(4) join-group $rcvr $group"
$ns at 1.6 "$n(5) join-group $rcvr $group"
$ns at 1.9 "$n(4) leave-group $rcvr $group"
$ns at 2.3 "$n(6) join-group $rcvr $group"
$ns at 3.5 "$n(3) leave-group $rcvr $group"

$ns at 0.4 "$src1 start"
$ns at 2.0 "$src2 start"


######################################################################

$ns at 5.0 "[$n(1) agent 255] print_rtable"
$ns at 5.0 "[$n(2) agent 255] print_rtable"
$ns at 5.0 "[$n(3) agent 255] print_rtable"
$ns at 5.0 "[$n(4) agent 255] print_rtable"
$ns at 5.0 "[$n(5) agent 255] print_rtable"
$ns at 5.0 "[$n(6) agent 255] print_rtable"

$ns at 5.0 "[$n(1) agent 255] print_linkset"
$ns at 5.0 "[$n(2) agent 255] print_linkset"
$ns at 5.0 "[$n(3) agent 255] print_linkset"
$ns at 5.0 "[$n(4) agent 255] print_linkset"
$ns at 5.0 "[$n(5) agent 255] print_linkset"
$ns at 5.0 "[$n(6) agent 255] print_linkset"

$ns at 5.0 "[$n(1) agent 255] print_nbset"
$ns at 5.0 "[$n(2) agent 255] print_nbset"
$ns at 5.0 "[$n(3) agent 255] print_nbset"
$ns at 5.0 "[$n(4) agent 255] print_nbset"
$ns at 5.0 "[$n(5) agent 255] print_nbset"
$ns at 5.0 "[$n(6) agent 255] print_nbset"


$ns at 5.0 "[$n(1) agent 255] print_nb2hopset"
$ns at 5.0 "[$n(2) agent 255] print_nb2hopset"
$ns at 5.0 "[$n(3) agent 255] print_nb2hopset"
$ns at 5.0 "[$n(4) agent 255] print_nb2hopset"
$ns at 5.0 "[$n(5) agent 255] print_nb2hopset"
$ns at 5.0 "[$n(6) agent 255] print_nb2hopset"

$ns at 5.0 "[$n(1) agent 255] print_mprset"
$ns at 5.0 "[$n(2) agent 255] print_mprset"
$ns at 5.0 "[$n(3) agent 255] print_mprset"
$ns at 5.0 "[$n(4) agent 255] print_mprset"
$ns at 5.0 "[$n(5) agent 255] print_mprset"
$ns at 5.0 "[$n(6) agent 255] print_mprset"

$ns at 5.0 "[$n(1) agent 255] print_mprselset"
$ns at 5.0 "[$n(2) agent 255] print_mprselset"
$ns at 5.0 "[$n(3) agent 255] print_mprselset"
$ns at 5.0 "[$n(4) agent 255] print_mprselset"
$ns at 5.0 "[$n(5) agent 255] print_mprselset"
$ns at 5.0 "[$n(6) agent 255] print_mprselset"

$ns at 5.0 "[$n(1) agent 255] print_topologyset"
$ns at 5.0 "[$n(2) agent 255] print_topologyset"
$ns at 5.0 "[$n(3) agent 255] print_topologyset"
$ns at 5.0 "[$n(4) agent 255] print_topologyset"
$ns at 5.0 "[$n(5) agent 255] print_topologyset"
$ns at 5.0 "[$n(6) agent 255] print_topologyset"

######################################################################

$ns at 4.0 "finish"

proc finish {} {
	global ns
	$ns flush-trace
	exec nam out.nam &
	exit 0
}

$ns run


















