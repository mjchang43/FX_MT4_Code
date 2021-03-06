//+------------------------------------------------------------------+
//|                                                         波段高低.mq4 |
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
//--- plot high
#property indicator_label1  "high"
#property indicator_type1   DRAW_ARROW
#property indicator_color1  clrHotPink
#property indicator_style1  STYLE_SOLID
#property indicator_width1  7
//--- plot low
#property indicator_label2  "low"
#property indicator_type2   DRAW_ARROW
#property indicator_color2  clrLimeGreen
#property indicator_style2  STYLE_SOLID
#property indicator_width2  7
//--- indicator buffers
double         highBuffer[];
double         lowBuffer[];
//--- input parameters
/*input double 指標距離通知點數 = 25;
input double 通知範圍 = 5;*/
input int      MAPeriod=100;
//--- parameters
int            flag = 0;
int            bflag = 0;
int            sflag = 0;
int            fbflag = 0;
int            fsflag = 0;
int            highbar,pathhibar,lowbar,pathlobar,totalbars;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   SetIndexBuffer(0,highBuffer);
   SetIndexBuffer(1,lowBuffer);
   
//--- setting a code from the Wingdings charset as the property of PLOT_ARROW
   PlotIndexSetInteger(0,PLOT_ARROW,159);
   PlotIndexSetInteger(1,PLOT_ARROW,159);
   
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
      totalbars = Bars-1;
      for(int i = totalbars;i >= 0;i--)
      {
         switch(flag)
         {
            case 1:
               if(Low[i] < Low[lowbar])
               {
                  lowBuffer[i] = Low[i];
                  lowBuffer[lowbar] = EMPTY_VALUE;
                  lowbar = i;
               }
               
               if(High[i] > iBands(NULL,0,20,2,0,PRICE_CLOSE,MODE_UPPER,i) && High[i] > iEnvelopes(NULL,0,14,MODE_SMA,0,PRICE_CLOSE,0.1,MODE_UPPER,i))
               {
                  highBuffer[i] = High[i];
                  highbar = i;
                  flag = 2;
               }
               continue;
            
            case 2:
               if(High[i] > High[highbar])
               {
                  highBuffer[i] = High[i];
                  highBuffer[highbar] = EMPTY_VALUE;
                  highbar = i;
               }
               
               if(Low[i] < iBands(NULL,0,20,2,0,PRICE_CLOSE,MODE_LOWER,i) && Low[i] < iEnvelopes(NULL,0,14,MODE_SMA,0,PRICE_CLOSE,0.1,MODE_LOWER,i))
               {
                  lowBuffer[i] = Low[i];
                  lowbar = i;
                  flag = 1;
               }
               continue;
               
            default:
               if(Low[i] < iBands(NULL,0,20,2,0,PRICE_CLOSE,MODE_LOWER,i) && Low[i] < iEnvelopes(NULL,0,14,MODE_SMA,0,PRICE_CLOSE,0.1,MODE_LOWER,i))
               {
                  lowBuffer[i] = Low[i];
                  lowbar = i;
                  flag = 1;
               }
               if(High[i] > iBands(NULL,0,20,2,0,PRICE_CLOSE,MODE_UPPER,i) && High[i] > iEnvelopes(NULL,0,14,MODE_SMA,0,PRICE_CLOSE,0.1,MODE_UPPER,i))
               {
                  highBuffer[i] = High[i];
                  highbar = i;
                  flag = 2;
               }
               continue;
         }
      }
      
      if(lowbar == 1 && bflag < 1)
      {
         Alert(Symbol(),"看一下唄");
         bflag = 1;
         sflag = 0;
      }
      else if(highbar == 1 && sflag < 1)
      {
         Alert(Symbol(),"看一下唄");
         sflag = 1;
         bflag = 0;
      }
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
