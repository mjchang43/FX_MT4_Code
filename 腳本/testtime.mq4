//+------------------------------------------------------------------+
//|                                                     testtime.mq4 |
//|                        Copyright 2015, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2015, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
//---
   datetime now = TimeLocal();
   datetime after = TimeLocal()+30;
   onTimer();
   Alert("now:"+now+"after:"+TimeLocal()+"nowafter:"+TimeSeconds(after-now) );
  }
//+------------------------------------------------------------------+
void onTimer()
{
   datetime now = TimeLocal();
   datetime after = TimeLocal()+30;
   do
   {
      now = TimeLocal();
   }while(now < after);
}