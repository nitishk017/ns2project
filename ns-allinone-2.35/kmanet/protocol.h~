#include <stdint.h>
#include <trace.h>
#include <classifier-port.h>
#include <agent.h>
#include <packet.h>
#include <timer-handler.h>
#include <random.h>
#include <vector>

#define NODE_ADDRESS 0x00
#define TOTAL_OF_NODE 6 //should be 8,16,32,64 [Max support 64 only]

#define MESSAGE_BYTESIZE 16 // 4 on hello frame, 6 on NBR frame, 6 on MPR frame = 4+6+6=16 bytes

#define DEFAULT_NWK_KEY 0xABCDEFABCDEFABCDEFABCDEFABCDEF01   //128bit AES key encryption
#define BROADCAST_ADDR 0xFF

//CALIBRATED TIME REQUIRE FOR ACTUAL....include software processing overhead
#define ACTUALHELLO_FRAME_TIME 48
#define ACTUALNBRLIST_FRAME_TIME 68
#define ACTUALMPRLIST_FRAME_TIME 68

//******* Frame Transmit Control parameter : refer document before adjusting this ********************
#define HELLO_FRAME_TIME 500//55 //msec
#define HELLO_FRAME_BYTESIZE 10 //bytes

#define NBRLIST_FRAME_TIME 5200//70 //msec
#define NBRLIST_FRAME_BYTESIZE 20 //bytes

#define MPRLIST_FRAME_TIME 500//70 //msec
#define MPRLIST_FRAME_BYTESIZE 20 //bytes
#define HEADER_COMMON_BYTESIZE 6

#define HOP_RANDACCESSWINDOW_TIME 1000 //500 //msec

#define COMMUNICATION_CYCLE_TIME ((HELLO_FRAME_TIME*TOTAL_OF_NODE)+(NBRLIST_FRAME_TIME*TOTAL_OF_NODE)+(MPRLIST_FRAME_TIME*TOTAL_OF_NODE)+HOP_RANDACCESSWINDOW_TIME)
//------------------------------------------------
#define PROTOCOL_VER 0x01

#define HELLO_FRAME   0x00
#define NBRLIST_FRAME 0x01
#define MPRLIST_FRAME 0x02
#define HOP_FRAME     0x03


#define HELLO_WINDOW_STATE  0x00
#define NBR_WINDOW_STATE    0x01
#define MPR_WINDOW_STATE    0x02
#define HOP_WINDOW_STATE    0x03
//--------------------------------------------------------

//*****************##################################******************************************

class KMANET;			// forward declaration

/********** Timers **********/


/// Timer for sending an enqued message.
class KMANET_MsgTimer : public TimerHandler {
public:
	KMANET_MsgTimer(KMANET* agent) : TimerHandler() {
		agent_	= agent;
	}
protected:
	KMANET*	agent_;			///< KMANET agent which created the timer.
	virtual void expire(Event* e);
};

/// Timer for sending HELLO messages.
class KMANET_HelloTimer : public TimerHandler {
public:
	KMANET_HelloTimer(KMANET* agent) : TimerHandler() { agent_ = agent; }
protected:
	KMANET*	agent_;			///< KMANET agent which created the timer.
	virtual void expire(Event* e);
};

typedef struct message
{
    uint8_t SourceNode;
    uint8_t DestinationNode;
    uint8_t MsgSeqNo;
    uint8_t SOS1;
    uint8_t MsgId1; //Predefine 254 msg1 can be send
    uint8_t MsgByte1; // if predefine msg1 has a specific contain
    unsigned long GPSlat; //this time stamp will be synchronize by node 0 i.e node 1 always send 0 only 
    uint8_t MsgId2; //Predefine 254 msg2 can be send
    uint8_t MsgByte2; // if predefine msg2 has a specific contain
    unsigned long GPSlon;

};
typedef union Message
{   
    message format;
    uint8_t rawdata[MESSAGE_BYTESIZE];
};


typedef struct HeaderCommon
{
    uint8_t version:4;
    uint8_t frameType:4;
    unsigned long timeStampRead_msec; //this time stamp will be synchronize by node 0 i.e node 1 always send 0 only 
    uint8_t senderNodeID;  
};
typedef union MAC_headerframe
{   
    HeaderCommon format;
    uint8_t rawdata[HEADER_COMMON_BYTESIZE];
};

//HELLO FRAME DECLARATION
typedef struct machelloformat
{
    uint8_t version:4;
    uint8_t frameType:4;
    unsigned long timeStampRead_msec; //this time stamp will be synchronize by node 0 i.e node 1 always send 0 only 
    uint8_t senderNodeID;
    uint8_t data[4];
};
typedef union MAC_helloframe
{   
    machelloformat format;
    uint8_t rawdata[HELLO_FRAME_BYTESIZE];
};

//NEIGHBOR LIST FRAME DECLARATION
typedef struct macNBRlistformat
{
    uint8_t version:4;
    uint8_t frameType:4;
    unsigned long timeStampRead_msec; //this time stamp will be synchronize by node 0 i.e node 1 always send 0 only 
    uint8_t senderNodeID;
    uint8_t NBRlist[8];
    uint8_t data[6];
};
typedef union MAC_NBRlistframe
{   
    macNBRlistformat format;
    uint8_t rawdata[NBRLIST_FRAME_BYTESIZE];
};

//MPR LIST FRAME DECLARATION
typedef struct macMPRlistformat
{
    uint8_t version:4;
    uint8_t frameType:4;
    unsigned long timeStampRead_msec; //this time stamp will be synchronize by node 0 i.e node 1 always send 0 only 
    uint8_t senderNodeID;
    uint8_t MPRlist[8];
    uint8_t data[6];
};

typedef union MAC_MPRlistframe
{   
    macMPRlistformat format;
    uint8_t rawdata[MPRLIST_FRAME_BYTESIZE];
};

class KMANET : public Agent {
	
	/// Address of the routing agent.
	nsaddr_t	ra_addr_;

	unsigned char myTransmitType;
	unsigned long myNwkCycleRst;
	unsigned long prev_actualHellotxtime;
	unsigned long prev_actualNBRlisttxtime;
	unsigned long prev_actualMPRlisttxtime;
	unsigned long NetworktimeStampRead_msec;
	unsigned long NetworkTimeOffset;
	unsigned long wait_time;
	bool transmitFlag;
	bool receiveNoneFlag;
	bool receiveFlagOnOneCycle;
	bool NetwkTimeSyncFlag;
	//unsigned long myTransmitTime;
	MAC_helloframe txDataMACHelloFrame;
	MAC_helloframe rxDataMACHelloFrame[TOTAL_OF_NODE];
	MAC_NBRlistframe txDataNBRlistFrame;
	MAC_NBRlistframe rxDataNBRlistFrame[TOTAL_OF_NODE];
	MAC_MPRlistframe txDataMPRlistFrame;
	MAC_MPRlistframe rxDataMPRlistFrame[TOTAL_OF_NODE];

protected:

	PortClassifier*	dmux_;		///< For passing packets up to agents.
	Trace*		logtarget_;	///< For logging.
	inline nsaddr_t&	ra_addr()	{ return ra_addr_; }
	void recievepkt(uint8_t * rcvbuf,unsigned long mytimestamp_msec);
	void PackTxradioframe_forSlotted(unsigned long mytimestamp_msec);
	void NetworkDataReset(unsigned long mytimeStampRead_msec);
	void setup_InitialtransmitTime(void);
	void updateNWKtimeStampRead(long unsigned int);
	void updateNetworkTimeOffset(long unsigned int, long unsigned int);

public:
	KMANET(nsaddr_t);
	int command(int, const char*const*);

};
