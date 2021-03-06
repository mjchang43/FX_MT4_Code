//+------------------------------------------------------------------+
//|                                                         上破三角.mq4 |
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
//--- plot up
#property indicator_label1  "up"
#property indicator_type1   DRAW_SECTION
#property indicator_color1  clrDarkOrchid
#property indicator_style1  STYLE_SOLID
#property indicator_width1  3
//--- plot down
#property indicator_label2  "down"
#property indicator_type2   DRAW_SECTION
#property indicator_color2  clrHotPink
#property indicator_style2  STYLE_SOLID
#property indicator_width2  3
//--- input parameters
input int      起始bar=1;
input int      統計bar數=10;
input int      MAPeriod=100;
//--- parameters
int            highestbar,high2ndbar,lowestbar,low2ndbar;
double         ah,al,bh,bl;
int            bflag = 0;
int            sflag = 0;
//--- indicator buffers
double         upBuffer[];
double         downBuffer[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   SetIndexBuffer(0,upBuffer);
   SetIndexBuffer(1,downBuffer);
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
      if(Low[1] > Low[2] || High[1] < High[2])
      {
         /*for(int i = Bars-1;i >= 0;i--)
         {
            upBuffer[i] = EMPTY_VALUE;
            downBuffer[i] = EMPTY_VALUE;
         }*/
         high2ndbar = iHighest(NULL,0,MODE_HIGH,統計bar數,起始bar);
         low2ndbar = iLowest(NULL,0,MODE_LOW,統計bar數,起始bar);
         for(int i = high2ndbar+1 ; i < Bars;i++)
         {
            if(High[i] < High[high2ndbar] && High[i+1] < High[high2ndbar] && High[i+2] < High[high2ndbar])
               break;
            else
               high2ndbar = i;
         }
         for(int i = low2ndbar+1 ; i < Bars;i++)
         {
            if(Low[i] > Low[low2ndbar] && Low[i] > Low[low2ndbar] && Low[i] > Low[low2ndbar])
               break;
            else
               low2ndbar = i;
         }
         for(int i = high2ndbar+1 ; i < Bars;i++)
         {
            if(High[i] > High[high2ndbar])
            {
               highestbar = i;
               if(High[i+1] < High[highestbar] && High[i+2] < High[highestbar] && High[i+3] < High[highestbar])
                  break;
            }
         }
         for(int i = low2ndbar+1 ; i < Bars;i++)
         {
            if(Low[i] < Low[low2ndbar])
            {
               lowestbar = i;
               if(Low[i+1] > Low[lowestbar] && Low[i+2] > Low[lowestbar] && Low[i+3] > Low[lowestbar])
                  break;
            }
         }
         /*upBuffer[highestbar] = High[highestbar];
         upBuffer[high2ndbar] = High[high2ndbar];
         downBuffer[lowestbar] = Low[lowestbar];
         downBuffer[low2ndbar] = Low[low2ndbar];*/
         ah = (High[highestbar]-High[high2ndbar])/(highestbar-high2ndbar);
         bh = High[highestbar]-highestbar*(High[highestbar]-High[high2ndbar])/(highestbar-high2ndbar);
         al = (Low[lowestbar]-Low[low2ndbar])/(lowestbar-low2ndbar);
         bl = Low[lowestbar]-lowestbar*(Low[lowestbar]-Low[low2ndbar])/(lowestbar-low2ndbar);
         /*upBuffer[0] = 0*ah+bh;
         downBuffer[0] = 0*al+bl;*/
         if((bl-bh)/(ah-al) < 0)
         {
            if(Bid > (0)*ah+bh && bflag < 1)
            {
               sflag = 0;
               if(iStochastic(NULL,PERIOD_H1,13,5,8,MODE_SMA,0,MODE_MAIN,0) > iStochastic(NULL,PERIOD_H1,13,5,8,MODE_SMA,0,MODE_SIGNAL,0)
                  && iStochastic(NULL,0,13,5,8,MODE_SMA,0,MODE_MAIN,0) > iStochastic(NULL,0,13,5,8,MODE_SMA,0,MODE_SIGNAL,0)
                  && High[1] > iMA(NULL,0,MAPeriod,0,MODE_SMA,PRICE_CLOSE,0))
               {
                  Alert(Symbol()," price over down trend");
                  bflag = 1;
               }
            }
            
            if(Ask < (0)*al+bl && sflag < 1)
            {
               bflag = 0;
               if(iStochastic(NULL,PERIOD_H1,13,5,8,MODE_SMA,0,MODE_MAIN,0) < iStochastic(NULL,PERIOD_H1,13,5,8,MODE_SMA,0,MODE_SIGNAL,0)
                  && iStochastic(NULL,0,13,5,8,MODE_SMA,0,MODE_MAIN,0) < iStochastic(NULL,0,13,5,8,MODE_SMA,0,MODE_SIGNAL,0)
                  && Low[1] < iMA(NULL,0,MAPeriod,0,MODE_SMA,PRICE_CLOSE,0))
               {
                  Alert(Symbol()," price over rising trend");
                  sflag = 1;
               }
            }
         }
      }
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
