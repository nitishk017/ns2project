#include "protocol.h"
#include <cstddef>
#include <address.h>
#include <math.h>
#include <limits.h>
#include <ip.h>
#include <cmu-trace.h>
#include <map>

//HELLO FRAME INSTANTIATE 

/*****************************INITLIZATION ******************************/

	unsigned char protocol_state=HELLO_WINDOW_STATE;

	unsigned long myTransmitTime=0;
	unsigned long myNwkCycleRst=COMMUNICATION_CYCLE_TIME;

	unsigned long NetworktimeStampRead_msec=0;
	unsigned long NetworkTimeOffset=0;
	unsigned long timeStampRead_msec=0;

	unsigned long wait_time=0;

	unsigned char myTransmitType;
	unsigned char lastRxNodeID,lastRxFrameType;
	unsigned long lastRxNetworktimeStamp;

	unsigned long prev_actualHellotxtime=(unsigned long)ACTUALHELLO_FRAME_TIME;
	unsigned long prev_actualNBRlisttxtime=(unsigned long)ACTUALNBRLIST_FRAME_TIME;
	unsigned long prev_actualMPRlisttxtime=(unsigned long)ACTUALMPRLIST_FRAME_TIME;
	unsigned long hoprandaccess_window_msec=(unsigned long)HOP_RANDACCESSWINDOW_TIME;

	bool transmitFlag=0;
	bool receiveNoneFlag=1;
	bool receiveFlagOnOneCycle=0;
	bool NetwkTimeSyncFlag=0;

/**********************************************************/


MAC_helloframe txDataMACHelloFrame={
  {
      PROTOCOL_VER,
      HELLO_FRAME,
      NULL, //unsigned long timeStampRead_msec;
      NODE_ADDRESS,
      NULL //uint8_t data[4];
  },
};
MAC_helloframe rxDataMACHelloFrame[TOTAL_OF_NODE]={NULL}; //hello frame from all other nodes receive

//HELLO FRAME INSTANTIATE 

MAC_NBRlistframe txDataNBRlistFrame={
  {
      PROTOCOL_VER,
      NBRLIST_FRAME,
      NULL,//unsigned long timeStampRead_msec;
      NODE_ADDRESS,
      NULL,//NBRlist[8];
      NULL//datat[6];
  },
};
MAC_NBRlistframe rxDataNBRlistFrame[TOTAL_OF_NODE];

//MPR FRAME DATA INSTANTIATE

MAC_MPRlistframe txDataMPRlistFrame={
  {
      PROTOCOL_VER,
      MPRLIST_FRAME,
      NULL,//unsigned long timeStampRead_msec;
      NODE_ADDRESS,
      NULL,//MPRlist[8];
      NULL//data[6]
  },
};
MAC_MPRlistframe rxDataMPRlistFrame[TOTAL_OF_NODE];

/******************KMANET class ****************************/

///
/// \brief Creates necessary timers, binds TCL-available variables and do
/// some more initializations.
/// \param id Identifier for the KMANET agent. It will be used as the address
/// of this routing agent.
///
KMANET::KMANET(nsaddr_t id) :	Agent(PT_KMANET){

	// Do some initializations
	ra_addr_	= id;


}
/***********************************************************/

//Note local timeStampRead is used for calculation 

static class KMANETClass : public TclClass {
public:
	KMANETClass() : TclClass("Agent/KMANET") {	printf("%s %s %d\n",__func__,__FILE__,__LINE__);}
	TclObject* create(int argc, const char*const* argv) {
		// argv has the following structure:
		// <tcl-object> <tcl-object> Agent/KMANET create-shadow <id>
		// e.g: _o17 _o17 Agent/KMANET create-shadow 0
		// argv[4] is the address of the node
		assert(argc == 5);
		return new KMANET((nsaddr_t)Address::instance().str2addr(argv[4]));
	}
} class_rtProtoKMANET;

///
/// \brief Interface with TCL interpreter.
///
/// From your TCL scripts or shell you can invoke commands on this KMANET
/// routing agent thanks to this function. Currently you can call "start",
/// "print_rtable", "print_linkset", "print_nbset", "print_nb2hopset",
/// "print_mprset", "print_mprselset" and "print_topologyset" commands.
///
/// \param argc Number of arguments.
/// \param argv Arguments.
/// \return TCL_OK or TCL_ERROR.
///

int
KMANET::command(int argc, const char*const* argv) {
	printf("%s %s %d\n",__func__,__FILE__,__LINE__);
	if (argc == 2) {
		// Starts all timers
		if (strcasecmp(argv[1], "start") == 0) {
			
			return TCL_OK;
    		}
	}
	else if (argc == 3) {
		// Obtains the corresponding dmux to carry packets to upper layers
		if (strcmp(argv[1], "port-dmux") == 0) {
    			dmux_ = (PortClassifier*)TclObject::lookup(argv[2]);
			if (dmux_ == NULL) {
				fprintf(stderr, "%s: %s lookup of %s failed\n", __FILE__, argv[1], argv[2]);
				return TCL_ERROR;
			}
			return TCL_OK;
    		}
		// Obtains the corresponding tracer
		else if (strcmp(argv[1], "log-target") == 0 || strcmp(argv[1], "tracetarget") == 0) {
			logtarget_ = (Trace*)TclObject::lookup(argv[2]);
			if (logtarget_ == NULL)
				return TCL_ERROR;
			return TCL_OK;
		}
	}  

	// Pass the command up to the base class
	return Agent::command(argc, argv); 
} 

///
/// \brief Sends a HELLO message and reschedules the HELLO timer.
/// \param e The event which has expired.
///
void
KMANET_HelloTimer::expire(Event* e) {
	printf("%s %s %d\n",__func__,__FILE__,__LINE__);
	agent_->send_hello();
	agent_->set_hello_timer();
}   

//***************** utility function *********************************

void clear_Buffer(uint8_t *buf,int len)
{
	printf("%s %s %d\n",__func__,__FILE__,__LINE__);
    for(int i=0;i<len;i++)
    {
       buf[i]=NULL; 
    }
}
void copy_Buffer(uint8_t *srcbuf,uint8_t *destbuf,int len)
{
	printf("%s %s %d\n",__func__,__FILE__,__LINE__);
    for(int i=0;i<len;i++)
    {
       destbuf[i]=srcbuf[i]; 
    }
}

uint8_t decTo8bitfield(uint8_t nodeId0toId7)
{
	printf("%s %s %d\n",__func__,__FILE__,__LINE__);
    switch (nodeId0toId7)
    {
      case 0 : return 1;break;
      case 1 : return 2;break;
      case 2 : return 4;break;
      case 3 : return 8;break;
      case 4 : return 16;break;
      case 5 : return 32;break;
      case 6 : return 64;break;
      case 7 : return 128;break;
      default : return 0;break;
    }  
}

void enterOnNBRorMPRList(uint8_t nodeId,uint8_t *ListPointer)
{
	printf("%s %s %d\n",__func__,__FILE__,__LINE__);
  if(nodeId<8)
  {
    ListPointer[0] |= decTo8bitfield(nodeId);
  }
  else if(nodeId<16)
  {
    ListPointer[1] |= decTo8bitfield(nodeId-8);
  }
  else if(nodeId<24)
  {
    ListPointer[2] |= decTo8bitfield(nodeId-16);
  }
  else if(nodeId<32)
  {
    ListPointer[3] |= decTo8bitfield(nodeId-24);
  }
  else if(nodeId<40)
  {
    ListPointer[4] |= decTo8bitfield(nodeId-32);
  }
  else if(nodeId<48)
  {
    ListPointer[5] |= decTo8bitfield(nodeId-40);
  }
  else if(nodeId<56)
  {
    ListPointer[6] |= decTo8bitfield(nodeId-48);
  }
  else if(nodeId<64)
  {
    ListPointer[7] |= decTo8bitfield(nodeId-56);
  }
}


// **************** timing function and network time syncronization section *****************************

void KMANET::setup_InitialtransmitTime(void)
{
	printf("%s %s %d\n",__func__,__FILE__,__LINE__);
  volatile uint8_t k=0;
  // to reset the network data at begining
  NetworkTimeOffset=0;

  prev_actualHellotxtime=(unsigned long)ACTUALHELLO_FRAME_TIME;
  prev_actualNBRlisttxtime=(unsigned long)ACTUALNBRLIST_FRAME_TIME;
  prev_actualMPRlisttxtime=(unsigned long)ACTUALMPRLIST_FRAME_TIME;
  hoprandaccess_window_msec=(unsigned long)HOP_RANDACCESSWINDOW_TIME;
        
  for(k=0;k<TOTAL_OF_NODE;k++)
  {
    clear_Buffer(rxDataMACHelloFrame[k].rawdata,HELLO_FRAME_BYTESIZE);
    clear_Buffer(rxDataNBRlistFrame[k].rawdata,NBRLIST_FRAME_BYTESIZE);
    clear_Buffer(rxDataMPRlistFrame[k].rawdata,MPRLIST_FRAME_BYTESIZE);
  }
  
  if(txDataMACHelloFrame.format.senderNodeID ==0x00)//control using myTransmit time for only Node 0 to send first radio packet.
  {
    myTransmitTime=0;
   // FlexiTimer2::set(1, transmitInterrupt); //  set the transmission for node 0
   // FlexiTimer2::start();
    
  //  transmitInterrupt();// do first transmit packet in a network
  }
  else
  {
    myTransmitTime=0xFFFFFFFE;
   // FlexiTimer2::set(0xFFFFFFFE, transmitInterrupt); // never start the transmission for node other than node 0
   // FlexiTimer2::start();
  } 
}  




bool update_mynxtTx_onRxHello(unsigned char rxNodeId, unsigned long currentTime_msec)
{
	printf("%s %s %d\n",__func__,__FILE__,__LINE__);

   //  FlexiTimer2::stop(); 
     if(rxNodeId != NODE_ADDRESS )
     {
        if(rxNodeId < NODE_ADDRESS )//still has to transmit HELLO FRAME
        {
          wait_time = (HELLO_FRAME_TIME - ACTUALHELLO_FRAME_TIME) +((NODE_ADDRESS- (rxNodeId+1))*HELLO_FRAME_TIME);
          myTransmitType=HELLO_FRAME;
        }
        else ////Already transmited HELLO FRAME, have to transmit NBRLIST FRAME
        {
          wait_time =(NODE_ADDRESS * NBRLIST_FRAME_TIME) + ((TOTAL_OF_NODE - (rxNodeId+1))*HELLO_FRAME_TIME) + (HELLO_FRAME_TIME - ACTUALHELLO_FRAME_TIME) ;
          myTransmitType=NBRLIST_FRAME;
        }
     }
     else//myNodeID == rxNodeId, issue of wrong configuration or it can also be a reply attack
     {
        wait_time = 0xFFFFFFFE;
        return 1;
     }
     myTransmitTime=currentTime_msec + wait_time;
     
   //  FlexiTimer2::set(wait_time, transmitInterrupt); //  transmission for node 0
   //  FlexiTimer2::start(); 
     //update my network cycle reset timing
     //myNwkCycleRst = (TOTAL_OF_NODE * NBRLIST_FRAME_TIME)+ (TOTAL_OF_NODE * MPRLIST_FRAME_TIME) + HOP_RANDACCESSWINDOW_TIME;
     //myNwkCycleRst += ((TOTAL_OF_NODE - (rxNodeId +1)) * HELLO_FRAME_TIME);
     //myNwkCycleRst += currentTime_msec + (HELLO_FRAME_TIME - ACTUALHELLO_FRAME_TIME); 
     return 0;     
}
bool update_mynxtTx_onRxNBRList(unsigned char rxNodeId, unsigned long currentTime_msec)
{
	printf("%s %s %d\n",__func__,__FILE__,__LINE__);
   //  FlexiTimer2::stop(); 
     if(NODE_ADDRESS != rxNodeId)
     {
        if(NODE_ADDRESS > rxNodeId)//still has to transmit NBRLIST FRAME
        {
          wait_time =((NODE_ADDRESS- (rxNodeId+1))*NBRLIST_FRAME_TIME)+ (NBRLIST_FRAME_TIME - ACTUALNBRLIST_FRAME_TIME) ;
          myTransmitType=NBRLIST_FRAME;
        }
        else ////Already transmited NBRLIST FRAME, have to transmit MPRLIST FRAME
        {
          wait_time =(NBRLIST_FRAME_TIME - ACTUALNBRLIST_FRAME_TIME) + (NODE_ADDRESS * MPRLIST_FRAME_TIME) + ((TOTAL_OF_NODE - (rxNodeId+1))*NBRLIST_FRAME_TIME);
          myTransmitType=MPRLIST_FRAME;
        }
     }
     else//myNodeID == rxNodeId, issue of wrong configuration or it can also be a reply attack
     {
        wait_time = 0xFFFFFFFE;
        return 1;
     }
     myTransmitTime=currentTime_msec + wait_time;
                  
   //  FlexiTimer2::set(wait_time, transmitInterrupt); // 50ms start the transmission for node 0
   //  FlexiTimer2::start();

     //update my network cycle reset timing
     //myNwkCycleRst=currentTime_msec + (NBRLIST_FRAME_TIME - ACTUALNBRLIST_FRAME_TIME) + (((TOTAL_OF_NODE - (rxNodeId+1)) * NBRLIST_FRAME_TIME)) + (TOTAL_OF_NODE * MPRLIST_FRAME_TIME) + HOP_RANDACCESSWINDOW_TIME;
     return 0;
}
bool update_mynxtTx_onRxMPRList(unsigned char rxNodeId, unsigned long currentTime_msec)
{
	printf("%s %s %d\n",__func__,__FILE__,__LINE__);
  //   FlexiTimer2::stop(); 
     if(NODE_ADDRESS != rxNodeId)
     {
        if(NODE_ADDRESS > rxNodeId)//still has to transmit MPRLIST FRAME
        {
          wait_time =(MPRLIST_FRAME_TIME - ACTUALMPRLIST_FRAME_TIME) + ((NODE_ADDRESS- (rxNodeId+1))*MPRLIST_FRAME_TIME);
          myTransmitType=MPRLIST_FRAME;
        }
        else ////Already transmited NBRLIST FRAME, have to transmit HELLO FRAME
        {
          //wait_time =(MPRLIST_FRAME_TIME - ACTUALMPRLIST_FRAME_TIME) + (NODE_ADDRESS * HELLO_FRAME_TIME) + ((TOTAL_OF_NODE - (rxNodeId+1))*MPRLIST_FRAME_TIME) + HOP_RANDACCESSWINDOW_TIME;
          wait_time = 0xFFFFFFFE;
          myTransmitType=HELLO_FRAME;
        }
     }
     else//myNodeID == rxNodeId, issue of wrong configuration or it can also be a reply attack
     {
        wait_time = 0xFFFFFFFE;
        return 1;
     }
     myTransmitTime=currentTime_msec + wait_time;
      
  //   FlexiTimer2::set(wait_time, transmitInterrupt); // 50ms start the transmission for node 0
  //   FlexiTimer2::start();
      
     //update my network cycle reset timing
     //myNwkCycleRst=currentTime_msec + (MPRLIST_FRAME_TIME - ACTUALMPRLIST_FRAME_TIME) + (((TOTAL_OF_NODE - (rxNodeId+1)) * MPRLIST_FRAME_TIME)) + HOP_RANDACCESSWINDOW_TIME; 
     return 0;
}
//************************************############**************************************

void KMANET::NetworkDataReset(unsigned long mytimeStampRead_msec)// this function should be call in the loop directly
{
	printf("%s %s %d\n",__func__,__FILE__,__LINE__);
    unsigned char k,waittime;

    if (mytimeStampRead_msec > myNwkCycleRst)
    {   
        receiveFlagOnOneCycle=0;
        
        
        clear_Buffer(txDataNBRlistFrame.format.NBRlist,8);
        clear_Buffer(txDataMPRlistFrame.format.MPRlist,8);

        //clear all data of network information
        for(k=0;k<TOTAL_OF_NODE;k++)
        {
          clear_Buffer(rxDataMACHelloFrame[k].rawdata,HELLO_FRAME_BYTESIZE);
          clear_Buffer(rxDataNBRlistFrame[k].rawdata,NBRLIST_FRAME_BYTESIZE);
          clear_Buffer(rxDataMPRlistFrame[k].rawdata,MPRLIST_FRAME_BYTESIZE);
        }

        
        #ifdef SERIAL_DEBUG
        printlnSerialDebug("Network Reset");
        #endif
        
        //RedLED_ON();
        myNwkCycleRst=0xFFFFFFFE;//do only once for changes on myNwkCycleRst

        if(txDataMACHelloFrame.format.senderNodeID ==0x00 || receiveNoneFlag==0 )//if node id =0 or atleast recievce one frame
        {
          myTransmitTime=0; //if node ID =0x00, reset for next transmission if no other nodes are present also.

     //     FlexiTimer2::stop();
          wait_time =(NODE_ADDRESS * HELLO_FRAME_TIME);
    //      FlexiTimer2::set(waittime+1, transmitInterrupt); // 50ms start the transmission for node 0
    //      FlexiTimer2::start();
          
        }
        
        //RedLED_OFF();
    }
}

void KMANET::updateNWKtimeStampRead(unsigned long mytimestmp_msec)
{
	printf("%s %s %d\n",__func__,__FILE__,__LINE__);
    NetworktimeStampRead_msec=mytimestmp_msec + NetworkTimeOffset;//update global variable
}

void KMANET::updateNetworkTimeOffset(unsigned long mytimestmp_msec, unsigned long rxNwkTime)// call on every reception of packet
{
	printf("%s %s %d\n",__func__,__FILE__,__LINE__);
    NetworkTimeOffset=mytimestmp_msec - rxNwkTime;//update global variable
}

void KMANET::PackTxradioframe_forSlotted(unsigned long mytimeStampRead_msec)// this function should be call in the loop directly
{
	printf("%s %s %d\n",__func__,__FILE__,__LINE__);
 
        myTransmitTime=0xFFFFFFFE; //do only once for changes on myTransmitTime
        ////insert network time stamp on package 
        
        if(txDataMACHelloFrame.format.senderNodeID == 0x00)//using Node 0 timeStampRead as network timeStampRead
        { 
          NetworktimeStampRead_msec=mytimeStampRead_msec;
          NetworkTimeOffset=0;
          NetwkTimeSyncFlag=1;
        }
        else
        {
          //update Network time offset
          if(receiveFlagOnOneCycle==1)
          {
            //assume network time sync happen on every cycle on Hello frame only, sync happen on edge of transmission time of hello frame.
            if(myTransmitType==HELLO_FRAME && lastRxFrameType== HELLO_FRAME)
            {
              NetworkTimeOffset = mytimeStampRead_msec - (lastRxNetworktimeStamp + (HELLO_FRAME_TIME-ACTUALHELLO_FRAME_TIME)+ ((NODE_ADDRESS-lastRxNodeID)*HELLO_FRAME_TIME));
              NetwkTimeSyncFlag=1;
            }
            
          }

          if(NetwkTimeSyncFlag==1)
              NetworktimeStampRead_msec=mytimeStampRead_msec + NetworkTimeOffset;
          else    
              NetworktimeStampRead_msec=mytimeStampRead_msec;
        }

        //update Frame timeStampRead_msec as updated from above if else
        txDataMACHelloFrame.format.timeStampRead_msec=NetworktimeStampRead_msec;
        txDataNBRlistFrame.format.timeStampRead_msec=NetworktimeStampRead_msec;
        txDataMPRlistFrame.format.timeStampRead_msec=NetworktimeStampRead_msec;

        //field data field from txmessage buffer from a node
        switch (myTransmitType)
        { 
            case HELLO_FRAME: //package the packet 
        //                copy_Buffer(txDataMACHelloFrame.format.data,"hi u",4);
                        myNwkCycleRst=mytimeStampRead_msec + (COMMUNICATION_CYCLE_TIME -(NODE_ADDRESS * HELLO_FRAME_TIME));
                        if(txDataMACHelloFrame.format.senderNodeID != 0x00)
                        {    myNwkCycleRst= myNwkCycleRst + NetworkTimeOffset;
                             if(!NetwkTimeSyncFlag)
                                myNwkCycleRst=0xFFFFFFFE;
                        }    
                        break;
            case NBRLIST_FRAME:
         //               copy_Buffer(txDataNBRlistFrame.format.data,"hi nbr",6);
                        //update MPR List
                        break;
            case MPRLIST_FRAME:
             //           copy_Buffer(txDataMPRlistFrame.format.data,"hi mpr",6);
                        
                        break;
            default:        break;
        }
    

}    


void KMANET::recievepkt(uint8_t * rcvbuf,unsigned long mytimeStampRead_msec)// this function should be call on any radio packet reception only
{
	printf("%s %s %d\n",__func__,__FILE__,__LINE__);
    //parse
    MAC_headerframe rxheader;
    copy_Buffer(rcvbuf,rxheader.rawdata,HEADER_COMMON_BYTESIZE);
    uint8_t rxnodeID;

    rxnodeID=rxheader.format.senderNodeID;
    lastRxNodeID=rxnodeID; //used to sync network time for all node except node 0
    lastRxNetworktimeStamp=rxheader.format.timeStampRead_msec;//used to sync network time for all node except node 0
    lastRxFrameType=rxheader.format.frameType;
    receiveFlagOnOneCycle=1;

    //update neighbor list
    //update txDataNBRlistFrame.format.NBRlist[8];
    enterOnNBRorMPRList(rxnodeID,txDataNBRlistFrame.format.NBRlist);
    //check type and do action
    switch (rxheader.format.frameType)
    { 
        case HELLO_FRAME: 
                          update_mynxtTx_onRxHello(rxnodeID, mytimeStampRead_msec); //update next transmission time
                          //Copy data to Hello buffer Table
                          copy_Buffer(rcvbuf,rxDataMACHelloFrame[rxnodeID].rawdata,HELLO_FRAME_BYTESIZE);
                          //update tx neighbor list on next tx neighbot list packet
                          enterOnNBRorMPRList(rxnodeID,txDataNBRlistFrame.format.NBRlist);
                          receiveNoneFlag=0;
                          break;
        case NBRLIST_FRAME: 
                          update_mynxtTx_onRxNBRList(rxnodeID, mytimeStampRead_msec); //update next transmission time
                          //Copy data to NBRlist buffer Table
                          copy_Buffer(rcvbuf,rxDataNBRlistFrame[rxnodeID].rawdata,NBRLIST_FRAME_BYTESIZE);
                          //receiveNoneFlag=0;
                          break;

        case MPRLIST_FRAME: 
                          update_mynxtTx_onRxMPRList(rxnodeID, mytimeStampRead_msec); //update next transmission time
                          //Copy data to NBRlist buffer Table
                          copy_Buffer(rcvbuf,rxDataMPRlistFrame[rxnodeID].rawdata,MPRLIST_FRAME_BYTESIZE);
                          //receiveNoneFlag=0;
                          break;
        case HOP_FRAME:
        
                //update database.
                break;
        default:    break;
    }        

}

