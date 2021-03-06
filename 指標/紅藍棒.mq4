//+------------------------------------------------------------------+
//|                                                          紅藍棒.mq4 |
//|                        Copyright 2014, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2014, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"
#property strict
#property indicator_chart_window
#property indicator_buffers 2
#property indicator_plots   2
//--- plot redbar
#property indicator_label1  "redbar"
#property indicator_type1   DRAW_HISTOGRAM
#property indicator_color1  clrRed
#property indicator_style1  STYLE_SOLID
#property indicator_width1  8
//--- plot bluebar
#property indicator_label2  "bluebar"
#property indicator_type2   DRAW_HISTOGRAM
#property indicator_color2  clrAqua
#property indicator_style2  STYLE_SOLID
#property indicator_width2  8
//--- indicator buffers
double         redbarBuffer[];
double         bluebarBuffer[];
//---parameters
int            totalbars;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   SetIndexStyle(0,DRAW_HISTOGRAM,STYLE_SOLID,indicator_width1,indicator_color1);
   SetIndexBuffer(0,redbarBuffer);
   SetIndexEmptyValue(0,EMPTY_VALUE);
   SetIndexBuffer(1,bluebarBuffer);
   
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
      totalbars = Bars-2;
      for(int i = totalbars; i >= 0;i--)
      {
         if((Close[i]+Open[i])/2 > (Close[i-1]+Open[i-1])/2)
            bluebarBuffer[i] = Close[i];
         else if((Close[i]+Open[i])/2 < (Close[i-1]+Open[i-1])/2)
            redbarBuffer[i] = Close[i];
      }
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
