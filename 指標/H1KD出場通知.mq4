//+------------------------------------------------------------------+
//|                                                         出場通知.mq4 |
//|                        Copyright 2015, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2015, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#property indicator_chart_window
//--- input parameters
input bool      buy=true;
//--- parameters
int            flag = 0;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
  {
//---
     if(iStochastic(NULL,0,5,3,3,MODE_SMA,0,MODE_MAIN,0) >= 80  && buy && flag < 1)
     {
         Alert(Symbol()," buy 單該出場嚕");
         flag = 1;
     }
     else if(iStochastic(NULL,0,5,3,3,MODE_SMA,0,MODE_MAIN,0) <= 20 && !buy && flag < 1)
     {
         Alert(Symbol()," sell 單該出場嚕");
         flag = 1;
     }
     else if(iStochastic(NULL,0,5,3,3,MODE_SMA,0,MODE_MAIN,0) > 30 && iStochastic(NULL,0,5,3,3,MODE_SMA,0,MODE_MAIN,0) < 70)
      flag = 0;
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
