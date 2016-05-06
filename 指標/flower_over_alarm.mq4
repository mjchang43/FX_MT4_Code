//+------------------------------------------------------------------+
//|                                                 flower_alarm.mq4 |
//|                        Copyright 2015, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2015, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#property indicator_chart_window
//--- parameters
int            ticket,flag,mark,highbar,lowbar;
double         highestvalue,lowestvalue;
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
      highbar = iHighest(NULL,0,MODE_HIGH,4,1);
      lowbar = iLowest(NULL,0,MODE_LOW,4,1);
      if(mark == 1)
   {
      if((Low[0] < lowestvalue))
      {
         lowestvalue = Low[0];
         if(flag == 0)
         {
            Alert(Symbol()," sell");
            flag = 1;
            return(rates_total);
         }
      }
      if((Low[0] > lowestvalue) && (lowbar != 1))
      {
         flag = 0;
         return(rates_total);
      }
      if(High[0] > iBands(NULL,0,20,2,0,PRICE_CLOSE,MODE_UPPER,0))
      {
         Alert(Symbol()," buy");
         highestvalue = High[0];
         mark = 2;
         flag = 1;
         return(rates_total);
      }
   }
   else if(mark == 2)
   {
      if((High[0] > highestvalue))
      {
         highestvalue = High[0];
         if(flag == 0)
         {
            Alert(Symbol()," buy");
            flag = 1;
            return(rates_total);
         }
      }
      if((High[0] < highestvalue ) && (highbar != 1))
      {
         flag = 0;
         return(rates_total);
      }
      if(Low[0] < iBands(NULL,0,20,2,0,PRICE_CLOSE,MODE_LOWER,0))
      {
         Alert(Symbol()," sell");
         lowestvalue = Low[0];
         flag = 1;
         mark = 1;
         return(rates_total);
      }
   }
   else
   {
      if(Low[lowbar] < iBands(NULL,0,20,2,0,PRICE_CLOSE,MODE_LOWER,lowbar))
      {
         lowestvalue = Low[lowbar];
         mark = 1;
         return(rates_total);
      }
      if(High[highbar] > iBands(NULL,0,20,2,0,PRICE_CLOSE,MODE_UPPER,highbar))
      {
         highestvalue = High[highbar];
         mark = 2;
         return(rates_total);
      }
   }
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
