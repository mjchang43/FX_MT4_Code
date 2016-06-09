//+------------------------------------------------------------------+
//|                                                          try.mq4 |
//|                        Copyright 2014, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2014, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
//---
      if(OrderSelect(65330876,SELECT_BY_TICKET,MODE_HISTORY)){
      
         if(StringFind(OrderSymbol(),"jpy",0)){
         Print(StringFind(OrderSymbol(),"JPY",0)+"!!");
         }
      }else{
      Print("Ticket not found");
      }
      Print(TimeCurrent());
      Print(Hour());
      Print(Minute());
      if(OrderSelect(0,SELECT_BY_POS,MODE_TRADES))
      {
         Print(OrderTicket() + "==" + OrderOpenTime());
         Print(iBarShift(NULL,PERIOD_H4,OrderOpenTime()));
      }
  }
//+------------------------------------------------------------------+
