//+------------------------------------------------------------------+
//|                                                       KD反轉通知.mq4 |
//|                        Copyright 2014, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2014, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#property indicator_chart_window
//--- input parameters
input bool     period_h1=true;
//--- parameters
int            bflag = 0;
int            sflag = 0;
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
   if(iStochastic(NULL,PERIOD_H1,5,3,3,MODE_SMA,0,MODE_MAIN,2) > iStochastic(NULL,PERIOD_H1,5,3,3,MODE_SMA,0,MODE_MAIN,1) 
      && sflag < 1)
   {
      Alert(Symbol()," H1 K down");
      sflag = 1;
      bflag = 0;
   }
   if(iStochastic(NULL,PERIOD_H1,5,3,3,MODE_SMA,0,MODE_MAIN,2) < iStochastic(NULL,PERIOD_H1,5,3,3,MODE_SMA,0,MODE_MAIN,1) 
      && bflag < 1)
   {
      Alert(Symbol()," H1 K up");
      bflag = 1;
      sflag = 0;
   }
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
