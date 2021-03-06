//+------------------------------------------------------------------+
//|                                                     H1KD反轉平倉.mq4 |
//|                        Copyright 2014, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2014, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
//--- input parameters
input int      Input1=0;
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
   
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
   if((iStochastic(NULL,PERIOD_H1,13,5,8,MODE_SMA,0,MODE_MAIN,1) > iStochastic(NULL,PERIOD_H1,13,5,8,MODE_SMA,0,MODE_SIGNAL,1)
      && iStochastic(NULL,PERIOD_H1,13,5,8,MODE_SMA,0,MODE_MAIN,0) < iStochastic(NULL,PERIOD_H1,13,5,8,MODE_SMA,0,MODE_SIGNAL,0)) 
      || (iStochastic(NULL,PERIOD_H1,13,5,8,MODE_SMA,0,MODE_MAIN,1) < iStochastic(NULL,PERIOD_H1,13,5,8,MODE_SMA,0,MODE_SIGNAL,1)
      && iStochastic(NULL,PERIOD_H1,13,5,8,MODE_SMA,0,MODE_MAIN,0) > iStochastic(NULL,PERIOD_H1,13,5,8,MODE_SMA,0,MODE_SIGNAL,0)))
   {
      for(int i = OrdersTotal()-1;i >= 0;i--)
      {
         if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
         {
            if(OrderSymbol() == Symbol())
            {
               if(OrderType()== OP_BUY)
               {
                  if(!OrderClose(OrderTicket(),OrderLots(),Bid,3))
                  {
                     Alert("OrderClose returned error of",GetLastError());
                  }
               }
               else if(OrderType()== OP_SELL )
               {
                  if(!OrderClose(OrderTicket(),OrderLots(),Ask,3))
                  {
                     Alert("OrderClose returned error of",GetLastError());
                  }
               }
               else
               {
                  if(!OrderDelete(OrderTicket()))
                  {
                     Alert("OrderDelete returned error of",GetLastError());
                  }
               }
            }
         }   
      }
   }
  }
//+------------------------------------------------------------------+
