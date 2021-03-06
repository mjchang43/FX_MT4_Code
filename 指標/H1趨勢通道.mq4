//+------------------------------------------------------------------+
//|                                                       H1趨勢通道.mq4 |
//|                        Copyright 2015, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2015, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#property indicator_chart_window
#property indicator_buffers 2
#property indicator_plots   2
//--- plot highest
#property indicator_label1  "highest"
#property indicator_type1   DRAW_SECTION
#property indicator_color1  clrDarkOrchid
#property indicator_style1  STYLE_SOLID
#property indicator_width1  3
//--- plot lowest
#property indicator_label2  "lowest"
#property indicator_type2   DRAW_SECTION
#property indicator_color2  clrHotPink
#property indicator_style2  STYLE_SOLID
#property indicator_width2  3
//--- input parameters
input int      Input1=0;
//--- parameters
int            hibar,hi2bar,hi3bar,lobar,lo2bar,lo3bar;
bool           over;
double         ah,bh,al,bl;
//--- indicator buffers
double         highestBuffer[];
double         lowestBuffer[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   SetIndexBuffer(0,highestBuffer);
   SetIndexBuffer(1,lowestBuffer);
   
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
      hibar = iHighest(NULL,PERIOD_H1,MODE_HIGH,25,0);
      lobar = iLowest(NULL,PERIOD_H1,MODE_LOW,25,0);
      if(hibar > lobar)
      {
         for(int i = Bars-1; i >= 0;i--)
         {
            highestBuffer[i] = EMPTY_VALUE;
            lowestBuffer[i] = EMPTY_VALUE;
         }
         hi2bar = iHighest(NULL,PERIOD_H1,MODE_HIGH,lobar,0);
         ah = (High[hibar]-High[hi2bar])/(hibar-hi2bar);
         bh = High[hibar]-hibar*(High[hibar]-High[hi2bar])/(hibar-hi2bar);
         while(true)
         {
            for(int i = hibar-1;i > hi2bar;i--)
            {
               if(High[i] > ah*i+bh)
               {
                  over = true;
                  break;
               }
               else
                  over = false;
            }
         }
         if(over)
         {
            lo2bar = iLowest(NULL,PERIOD_H1,MODE_LOW,25-hibar,hibar);
            al = (Low[lobar]-Low[lo2bar])/(lobar-lo2bar);
            bl = Low[lobar]-lobar*(Low[lobar]-Low[lo2bar])/(lobar-lo2bar);
            while(true)
            {
               for(int i = lobar+1;i < lo2bar;i++)
               {
                  if(Low[i] < al*i+bl)
                  {
                     over = true;
                     lobar = i;
                     break;
                  }
                  else
                     over = false;
               }
               if(over)
                  bl = Low[lobar]-al*lobar;
               else
                  break;
            }
            lowestBuffer[lobar] = Low[lobar];
            lowestBuffer[24] = al*24+bl;
            lowestBuffer[0] = bl;
            bh = High[hibar]-al*hibar;
            /*while(true)
            {
               for(int i = hibar-1;i >= 0;i--)
               {
                  if(High[i] > al*i+bh)
                  {
                     over = true;
                     hibar = i;
                     break;
                  }
                  else
                     over = false;
               }
               if(over)
                  bh = High[hibar]-al*hibar;
               else
                  break;                  
            }*/
            highestBuffer[hibar] = High[hibar];
            highestBuffer[0] = bh;
            highestBuffer[24] = al*24+bh;
         }
         else
         {
            hi2bar = iHighest(NULL,PERIOD_H1,MODE_HIGH,lobar,0);
            ah = (High[hibar]-High[hi2bar])/(hibar-hi2bar);
            bh = High[hibar]-hibar*(High[hibar]-High[hi2bar])/(hibar-hi2bar);
            highestBuffer[hibar] = High[hibar];
            highestBuffer[hi2bar] = High[hi2bar];
            highestBuffer[24] = ah*24+bh;
            highestBuffer[0] = bh;
            bl = Low[lobar]-ah*lobar;
            lowestBuffer[lobar] = Low[lobar];
            lowestBuffer[0] = bl;
            lowestBuffer[24] = ah*24+bl;
         }
      }
      else
      {
         for(int i = Bars-1; i >= 0;i--)
         {
            highestBuffer[i] = EMPTY_VALUE;
            lowestBuffer[i] = EMPTY_VALUE;
         }
         lo2bar = iLowest(NULL,PERIOD_H1,MODE_LOW,hibar,0);
         al = (Low[lobar]-Low[lo2bar])/(lobar-lo2bar);
         bl = Low[lobar]-lobar*(Low[lobar]-Low[lo2bar])/(lobar-lo2bar);
         for(int i = lobar-1;i > lo2bar;i--)
         {
            if(Low[i] < al*i+bl)
            {
               over = true;
               break;
            }
            else
               over = false;
         }
         if(over)
         {
            hi2bar = iHighest(NULL,PERIOD_H1,MODE_HIGH,25-lobar,lobar);
            ah = (High[hibar]-High[hi2bar])/(hibar-hi2bar);
            bh = High[hibar]-hibar*(High[hibar]-High[hi2bar])/(hibar-hi2bar);
            highestBuffer[hibar] = High[hibar];
            highestBuffer[hi2bar] = High[hi2bar];
            highestBuffer[24] = ah*24+bh;
            highestBuffer[0] = bh;
            bl = Low[lobar]-ah*lobar;
            lowestBuffer[lobar] = Low[lobar];
            lowestBuffer[0] = bl;
            lowestBuffer[24] = ah*24+bl;
         }
         else
         {
            lo2bar = iLowest(NULL,PERIOD_H1,MODE_LOW,hibar,0);
            al = (Low[lobar]-Low[lo2bar])/(lobar-lo2bar);
            bl = Low[lobar]-lobar*(Low[lobar]-Low[lo2bar])/(lobar-lo2bar);
            lowestBuffer[lobar] = Low[lobar];
            lowestBuffer[lo2bar] = Low[lo2bar];
            lowestBuffer[24] = al*24+bl;
            lowestBuffer[0] = bl;
            bh = High[hibar]-al*hibar;
            highestBuffer[hibar] = High[hibar];
            highestBuffer[0] = bh;
            highestBuffer[24] = al*24+bh;
         }
      }
      /*if(hibar < 25 && lobar < 25)
      {
      }
      else if(hibar < 25)
      {
         for(int i = Bars-1; i >= 0;i--)
         {
            highestBuffer[i] = EMPTY_VALUE;
            lowestBuffer[i] = EMPTY_VALUE;
         }
         lobar = iLowest(NULL,PERIOD_H1,MODE_LOW,25,0);
         if(hibar > lobar)
         {
            lobar = iLowest(NULL,PERIOD_H1,MODE_LOW,hibar,0);
            hi2bar = iHighest(NULL,PERIOD_H1,MODE_HIGH,hibar,0);
            if(hi2bar < lobar)
            {
               ah = (High[hibar]-High[hi2bar])/(hibar-hi2bar);
               bh = High[hibar]-hibar*(High[hibar]-High[hi2bar])/(hibar-hi2bar);
               highestBuffer[hibar] = High[hibar];
               highestBuffer[hi2bar] = High[hi2bar];
               highestBuffer[0] = bh;
               bl = Low[lobar]-ah*lobar;
               lowestBuffer[lobar] = Low[lobar];
               lowestBuffer[0] = bl;
            }
           else
            {
               lo2bar = iLowest(NULL,PERIOD_H1,MODE_LOW,25-hibar,hibar);
               al = (Low[lobar]-Low[lo2bar])/(lobar-lo2bar);
               bl = Low[lobar]-lobar*(Low[lobar]-Low[lo2bar])/(lobar-lo2bar);
               lowestBuffer[lobar] = Low[lobar];
               lowestBuffer[lo2bar] = Low[lo2bar];
               lowestBuffer[0] = bl;
               bh = High[hibar]-al*hibar;
               highestBuffer[hibar] = High[hibar];
               highestBuffer[0] = bh;
            }
         }
         else
         {
            lo2bar = iLowest(NULL,PERIOD_H1,MODE_LOW,lobar,0);
            if(lo2bar < hibar)
            {
               al = (Low[lobar]-Low[lo2bar])/(lobar-lo2bar);
               bl = Low[lobar]-lobar*(Low[lobar]-Low[lo2bar])/(lobar-lo2bar);
               lowestBuffer[lobar] = Low[lobar];
               lowestBuffer[lo2bar] = Low[lo2bar];
               lowestBuffer[0] = bl;
               bh = High[hibar]-al*hibar;
               highestBuffer[hibar] = High[hibar];
               highestBuffer[0] = bh;
            }
            else
            {
               hi2bar = iHighest(NULL,PERIOD_H1,MODE_HIGH,25-lobar,lobar);
               ah = (High[hibar]-High[hi2bar])/(hibar-hi2bar);
               bh = High[hibar]-hibar*(High[hibar]-High[hi2bar])/(hibar-hi2bar);
               highestBuffer[hibar] = High[hibar];
               highestBuffer[hi2bar] = High[hi2bar];
               highestBuffer[0] = bh;
               bl = Low[lobar]-ah*lobar;
               lowestBuffer[lobar] = Low[lobar];
               lowestBuffer[0] = bl;
            }
         }
      }
      else if(lobar < 25)
      {
         for(int i = Bars-1; i >= 0;i--)
         {
            highestBuffer[i] = EMPTY_VALUE;
            lowestBuffer[i] = EMPTY_VALUE;
         }
         hibar = iHighest(NULL,PERIOD_H1,MODE_HIGH,25,0);
         if(lobar > hibar)
         {
            hibar = iHighest(NULL,PERIOD_H1,MODE_HIGH,lobar,0);
            lo2bar = iLowest(NULL,PERIOD_H1,MODE_LOW,lobar,0);
            if(lo2bar < hibar)
            {
               al = (Low[lobar]-Low[lo2bar])/(lobar-lo2bar);
               bl = Low[lobar]-lobar*(Low[lobar]-Low[lo2bar])/(lobar-lo2bar);
               lowestBuffer[lobar] = Low[lobar];
               lowestBuffer[lo2bar] = Low[lo2bar];
               lowestBuffer[0] = bl;
               bh = High[hibar]-al*hibar;
               highestBuffer[hibar] = High[hibar];
               highestBuffer[0] = bh;
            }
            else
            {
               hi2bar = iHighest(NULL,PERIOD_H1,MODE_HIGH,25-lobar,lobar);
               ah = (High[hibar]-High[hi2bar])/(hibar-hi2bar);
               bh = High[hibar]-hibar*(High[hibar]-High[hi2bar])/(hibar-hi2bar);
               highestBuffer[hibar] = High[hibar];
               highestBuffer[hi2bar] = High[hi2bar];
               highestBuffer[0] = bh;
               bl = Low[lobar]-ah*lobar;
               lowestBuffer[lobar] = Low[lobar];
               lowestBuffer[0] = bl;
            }
         }
         else
         {
            hi2bar = iHighest(NULL,PERIOD_H1,MODE_HIGH,hibar,0);
            if(hi2bar < lobar)
            {
               ah = (High[hibar]-High[hi2bar])/(hibar-hi2bar);
               bh = High[hibar]-hibar*(High[hibar]-High[hi2bar])/(hibar-hi2bar);
               highestBuffer[hibar] = High[hibar];
               highestBuffer[hi2bar] = High[hi2bar];
               highestBuffer[0] = bh;
               bl = Low[lobar]-ah*lobar;
               lowestBuffer[lobar] = Low[lobar];
               lowestBuffer[0] = bl;
            }
            else
            {
               lo2bar = iLowest(NULL,PERIOD_H1,MODE_LOW,25-hibar,hibar);
               al = (Low[lobar]-Low[lo2bar])/(lobar-lo2bar);
               bl = Low[lobar]-lobar*(Low[lobar]-Low[lo2bar])/(lobar-lo2bar);
               lowestBuffer[lobar] = Low[lobar];
               lowestBuffer[lo2bar] = Low[lo2bar];
               lowestBuffer[0] = bl;
               bh = High[hibar]-al*hibar;
               highestBuffer[hibar] = High[hibar];
               highestBuffer[0] = bh;
            }
         }
      }*/
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
