//+------------------------------------------------------------------+
//|                                                      自訂bar取值.mq4 |
//|                        Copyright 2014, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2014, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"
#property strict
#property script_show_inputs
//--- input parameters
input int      bar_shift=0;
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
//---
   
   Print("High: ",iHigh(NULL,0,iHighest(NULL,0,MODE_HIGH,(bar_shift+1),0)),
         ",LOW: ",iLow(NULL,0,iLowest(NULL,0,MODE_LOW,(bar_shift+1),0)));
            
  }
//+------------------------------------------------------------------+
