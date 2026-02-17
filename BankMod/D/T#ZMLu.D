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
SAY ~你需要办理什么业务？兑换汇票、投资或者贷款？~
IF~~THEN REPLY~我要兑换汇票~GOTO Transfer

IF~Global("T#InvestedTrade","GLOBAL",0)
	Global("T#InvestedMining","GLOBAL",0)~THEN REPLY~我要看看投资服务。~GOTO Investment	//目前没有投资

//IF~OR(2)Global("T#InvestedTrade","GLOBAL",1)
//	Global("T#InvestedMining","GLOBAL",1)~THEN REPLY~我要看看投资服务。~GOTO Investmented	//目前已存在一笔投资

IF~Global("T#InvestedTrade","GLOBAL",1)							//未到贸易收益时间
	!GlobalTimerExpired("T#TradeTimer","GLOBAL")~THEN REPLY~我要领取我的投资收益。~ GOTO NoTradeEarnings

IF~Global("T#InvestedTrade","GLOBAL",1)							//到贸易收益时间，有收益
	GlobalTimerExpired("T#TradeTimer","GLOBAL")
	Global("T#Invsucc1","AR0707",1)~THEN REPLY~我要领取我的投资收益。~ GOTO TradeSuccesed

IF~Global("T#InvestedTrade","GLOBAL",1)							//到贸易收益时间，无收益
	GlobalTimerExpired("T#TradeTimer","GLOBAL")
	Global("T#Invsucc1","AR0707",2)~THEN REPLY~我要领取我的投资收益。~ GOTO TradeFailure

IF~Global("T#InvestedMining","GLOBAL",1)							//未到采矿收益时间
	!GlobalTimerExpired("T#MiningTimer","GLOBAL")~THEN REPLY~我要领取我的投资收益。~ GOTO NoMiningEarnings

IF~Global("T#InvestedMining","GLOBAL",1)							//到采矿收益时间，有收益
	GlobalTimerExpired("T#MiningTimer","GLOBAL")
	Global("T#Invsucc2","AR0707",1)~THEN REPLY~我要领取我的投资收益。~ GOTO MiningSuccesed

IF~Global("T#InvestedMining","GLOBAL",1)							//到采矿收益时间，多宝石
	GlobalTimerExpired("T#MiningTimer","GLOBAL")
	Global("T#Invsucc2","AR0707",3)~THEN REPLY~我要领取我的投资收益。~ GOTO MiningSuccesed1

IF~Global("T#InvestedMining","GLOBAL",1)							//到采矿收益时间，少宝石
	GlobalTimerExpired("T#MiningTimer","GLOBAL")
	Global("T#Invsucc2","AR0707",4)~THEN REPLY~我要领取我的投资收益。~ GOTO MiningSuccesed2

IF~Global("T#InvestedMining","GLOBAL",1)							//到采矿收益时间，无收益
	GlobalTimerExpired("T#MiningTimer","GLOBAL")
	Global("T#Invsucc2","AR0707",2)~THEN REPLY~我要领取我的投资收益。~ GOTO MiningFailure


IF~~THEN REPLY~我需要查询贷款服务。~GOTO Loan
IF~~THEN REPLY~都不需要，只是路过。~EXIT
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
SAY ~看来你也是个有钱人，有兴趣投资么？~
IF~~THEN REPLY~好啊，让我看看有些什么项目值得投资。~GOTO InvestmentChoice1
IF~~THEN REPLY~不用，谢谢。~EXIT
END

IF ~~ THEN BEGIN Investmented			//投资
SAY ~对不起，你目前已经投资过一笔生意了，在这笔投资到期前你不能继续投资。~
IF~~THEN REPLY~好的，我以后再来。~EXIT
END

IF~~THEN BEGIN InvestmentChoice1				//投资介绍1贸易
SAY~你可以选择投资贸易，我们有一支船队运送防具和武器到殖民地马兹提卡，并运回黄金。这项投资十分划算，收益可以达到百分之五十，但是如果遇到海难可能会血本无归，呸，我说这个干嘛，无论如何遇到海难的几率不会太高的。你对这项目投资有兴趣吗，一次性需要投资100000金币，10天后可以领取收益。~
IF~~THEN GOTO InvestmentChoice2
END

IF~~THEN BEGIN InvestmentChoice2				//投资介绍2开矿
SAY~你还可以选择投资采矿，巨魔山区虽然充满危险，但是盛产各种各样的宝石。如果你愿意投资100000金币的话，没有意外的话，15天后就可以获得百分之八十的收益，还有机会得到一些质量上乘的宝石和珍贵的金属。~
IF~~THEN GOTO InvestmentChoice
END

IF~~THEN BEGIN InvestmentChoice					//选择投资
SAY~你想选择哪项投资？一次只能选择一项。~
IF~~THEN REPLY~我想投资贸易。~ GOTO InvestTrade
IF~~THEN REPLY~我想投资采矿。~GOTO Mining
IF~~THEN REPLY~还是算了，再见。~EXIT
END

IF~~THEN BEGIN InvestTrade					//投资贸易
SAY~你要投资与马兹提卡的贸易吗？太好了，一共是100000金币。请在10天后来查询你的收益。~
IF~!PartyGoldGT(99999)~THEN REPLY~等我凑够了钱再来。~EXIT
IF~PartyGoldGT(99999)~THEN REPLY ~这里是100000金币，我十天后再来。~
	DO ~	TakePartyGold(100000)
		DestroyGold(100000) 
		SetGlobal("T#InvestedTrade","GLOBAL",1)
		SetGlobalTimer("T#TradeTimer","GLOBAL",TEN_DAYS)~EXIT
IF~~THEN REPLY~还是算了。~EXIT
END

	//投资贸易收益

IF~~THEN BEGIN NoTradeEarnings	//暂时没有收益
SAY~很遗憾，现在贸易船队还未回港，你需要10天才能领取你的收益。~
IF~~THEN REPLY~好的，我以后再来。~EXIT
END

IF~~THEN BEGIN TradeSuccesed 	//贸易成功
SAY~恭喜你，船队顺利回港了。这是你的本金和收入，一共150000金币。~
IF~~THEN REPLY~谢谢，这笔买卖真不错。~DO~GiveGoldForce(150000) 
					SetGlobal("T#InvestedTrade","GLOBAL",0)
					SetGlobal("T#Invsucc1","AR0707",0)~EXIT
END

IF~~THEN BEGIN TradeFailure//贸易失败
SAY~很遗憾，船队遇到了暴风雨沉没了，本次投资失败。~
IF~~THEN REPLY~我的天，太糟糕了。但是也没有办法，重新来吧。~
DO~	SetGlobal("T#InvestedTrade","GLOBAL",0)
	SetGlobal("T#Invsucc1","AR0707",0)~EXIT
END

IF~~THEN BEGIN Mining						//投资采矿	
SAY~你要投资巨魔森林的矿产么，棒极了。~
IF~!PartyGoldGT(99999)~THEN REPLY~等我凑够了钱再来。~EXIT
IF~PartyGoldGT(99999)~THEN REPLY ~这里是100000金币，我十五天后再来。~
	DO ~	TakePartyGold(100000)
		DestroyGold(100000) 
		SetGlobal("T#InvestedMining","GLOBAL",1)
		SetGlobalTimer("T#MiningTimer","GLOBAL",ONE_DAY)~EXIT
IF~~THEN REPLY~还是算了。~EXIT
END

	//投资采矿收益

IF~~THEN BEGIN NoMiningEarnings					//暂时没有收益
SAY~很遗憾，现在矿上还没传来消息，你需要15天才能领取收益。~
IF~~THEN REPLY~好的，我以后再来。~EXIT
END

IF~~THEN BEGIN MiningSuccesed 					//采矿成功
SAY~这段时间矿井运作很正常，你的收益，一共180000金币，这真是一大笔钱啊。~
IF~~THEN REPLY~谢谢，太好了。~DO~GiveGoldForce(180000) 
					SetGlobal("T#InvestedMining","GLOBAL",0)
					SetGlobal("T#Invsucc2","AR0707",0)~EXIT
END

IF~~THEN BEGIN MiningSuccesed1					//采矿成功，多宝石
SAY~这段时间矿井运作很正常，你的收益，一共180000金币，这真是一大笔钱啊。~
IF~~THEN REPLY~谢谢，太好了。~DO~GiveGoldForce(180000) 
				 GiveItemCreate("misc45",Player1,2,1,1)
				 GiveItemCreate("T#Mithra",Player1,2,1,1)
					SetGlobal("T#InvestedMining","GLOBAL",0)
					SetGlobal("T#Invsucc2","AR0707",0)~EXIT
END

IF~~THEN BEGIN MiningSuccesed2					//采矿成功，少宝石
SAY~这段时间矿井运作很正常，你的收益，一共180000金币，这真是一大笔钱啊。~
IF~~THEN REPLY~谢谢，太好了。~DO~GiveGoldForce(180000) 
				 GiveItemCreate("misc45",Player1,1,1,1)
				 GiveItemCreate("T#Mithra",Player1,1,1,1)
					SetGlobal("T#InvestedMining","GLOBAL",0)
					SetGlobal("T#Invsucc2","AR0707",0)~EXIT
END

IF~~THEN BEGIN MiningFailure					//采矿失败
SAY~很遗憾，矿井被怪物袭击了，很多矿工遇难了。~
IF~~THEN REPLY~我的天，太糟糕了。但是也没有办法，重新来吧。~
DO~	SetGlobal("T#InvestedMining","GLOBAL",0)
	SetGlobal("T#Invsucc2","AR0707",0)~EXIT
END

IF~~THEN BEGIN Loan						//贷款
SAY~对不起，本银行贷款业务目前还未开启。~
IF~~THEN REPLY~哦，再见。~EXIT
END