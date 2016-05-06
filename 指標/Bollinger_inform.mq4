//+------------------------------------------------------------------+
//|                                             Bollinger_inform.mq4 |
//|                        Copyright 2014, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2014, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#property indicator_chart_window
//--- input parameters
input int      percent=25;
input bool     buytrend = true;
//--- parameters
int            bflag = 0;
int            sflag = 0;
int            flag;
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
      if(High[1] > iBands(NULL,PERIOD_H1,20,2,0,PRICE_CLOSE,MODE_UPPER,1)-(iBands(NULL,PERIOD_H1,20,2,0,PRICE_CLOSE,MODE_UPPER,1)-iBands(NULL,PERIOD_H1,20,2,0,PRICE_CLOSE,MODE_MAIN,1))*(percent-10)/100
         && buytrend)
         flag = 1;
      else if(Low[1] < iBands(NULL,PERIOD_H1,20,2,0,PRICE_CLOSE,MODE_LOWER,1)+(iBands(NULL,PERIOD_H1,20,2,0,PRICE_CLOSE,MODE_MAIN,1)-iBands(NULL,PERIOD_H1,20,2,0,PRICE_CLOSE,MODE_LOWER,1))*(percent-10)/100
         && !buytrend)
         flag = 2;
      if(flag == 1)
      {
         if(Ask <= iBands(NULL,PERIOD_H1,20,2,0,PRICE_CLOSE,MODE_UPPER,0)-(iBands(NULL,PERIOD_H1,20,2,0,PRICE_CLOSE,MODE_UPPER,0)-iBands(NULL,PERIOD_H1,20,2,0,PRICE_CLOSE,MODE_MAIN,0))*percent/100 
            && sflag < 1)
         {
            Alert(Symbol()," down Bollinger");
            sflag = 1;
            bflag = 0;
         }
      }
      else if(flag == 2)
      {
         if(Bid >= iBands(NULL,PERIOD_H1,20,2,0,PRICE_CLOSE,MODE_LOWER,0)+(iBands(NULL,PERIOD_H1,20,2,0,PRICE_CLOSE,MODE_MAIN,0)-iBands(NULL,PERIOD_H1,20,2,0,PRICE_CLOSE,MODE_LOWER,0))*percent/100
           && bflag < 1)
         {
            Alert(Symbol()," up Bollinger");
            bflag = 1;
            sflag = 0;
         }
      }
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
