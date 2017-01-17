set opt(chan)           Channel/WirelessChannel  ;# channel type
set opt(prop)           Propagation/TwoRayGround   ;# radio-propagation model
set opt(prop)           Propagation/Shadowing   ;# radio-propagation model
set opt(netif)          Phy/WirelessPhy          ;# network interface type
set opt(mac)            Mac/802_11               ;# MAC type
set opt(ifq)            Queue/DropTail/PriQueue  ;# interface queue type
set opt(ll)             LL                       ;# link layer type
set opt(ant)            Antenna/OmniAntenna      ;# antenna model
#set opt(mac)            Mac/Tdma  	 	 ;# MAC type
set opt(ifqlen)         50                       ;# max packet in ifq
set opt(nn)             11                       ;# number of mobilenodes
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
if {$opt(seed) > 0} {
    puts "Seeding Random number generator with $opt(seed)\n"
    ns-random $opt(seed)
}

#Ganho das antenas
Antenna/OmniAntenna set Gt_ 18.0
Antenna/OmniAntenna set Gr_ 18.0

Phy/WirelessPhy set bandwidth_ 11Mb

# frequencia (2.4 GHz 802.11b) {Alcance = 276 metros}
Phy/WirelessPhy set freq_ 2.4e+9

Mac/802_11 set dataRate_ 11Mb
Mac/802_11 set basicRate_ 2Mb

#Propagation/Shadowing set pathlossExp_ 2.7       ;#expoente de perdas
#Propagation/Shadowing set std_db_ 4.0           ;#desvio padrao (dB)
Propagation/TwoRayGround set L_ 1.0

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
$node_(3) set X_ 340.0   
$node_(3) set Y_ 226.0
$node_(3) set Z_ 15.0
$ns_ at 50.84371277004266 "$node_(3) setdest 72.2254137768573 16.425095012655156 1.122461504240267"
$ns_ at 299.1794864916592 "$node_(3) setdest 72.2254137768573 196.2176914975688 1.3124401286585718"
$ns_ at 481.02776457394975 "$node_(3) setdest 72.2254137768573 199.6662893841047 0.9286955058320291"
$node_(4) set X_ 270.0 
$node_(4) set Y_ 32.0
$node_(4) set Z_ 15.0
$ns_ at 21.474008839486032 "$node_(4) setdest 56.46793112624701 86.43922217001231 1.3653402811527005"
$ns_ at 152.19786497563382 "$node_(4) setdest 56.46793112624701 28.572101435944454 0.5417954470542897"
$ns_ at 277.8016258521325 "$node_(4) setdest 56.46793112624701 75.46641521122834 1.3579870830833505"
$ns_ at 431.90503409358644 "$node_(4) setdest 180.24108182577092 75.46641521122834 1.2700392384476256"
$ns_ at 539.1566477499346 "$node_(4) setdest 180.24108182577092 76.08296658313748 0.7310721846788227"
$node_(5) set X_ 476.0  
$node_(5) set Y_ 200.0
$node_(5) set Z_ 15.0
$ns_ at 0.0 "$node_(5) setdest 198.04086336017716 89.33000316750005 0.5073315251244088"
$ns_ at 166.2527155284156 "$node_(5) setdest 34.31850371408481 89.33000316750005 0.6586057246088594"
$ns_ at 435.9034258533138 "$node_(5) setdest 161.67917567830796 89.33000316750005 1.2234857199503482"
$node_(6) set X_ 628.0 
$node_(6) set Y_ 320.0
$node_(6) set Z_ 15.0
$ns_ at 0.0 "$node_(6) setdest 90.60701875803875 18.54223342068041 0.8562250390599586"
$ns_ at 52.35907082813765 "$node_(6) setdest 19.770666077785496 18.54223342068041 1.170685330228862"
$ns_ at 149.128505294359 "$node_(6) setdest 17.228842593124885 18.54223342068041 1.003321995398777"
$ns_ at 184.49359948942947 "$node_(6) setdest 17.228842593124885 54.61758622624568 1.0967137243868208"
$ns_ at 231.8997642610516 "$node_(6) setdest 17.228842593124885 17.155998942113495 1.0533424407218261"
$ns_ at 320.04552859209707 "$node_(6) setdest 17.228842593124885 135.66759402003433 1.4489431420405554"
$ns_ at 420.5397231171987 "$node_(6) setdest 17.228842593124885 177.1676623193776 1.3677421622727648"
$ns_ at 486.0753434565331 "$node_(6) setdest 96.97724029346823 177.1676623193776 1.478885593569999"
$node_(7) set X_ 570.0 
$node_(7) set Y_ 440.0
$node_(7) set Z_ 15.0
$ns_ at 50.665232363452105 "$node_(7) setdest 94.30387518592606 54.43282777841653 1.1896633036995914"
$ns_ at 162.14790012506273 "$node_(7) setdest 94.30387518592606 110.03559775519312 1.4142970873548821"
$ns_ at 243.74604796581343 "$node_(7) setdest 94.30387518592606 186.29938839435667 1.195575708010612"
$ns_ at 311.2204584829178 "$node_(7) setdest 94.30387518592606 204.70452342669182 0.5643942142729974"
$ns_ at 444.11562602439653 "$node_(7) setdest 77.23019740145509 204.70452342669182 0.7929578690375596"
$ns_ at 479.9588721300306 "$node_(7) setdest 77.23019740145509 190.6207203554785 0.7605014535666356"
$node_(8) set X_ 780.0 
$node_(8) set Y_ 480.0
$node_(8) set Z_ 15.0
$ns_ at 0.0 "$node_(8) setdest 33.10619275593271 122.6998717278056 0.5447715506193412"
$ns_ at 145.84709845846737 "$node_(8) setdest 200.43252557991056 122.6998717278056 1.246865602593765"
$ns_ at 377.0690550707368 "$node_(8) setdest 200.43252557991056 179.33746857318903 1.1658378370580313"
$ns_ at 481.3314239306551 "$node_(8) setdest 202.24218385328496 179.33746857318903 1.238453836023316"
$ns_ at 525.5336668789723 "$node_(8) setdest 191.26820937085805 179.33746857318903 0.7585871547832386"
$node_(9) set X_ 918.0 
$node_(9) set Y_ 597.0
$node_(9) set Z_ 15.0
$ns_ at 13.251598236868631 "$node_(9) setdest 159.69117351457916 95.5214692738075 1.4747900857615928"
$ns_ at 122.81225897137574 "$node_(9) setdest 170.77927246670322 95.5214692738075 0.6652257564830415"
$ns_ at 213.53326096711908 "$node_(9) setdest 170.77927246670322 69.02137414270848 1.336578020564226"
$ns_ at 264.36983910531035 "$node_(9) setdest 27.73013173260378 69.02137414270848 0.6832941400774363"
$ns_ at 482.3858779321081 "$node_(9) setdest 27.73013173260378 43.92600315528427 0.9309576696361932"
$ns_ at 512.6533114127533 "$node_(9) setdest 56.87058210570066 43.92600315528427 1.0655933818139391"
$node_(10) set X_ 968.0 
$node_(10) set Y_ 550.0
$node_(10) set Z_ 15.0
$ns_ at 0.0 "$node_(10) setdest 144.89613030104962 75.73686636998673 0.8597953954371824"
$ns_ at 93.20840792100898 "$node_(10) setdest 144.89613030104962 204.97828167026563 1.3040787622069412"
$ns_ at 242.71361919635729 "$node_(10) setdest 188.05471191706312 204.97828167026563 1.4723202180685602"
$ns_ at 309.9077781613905 "$node_(10) setdest 188.05471191706312 132.36091784549632 1.1092367165554398"
$ns_ at 429.82407898777547 "$node_(10) setdest 188.05471191706312 72.95521639150721 0.5391895153515236"
###############################################################################################################
# cores
$ns_ color 1 red
$ns_ color 2 blue
$ns_ color 3 yellow

# setup UDP connection
set udp [new Agent/UDP]
$udp set class_ 1
set null [new Agent/Null]
$ns_ attach-agent $node_(1) $udp
$ns_ attach-agent $node_(10) $null
$ns_ connect $udp $null
$udp set fid_ 1

set cbr [new Application/Traffic/CBR]
$cbr set packetSize_ 40     # RTP + UDP + Payload
$cbr set rate_ 8Kb
$cbr attach-agent $udp
$ns_ at 5.0 "$cbr start"
$ns_ at 45.0  "$cbr stop"

set udp1 [new Agent/UDP]
$udp1 set class_ 2
set null1 [new Agent/Null]
$ns_ attach-agent $node_(10) $udp1
$ns_ attach-agent $node_(1) $null1
$ns_ connect $udp1 $null1
$udp1 set fid_ 2

set cbr1 [new Application/Traffic/CBR]
$cbr1 set packetSize_ 40     # RTP + UDP + Payload
$cbr1 set rate_ 8Kb
$cbr1 attach-agent $udp1
$ns_ at 5.0 "$cbr1 start"
$ns_ at 45.0  "$cbr1 stop"

set udp2 [new Agent/UDP]
$udp2 set class_ 3
set null2 [new Agent/Null]
$ns_ attach-agent $node_(5) $udp2
$ns_ attach-agent $node_(1) $null2
$ns_ connect $udp2 $null2
$udp2 set fid_ 3

set cbr2 [new Application/Traffic/CBR]
$cbr2 set packetSize_ 40     # RTP + UDP + Payload
$cbr2 set rate_ 8Kb
$cbr2 attach-agent $udp2
$ns_ at 7.0 "$cbr2 start"
$ns_ at 45.0  "$cbr2 stop"

set udp3 [new Agent/UDP]
$udp3 set class_ 4
set null3 [new Agent/Null]
$ns_ attach-agent $node_(1) $udp3
$ns_ attach-agent $node_(5) $null3
$ns_ connect $udp3 $null3
$udp3 set fid_ 4

set cbr3 [new Application/Traffic/CBR]
$cbr3 set packetSize_ 40     # RTP + UDP + Payload
$cbr3 set rate_ 8Kb
$cbr3 attach-agent $udp3
$ns_ at 7.0 "$cbr3 start"
$ns_ at 45.0  "$cbr3 stop"

set udp4 [new Agent/UDP]
$udp4 set class_ 5
set null4 [new Agent/Null]
$ns_ attach-agent $node_(5) $udp4
$ns_ attach-agent $node_(9) $null4
$ns_ connect $udp4 $null4
$udp4 set fid_ 5

set cbr4 [new Application/Traffic/CBR]
$cbr4 set packetSize_ 40     # RTP + UDP + Payload
$cbr4 set rate_ 8Kb
$cbr4 attach-agent $udp4
$ns_ at 9.0 "$cbr4 start"
$ns_ at 45.0  "$cbr4 stop"

set udp5 [new Agent/UDP]
$udp5 set class_ 6
set null5 [new Agent/Null]
$ns_ attach-agent $node_(9) $udp5
$ns_ attach-agent $node_(5) $null5
$ns_ connect $udp5 $null5
$udp5 set fid_ 6

set cbr5 [new Application/Traffic/CBR]
$cbr5 set packetSize_ 40     # RTP + UDP + Payload
$cbr5 set rate_ 8Kb
$cbr5 attach-agent $udp5
$ns_ at 9.0 "$cbr5 start"
$ns_ at 45.0  "$cbr5 stop"

set udp6 [new Agent/UDP]
$udp6 set class_ 7
set null6 [new Agent/Null]
$ns_ attach-agent $node_(2) $udp6
$ns_ attach-agent $node_(9) $null6
$ns_ connect $udp6 $null6
$udp6 set fid_ 7

set cbr6 [new Application/Traffic/CBR]
$cbr6 set packetSize_ 40     # RTP + UDP + Payload
$cbr6 set rate_ 8Kb
$cbr6 attach-agent $udp6
$ns_ at 11.0 "$cbr6 start"
$ns_ at 45.0  "$cbr6 stop"

set udp7 [new Agent/UDP]
$udp7 set class_ 8
set null7 [new Agent/Null]
$ns_ attach-agent $node_(9) $udp7
$ns_ attach-agent $node_(2) $null7
$ns_ connect $udp7 $null7
$udp7 set fid_ 8

set cbr7 [new Application/Traffic/CBR]
$cbr7 set packetSize_ 40     # RTP + UDP + Payload
$cbr7 set rate_ 8Kb
$cbr7 attach-agent $udp7
$ns_ at 11.0 "$cbr7 start"
$ns_ at 45.0  "$cbr7 stop"

set udp8 [new Agent/UDP]
$udp8 set class_ 9
set null8 [new Agent/Null]
$ns_ attach-agent $node_(3) $udp8
$ns_ attach-agent $node_(8) $null8
$ns_ connect $udp8 $null8
$udp8 set fid_ 9

set cbr8 [new Application/Traffic/CBR]
$cbr8 set packetSize_ 40     # RTP + UDP + Payload
$cbr8 set rate_ 8Kb
$cbr8 attach-agent $udp8
$ns_ at 13.0 "$cbr8 start"
$ns_ at 45.0  "$cbr8 stop"

set udp9 [new Agent/UDP]
$udp9 set class_ 10
set null9 [new Agent/Null]
$ns_ attach-agent $node_(8) $udp9
$ns_ attach-agent $node_(3) $null9
$ns_ connect $udp9 $null9
$udp9 set fid_ 10

set cbr9 [new Application/Traffic/CBR]
$cbr9 set packetSize_ 40     # RTP + UDP + Payload
$cbr9 set rate_ 8Kb
$cbr9 attach-agent $udp9
$ns_ at 13.0 "$cbr9 start"
$ns_ at 45.0  "$cbr9 stop"

set udp10 [new Agent/UDP]
$udp10 set class_ 11
set null10 [new Agent/Null]
$ns_ attach-agent $node_(2) $udp10
$ns_ attach-agent $node_(3) $null10
$ns_ connect $udp10 $null10
$udp10 set fid_ 11

set cbr10 [new Application/Traffic/CBR]
$cbr10 set packetSize_ 40     # RTP + UDP + Payload
$cbr10 set rate_ 8Kb
$cbr10 attach-agent $udp10
$ns_ at 15.0 "$cbr10 start"
$ns_ at 45.0  "$cbr10 stop"

set udp11 [new Agent/UDP]
$udp11 set class_ 12
set null11 [new Agent/Null]
$ns_ attach-agent $node_(3) $udp11
$ns_ attach-agent $node_(2) $null11
$ns_ connect $udp11 $null11
$udp11 set fid_ 12

set cbr11 [new Application/Traffic/CBR]
$cbr11 set packetSize_ 40     # RTP + UDP + Payload
$cbr11 set rate_ 8Kb
$cbr11 attach-agent $udp11
$ns_ at 15.0 "$cbr11 start"
$ns_ at 45.0  "$cbr11 stop"

#
# configurando trafego de background - pareto
#
# DI -> LABS
set tcp [new Agent/TCP]
$tcp set class_ 13
set sink [new Agent/TCPSink]
$ns_ attach-agent $node_(2) $tcp
$ns_ attach-agent $node_(8) $sink
$ns_ connect $tcp $sink
$tcp set fid_ 13

set p [new Application/Traffic/Pareto]
$p set packetSize_ 210
$p set burst_time_ 500ms
$p set idle_time_ 500ms
$p set rate_ 200k
$p set shape_ 1.5
$p attach-agent $tcp
$ns_ at 6.0 "$p start"
$ns_ at 35.0  "$p stop"

set tcp1 [new Agent/TCP]
$tcp1 set class_ 14
set sink1 [new Agent/TCPSink]
$ns_ attach-agent $node_(4) $tcp1
$ns_ attach-agent $node_(9) $sink1
$ns_ connect $tcp1 $sink1
$tcp1 set fid_ 14

set p1 [new Application/Traffic/Pareto]
$p1 set packetSize_ 210
$p1 set burst_time_ 500ms
$p1 set idle_time_ 500ms
$p1 set rate_ 200k
$p1 set shape_ 1.5
$p1 attach-agent $tcp1
$ns_ at 8.0 "$p1 start"
$ns_ at 35.0  "$p1 stop"

set tcp2 [new Agent/TCP]
$tcp2 set class_ 15
set sink2 [new Agent/TCPSink]
$ns_ attach-agent $node_(3) $tcp2
$ns_ attach-agent $node_(10) $sink2
$ns_ connect $tcp2 $sink2
$tcp2 set fid_ 15

set p2 [new Application/Traffic/Pareto]
$p2 set packetSize_ 210
$p2 set burst_time_ 500ms
$p2 set idle_time_ 500ms
$p2 set rate_ 200k
$p2 set shape_ 1.5
$p2 attach-agent $tcp2
$ns_ at 10.0 "$p2 start"
$ns_ at 35.0  "$p2 stop"


## Label the Special Node in NAM
$ns_ at 0.0 "$node_(1) label Nitish"
$ns_ at 0.0 "$node_(2) label Paul"
$ns_ at 0.0 "$node_(3) label SD"
$ns_ at 0.0 "$node_(4) label Nikhil"
$ns_ at 0.0 "$node_(5) label Anirudha"
$ns_ at 0.0 "$node_(6) label Imaran"
$ns_ at 0.0 "$node_(7) label Abhijeet"
$ns_ at 0.0 "$node_(8) label Nandan"
$ns_ at 0.0 "$node_(9) label Aditya"
$ns_ at 0.0 "$node_(10) label Neeraj"

#
# print (in the trace file) routing table and other
# internal data structures on a per-node basis
#
$ns_ at 5.0 "[$node_(1) agent 255] print_rtable"
$ns_ at 5.0 "[$node_(2) agent 255] print_rtable"
$ns_ at 5.0 "[$node_(3) agent 255] print_rtable"
$ns_ at 5.0 "[$node_(4) agent 255] print_rtable"
$ns_ at 5.0 "[$node_(5) agent 255] print_rtable"
$ns_ at 5.0 "[$node_(6) agent 255] print_rtable"
$ns_ at 5.0 "[$node_(7) agent 255] print_rtable"
$ns_ at 5.0 "[$node_(8) agent 255] print_rtable"
$ns_ at 5.0 "[$node_(9) agent 255] print_rtable"
$ns_ at 5.0 "[$node_(10) agent 255] print_rtable"
$ns_ at 5.0 "[$node_(1) agent 255] print_linkset"
$ns_ at 5.0 "[$node_(1) agent 255] print_nbset"
$ns_ at 5.0 "[$node_(1) agent 255] print_nb2hopset"
$ns_ at 5.0 "[$node_(1) agent 255] print_mprset"
$ns_ at 5.0 "[$node_(1) agent 255] print_mprselset"
$ns_ at 5.0 "[$node_(1) agent 255] print_topologyset"

######################################################################

$ns_ at 5.0 "[$node_(1) agent 255] print_rtable"
$ns_ at 5.0 "[$node_(2) agent 255] print_rtable"
$ns_ at 5.0 "[$node_(3) agent 255] print_rtable"
$ns_ at 5.0 "[$node_(4) agent 255] print_rtable"
$ns_ at 5.0 "[$node_(5) agent 255] print_rtable"
$ns_ at 5.0 "[$node_(6) agent 255] print_rtable"
$ns_ at 5.0 "[$node_(7) agent 255] print_rtable"
$ns_ at 5.0 "[$node_(8) agent 255] print_rtable"
$ns_ at 5.0 "[$node_(9) agent 255] print_rtable"
$ns_ at 5.0 "[$node_(10) agent 255] print_rtable"

$ns_ at 5.0 "[$node_(1) agent 255] print_linkset"
$ns_ at 5.0 "[$node_(2) agent 255] print_linkset"
$ns_ at 5.0 "[$node_(3) agent 255] print_linkset"
$ns_ at 5.0 "[$node_(4) agent 255] print_linkset"
$ns_ at 5.0 "[$node_(5) agent 255] print_linkset"
$ns_ at 5.0 "[$node_(6) agent 255] print_linkset"
$ns_ at 5.0 "[$node_(7) agent 255] print_linkset"
$ns_ at 5.0 "[$node_(8) agent 255] print_linkset"
$ns_ at 5.0 "[$node_(9) agent 255] print_linkset"
$ns_ at 5.0 "[$node_(10) agent 255] print_linkset"

$ns_ at 5.0 "[$node_(1) agent 255] print_nbset"
$ns_ at 5.0 "[$node_(2) agent 255] print_nbset"
$ns_ at 5.0 "[$node_(3) agent 255] print_nbset"
$ns_ at 5.0 "[$node_(4) agent 255] print_nbset"
$ns_ at 5.0 "[$node_(5) agent 255] print_nbset"
$ns_ at 5.0 "[$node_(6) agent 255] print_nbset"
$ns_ at 5.0 "[$node_(7) agent 255] print_nbset"
$ns_ at 5.0 "[$node_(8) agent 255] print_nbset"
$ns_ at 5.0 "[$node_(9) agent 255] print_nbset"
$ns_ at 5.0 "[$node_(10) agent 255] print_nbset"

$ns_ at 5.0 "[$node_(1) agent 255] print_nb2hopset"
$ns_ at 5.0 "[$node_(2) agent 255] print_nb2hopset"
$ns_ at 5.0 "[$node_(3) agent 255] print_nb2hopset"
$ns_ at 5.0 "[$node_(4) agent 255] print_nb2hopset"
$ns_ at 5.0 "[$node_(5) agent 255] print_nb2hopset"
$ns_ at 5.0 "[$node_(6) agent 255] print_nb2hopset"
$ns_ at 5.0 "[$node_(7) agent 255] print_nb2hopset"
$ns_ at 5.0 "[$node_(8) agent 255] print_nb2hopset"
$ns_ at 5.0 "[$node_(9) agent 255] print_nb2hopset"
$ns_ at 5.0 "[$node_(10) agent 255] print_nb2hopset"

$ns_ at 5.0 "[$node_(1) agent 255] print_mprset"
$ns_ at 5.0 "[$node_(2) agent 255] print_mprset"
$ns_ at 5.0 "[$node_(3) agent 255] print_mprset"
$ns_ at 5.0 "[$node_(4) agent 255] print_mprset"
$ns_ at 5.0 "[$node_(5) agent 255] print_mprset"
$ns_ at 5.0 "[$node_(6) agent 255] print_mprset"
$ns_ at 5.0 "[$node_(7) agent 255] print_mprset"
$ns_ at 5.0 "[$node_(8) agent 255] print_mprset"
$ns_ at 5.0 "[$node_(9) agent 255] print_mprset"
$ns_ at 5.0 "[$node_(10) agent 255] print_mprset"

$ns_ at 5.0 "[$node_(1) agent 255] print_mprselset"
$ns_ at 5.0 "[$node_(2) agent 255] print_mprselset"
$ns_ at 5.0 "[$node_(3) agent 255] print_mprselset"
$ns_ at 5.0 "[$node_(4) agent 255] print_mprselset"
$ns_ at 5.0 "[$node_(5) agent 255] print_mprselset"
$ns_ at 5.0 "[$node_(6) agent 255] print_mprselset"
$ns_ at 5.0 "[$node_(7) agent 255] print_mprselset"
$ns_ at 5.0 "[$node_(8) agent 255] print_mprselset"
$ns_ at 5.0 "[$node_(9) agent 255] print_mprselset"
$ns_ at 5.0 "[$node_(10) agent 255] print_mprselset"

$ns_ at 5.0 "[$node_(1) agent 255] print_topologyset"
$ns_ at 5.0 "[$node_(2) agent 255] print_topologyset"
$ns_ at 5.0 "[$node_(3) agent 255] print_topologyset"
$ns_ at 5.0 "[$node_(4) agent 255] print_topologyset"
$ns_ at 5.0 "[$node_(5) agent 255] print_topologyset"
$ns_ at 5.0 "[$node_(6) agent 255] print_topologyset"
$ns_ at 5.0 "[$node_(7) agent 255] print_topologyset"
$ns_ at 5.0 "[$node_(8) agent 255] print_topologyset"
$ns_ at 5.0 "[$node_(9) agent 255] print_topologyset"
$ns_ at 5.0 "[$node_(10) agent 255] print_topologyset"

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
