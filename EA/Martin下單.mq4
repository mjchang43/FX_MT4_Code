//+------------------------------------------------------------------+
//|                                                     Martin下單.mq4 |
//|                        Copyright 2015, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2015, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
//--- input parameters
input bool     buy=false;
//--- parameters
int            ticket,ticket2nd;
int            flag = 0;
int            flag2nd = 0;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
      Alert(Symbol()," 場上沒單,即將離開戰場!");
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
      if(buy && flag == 0)
      {
         ticket = OrderSend(NULL,OP_BUY,0.01,Ask,1,Ask-40*Point,Ask+10*Point,"martin ea",0,0,clrBlue);
         if(ticket < 0)
            Alert(Symbol()," ",ticket," Orderbuy failed with error #",GetLastError());
         else
            flag = 1;
      }
      else if(!buy && flag == 0)
      {
         ticket = OrderSend(NULL,OP_SELL,0.01,Bid,1,Bid+40*Point,Bid-10*Point,"martin ea",0,0,clrBlue);
         if(ticket < 0)
            Alert(Symbol()," ",ticket," Ordersell failed with error #",GetLastError());
         else
            flag = 1;
      }
      if(OrderSelect(ticket,SELECT_BY_TICKET) && buy)
      {
        if(Ask <= OrderOpenPrice()-20*Point && flag2nd == 0)
        {
            ticket2nd = OrderSend(NULL,OP_BUY,0.01,Ask,1,OrderStopLoss(),OrderTakeProfit(),"martin ea2",0,0,clrBlue);
            if(ticket2nd < 0)
               Alert(Symbol()," ",ticket2nd," Orderbuy failed with error #",GetLastError());
            else
               flag2nd = 1;
         }
      }
      else if(OrderSelect(ticket,SELECT_BY_TICKET) && !buy)
      {
         if(Bid >= OrderOpenPrice()+20*Point && flag2nd == 0)
        {
            ticket2nd = OrderSend(NULL,OP_SELL,0.01,Bid,1,OrderStopLoss(),OrderTakeProfit(),"martin ea2",0,0,clrBlue);
            if(ticket2nd < 0)
               Alert(Symbol()," ",ticket2nd," Orderbuy failed with error #",GetLastError());
            else
               flag2nd = 1;
         }
      }
      else
         ExpertRemove();
  }
//+------------------------------------------------------------------+
