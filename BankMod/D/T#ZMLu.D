BEGIN T#ZMlu

IF ~NumTimesTalkedTo(0)~ THEN BEGIN FirstTimeZhima
SAY @1 
IF~~ THEN REPLY @2 GOTO Poor
END

IF~~ THEN BEGIN Poor
SAY @3
IF~~ THEN REPLY @4 GOTO Services
END

IF~TRUE()~ THEN BEGIN Services					//选择服务
SAY @12
IF~~THEN REPLY @13 GOTO Transfer

IF~Global("T#InvestedTrade","GLOBAL",0)
	Global("T#InvestedMining","GLOBAL",0)~THEN REPLY @11 GOTO Investment	//目前没有投资

//IF~OR(2)Global("T#InvestedTrade","GLOBAL",1)
//	Global("T#InvestedMining","GLOBAL",1)~THEN REPLY @11 GOTO Investmented	//目前已存在一笔投资

IF~Global("T#InvestedTrade","GLOBAL",1)							//未到贸易收益时间
	!GlobalTimerExpired("T#TradeTimer","GLOBAL")~THEN REPLY @11 GOTO NoTradeEarnings

IF~Global("T#InvestedTrade","GLOBAL",1)							//到贸易收益时间，有收益
	GlobalTimerExpired("T#TradeTimer","GLOBAL")
	Global("T#Invsucc1","AR0707",1)~THEN REPLY @11 GOTO TradeSuccesed

IF~Global("T#InvestedTrade","GLOBAL",1)							//到贸易收益时间，无收益
	GlobalTimerExpired("T#TradeTimer","GLOBAL")
	Global("T#Invsucc1","AR0707",2)~THEN REPLY @11 GOTO TradeFailure

IF~Global("T#InvestedMining","GLOBAL",1)							//未到采矿收益时间
	!GlobalTimerExpired("T#MiningTimer","GLOBAL")~ THEN REPLY @11 GOTO NoMiningEarnings

IF~Global("T#InvestedMining","GLOBAL",1)							//到采矿收益时间，有收益
	GlobalTimerExpired("T#MiningTimer","GLOBAL")
	Global("T#Invsucc2","AR0707",1)~THEN REPLY @11 GOTO MiningSuccesed

IF~Global("T#InvestedMining","GLOBAL",1)							//到采矿收益时间，多宝石
	GlobalTimerExpired("T#MiningTimer","GLOBAL")
	Global("T#Invsucc2","AR0707",3)~THEN REPLY @11 GOTO MiningSuccesed1

IF~Global("T#InvestedMining","GLOBAL",1)							//到采矿收益时间，少宝石
	GlobalTimerExpired("T#MiningTimer","GLOBAL")
	Global("T#Invsucc2","AR0707",4)~THEN REPLY @11 GOTO MiningSuccesed2

IF~Global("T#InvestedMining","GLOBAL",1)							//到采矿收益时间，无收益
	GlobalTimerExpired("T#MiningTimer","GLOBAL")
	Global("T#Invsucc2","AR0707",2)~THEN REPLY @11 GOTO MiningFailure


IF~~THEN REPLY @14 GOTO Loan
IF~~THEN REPLY @15 EXIT
END

IF ~~ THEN BEGIN Transfer					//兑换汇票
SAY @5
IF ~PartyHasItem("T#bkscrl")~
      THEN REPLY @6 DO ~TakePartyItemNum("T#bkscrl",1)
			DestroyAllEquipment()
			GiveGoldForce(100000)~ GOTO TransferOver
IF~~ THEN REPLY @7 EXIT
END

IF~~THEN BEGIN TransferOver					//兑换完汇票
SAY @8
IF ~PartyHasItem("T#bkscrl")~
      THEN REPLY @9 GOTO Transfer
IF ~~ THEN REPLY @10 EXIT
END

//投资相关
	//进行投资
IF ~~ THEN BEGIN Investment			//投资
SAY @16
IF~~THEN REPLY @17 GOTO InvestmentChoice1
IF~~THEN REPLY @18 EXIT
END

IF ~~ THEN BEGIN Investmented			//投资
SAY @19
IF~~THEN REPLY @20 EXIT
END

IF~~THEN BEGIN InvestmentChoice1				//投资介绍1贸易
SAY @21
IF~~THEN GOTO InvestmentChoice2
END

IF~~THEN BEGIN InvestmentChoice2				//投资介绍2开矿
SAY @22
IF~~THEN GOTO InvestmentChoice
END

IF~~THEN BEGIN InvestmentChoice					//选择投资
SAY @23
IF~~THEN REPLY @24 GOTO InvestTrade
IF~~THEN REPLY @25 GOTO Mining
IF~~THEN REPLY @26 EXIT
END

IF~~THEN BEGIN InvestTrade					//投资贸易
SAY @27
IF~!PartyGoldGT(99999)~THEN REPLY @28 EXIT
IF~PartyGoldGT(99999)~THEN REPLY @29
	DO ~	TakePartyGold(100000)
		DestroyGold(100000) 
		SetGlobal("T#InvestedTrade","GLOBAL",1)
		SetGlobalTimer("T#TradeTimer","GLOBAL",TEN_DAYS)~EXIT
IF~~THEN REPLY @30 EXIT
END

	//投资贸易收益

IF~~THEN BEGIN NoTradeEarnings	//暂时没有收益
SAY @31
IF~~THEN REPLY @20 EXIT
END

IF~~THEN BEGIN TradeSuccesed 	//贸易成功
SAY @32
IF~~THEN REPLY @33 DO~GiveGoldForce(150000) 
					SetGlobal("T#InvestedTrade","GLOBAL",0)
					SetGlobal("T#Invsucc1","AR0707",0)~EXIT
END

IF~~THEN BEGIN TradeFailure//贸易失败
SAY @34
IF~~THEN REPLY @35 
DO~	SetGlobal("T#InvestedTrade","GLOBAL",0)
	SetGlobal("T#Invsucc1","AR0707",0)~EXIT
END

IF~~THEN BEGIN Mining						//投资采矿	
SAY @36
IF~!PartyGoldGT(99999)~THEN REPLY @28 EXIT
IF~PartyGoldGT(99999)~THEN REPLY @29
	DO ~	TakePartyGold(100000)
		DestroyGold(100000) 
		SetGlobal("T#InvestedMining","GLOBAL",1)
		SetGlobalTimer("T#MiningTimer","GLOBAL",ONE_DAY)~EXIT
IF~~THEN REPLY @30 EXIT
END

	//投资采矿收益

IF~~THEN BEGIN NoMiningEarnings					//暂时没有收益
SAY @37
IF~~THEN REPLY @20 EXIT
END

IF~~THEN BEGIN MiningSuccesed 					//采矿成功
SAY @38
IF~~THEN REPLY @39 DO~GiveGoldForce(180000) 
					SetGlobal("T#InvestedMining","GLOBAL",0)
					SetGlobal("T#Invsucc2","AR0707",0)~EXIT
END

IF~~THEN BEGIN MiningSuccesed1					//采矿成功，多宝石
SAY @40 
IF~~THEN REPLY @39 DO~GiveGoldForce(180000) 
				 GiveItemCreate("misc45",Player1,2,1,1)
				 GiveItemCreate("T#Mithra",Player1,2,1,1)
					SetGlobal("T#InvestedMining","GLOBAL",0)
					SetGlobal("T#Invsucc2","AR0707",0)~EXIT
END

IF~~THEN BEGIN MiningSuccesed2					//采矿成功，少宝石
SAY @40 
IF~~THEN REPLY @39 DO~GiveGoldForce(180000) 
				 GiveItemCreate("misc45",Player1,1,1,1)
				 GiveItemCreate("T#Mithra",Player1,1,1,1)
					SetGlobal("T#InvestedMining","GLOBAL",0)
					SetGlobal("T#Invsucc2","AR0707",0)~EXIT
END

IF~~THEN BEGIN MiningFailure					//采矿失败
SAY @41
IF~~THEN REPLY @35 
DO~	SetGlobal("T#InvestedMining","GLOBAL",0)
	SetGlobal("T#Invsucc2","AR0707",0)~EXIT
END

IF~~THEN BEGIN Loan						//贷款
SAY @42
IF~~THEN REPLY @43 EXIT
END