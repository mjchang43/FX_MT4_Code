//+------------------------------------------------------------------+
//|                                                       止損獲利三十.mq4 |
//|                        Copyright 2015, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2015, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#property script_show_inputs
//--- input parameters
input bool     buy=false;
//--- parameters
int            ticket;
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
//---
      if(buy)
      {
         ticket = OrderSend(NULL,OP_BUY,0.01,Ask,1,Ask-30*Point,0,"script",0,0,clrBlue);
         if(ticket < 0)
            Alert(Symbol()," ",ticket," Orderbuy failed with error #",GetLastError());
         
      }
      else
      {
         ticket = OrderSend(NULL,OP_SELL,0.01,Bid,1,Bid+30*Point,0,"script",0,0,clrBlue);
         if(ticket < 0)
            Alert(Symbol()," ",ticket," Ordersell failed with error #",GetLastError());
      }
  }
//+------------------------------------------------------------------+
