BEGIN T#JSRain

IF ~NumTimesTalkedTo(0)~ THEN BEGIN FirstTimeBEAST

SAY @1
IF~~ THEN REPLY @2 GOTO Banking
END

IF ~True()~ THEN BEGIN Banking
SAY @3
IF~PartyGoldGT(104999)~ THEN REPLY @4 DO ~TakePartyGold(105000) DestroyGold(105000) GiveItemCreate("T#bkscrl",Player1,1,1,1) ~GOTO Thanks
IF~~ THEN REPLY ~不用了，再见。~EXIT
END

IF~~THEN BEGIN Thanks
SAY @5
IF ~PartyGoldGT(99999)~
      THEN REPLY @6 GOTO Banking
IF ~~ THEN REPLY @7 EXIT
END
