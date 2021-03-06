//+------------------------------------------------------------------+
//|                                                        突破SMA.mq4 |
//|                        Copyright 2014, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2014, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#property indicator_chart_window
//--- input parameters
input int      MAPeriod=100;
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
      if(iStochastic(NULL,PERIOD_H1,13,5,8,MODE_SMA,0,MODE_MAIN,0) < iStochastic(NULL,PERIOD_H1,13,5,8,MODE_SMA,0,MODE_MAIN,1)-1
         && Low[1] < iMA(NULL,0,MAPeriod,0,MODE_SMA,PRICE_CLOSE,0) && sflag < 1)
      {
         Alert(Symbol()," down SMA");
         sflag = 1;
         bflag = 0;
      }
      if(iStochastic(NULL,PERIOD_H1,13,5,8,MODE_SMA,0,MODE_MAIN,0) > iStochastic(NULL,PERIOD_H1,13,5,8,MODE_SMA,0,MODE_MAIN,1)+1
         && High[1] > iMA(NULL,0,MAPeriod,0,MODE_SMA,PRICE_CLOSE,0) && bflag < 1)
      {
         Alert(Symbol()," up SMA");
         bflag = 1;
         sflag = 0;
      }   
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
