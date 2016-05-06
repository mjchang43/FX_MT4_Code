//+------------------------------------------------------------------+
//|                                                          try.mq4 |
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
//--- plot btry
#property indicator_label1  "btry"
#property indicator_type1   DRAW_ARROW
#property indicator_color1  clrBlue
#property indicator_style1  STYLE_SOLID
#property indicator_width1  6
//--- plot stry
#property indicator_label2  "stry"
#property indicator_type2   DRAW_ARROW
#property indicator_color2  clrRed
#property indicator_style2  STYLE_SOLID
#property indicator_width2  6
//--- input parameters
input int      Input1=0;
//--- indicator buffers
double         btryBuffer[];
double         stryBuffer[];
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
   SetIndexBuffer(0,btryBuffer);
   SetIndexBuffer(1,stryBuffer);
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
         pathhibar = iHighest(NULL,PERIOD_H1,MODE_HIGH,25,i);
         pathlobar = iLowest(NULL,PERIOD_H1,MODE_LOW,25,i);
         switch(flag)
         {
            case 1:
               if(Low[i] < Low[lowbar])
                  lowbar = i;
               
               if(High[i] > iBands(NULL,0,20,2,0,PRICE_CLOSE,MODE_UPPER,i) && High[i] > iEnvelopes(NULL,0,14,MODE_SMA,0,PRICE_CLOSE,0.1,MODE_UPPER,i))
               {
                  highbar = i;
                  flag = 2;
               }
               if(lowbar != i)
               {
                  /*for(int i = lowbar-1;i > 0;i--)
                  {
                     if(Close[i] > Open[i])
                     {
                        count++;
                        break;
                     }
                  }*/
                  //if(/*High[1] > iMA(NULL,0,MAPeriod,0,MODE_SMA,PRICE_CLOSE,0) && */pathhibar > pathlobar /*&& count > 0*/)
                  //{
                     if(iStochastic(NULL,0,5,3,3,MODE_SMA,0,MODE_MAIN,i+1)-iStochastic(NULL,0,5,3,3,MODE_SMA,0,MODE_SIGNAL,i+1)
                        < iStochastic(NULL,0,5,3,3,MODE_SMA,0,MODE_MAIN,i)-iStochastic(NULL,0,5,3,3,MODE_SMA,0,MODE_SIGNAL,i)
                        && iStochastic(NULL,0,5,3,3,MODE_SMA,0,MODE_MAIN,i) > iStochastic(NULL,0,5,3,3,MODE_SMA,0,MODE_SIGNAL,i)
                        
                        && iStochastic(NULL,0,13,5,8,MODE_SMA,0,MODE_SIGNAL,i)-iStochastic(NULL,0,13,5,8,MODE_SMA,0,MODE_MAIN,i) < 5
                        //&& iBands(NULL,0,20,2,0,PRICE_CLOSE,MODE_MAIN,i)-iBands(NULL,0,20,2,0,PRICE_CLOSE,MODE_MAIN,i+1) >= -3*Point
                        && ((iStochastic(NULL,0,13,5,8,MODE_SMA,0,MODE_MAIN,i) < 25 && iStochastic(NULL,0,5,3,3,MODE_SMA,0,MODE_MAIN,i) < 70)
                        || iStochastic(NULL,0,13,5,8,MODE_SMA,0,MODE_MAIN,i) > iStochastic(NULL,0,13,5,8,MODE_SMA,0,MODE_MAIN,i+1)+10) 
                        && iMFI(NULL,0,14,i) > iMFI(NULL,0,14,i+1)+5 && bflag < 1)
                     {
                        btryBuffer[i] = High[i];
                        bflag = 1;
                        sflag = 0;
                        //count = 0;
                     }
                     else if(iStochastic(NULL,0,5,3,3,MODE_SMA,0,MODE_MAIN,i) < iStochastic(NULL,0,5,3,3,MODE_SMA,0,MODE_SIGNAL,i))
                        bflag = 0;
                  //}
               }
               else
               {
                  /*for(int i = highbar-1;i > 0;i--)
                  {
                     if(Close[i] < Open[i])
                     {
                        count++;
                        break;
                     }
                  }*/
                  //if(/*Low[1] < iMA(NULL,0,MAPeriod,0,MODE_SMA,PRICE_CLOSE,0) && */pathhibar < pathlobar /*&& count > 0*/)
                  //{
                     if(iStochastic(NULL,0,5,3,3,MODE_SMA,0,MODE_SIGNAL,i+1)-iStochastic(NULL,0,5,3,3,MODE_SMA,0,MODE_MAIN,i+1)
                        < iStochastic(NULL,0,5,3,3,MODE_SMA,0,MODE_SIGNAL,i)-iStochastic(NULL,0,5,3,3,MODE_SMA,0,MODE_MAIN,i) 
                        && iStochastic(NULL,0,5,3,3,MODE_SMA,0,MODE_MAIN,i) < iStochastic(NULL,0,5,3,3,MODE_SMA,0,MODE_SIGNAL,i)
                        
                        && iStochastic(NULL,0,13,5,8,MODE_SMA,0,MODE_MAIN,i)-iStochastic(NULL,0,13,5,8,MODE_SMA,0,MODE_SIGNAL,i) < 5
                        //&& iBands(NULL,0,20,2,0,PRICE_CLOSE,MODE_MAIN,i)-iBands(NULL,0,20,2,0,PRICE_CLOSE,MODE_MAIN,i+1) <= 3*Point
                        && ((iStochastic(NULL,0,13,5,8,MODE_SMA,0,MODE_MAIN,i) > 75 && iStochastic(NULL,0,5,3,3,MODE_SMA,0,MODE_MAIN,i) > 30)
                        || iStochastic(NULL,0,13,5,8,MODE_SMA,0,MODE_MAIN,i) < iStochastic(NULL,0,13,5,8,MODE_SMA,0,MODE_MAIN,i+1)-10)
                        && iMFI(NULL,0,14,i) < iMFI(NULL,0,14,i+1)-5 && sflag < 1)
                     {
                        stryBuffer[i] = Low[i];
                        sflag = 1;
                        bflag = 0;
                        //count = 0;
                     }
                     else if(iStochastic(NULL,0,5,3,3,MODE_SMA,0,MODE_MAIN,i) > iStochastic(NULL,0,5,3,3,MODE_SMA,0,MODE_SIGNAL,i))
                        sflag = 0;
                  //}
               }
               continue;
            
            case 2:
               if(High[i] > High[highbar])
                  highbar = i;
               
               if(Low[i] < iBands(NULL,0,20,2,0,PRICE_CLOSE,MODE_LOWER,i) && Low[i] < iEnvelopes(NULL,0,14,MODE_SMA,0,PRICE_CLOSE,0.1,MODE_LOWER,i))
               {
                 lowbar = i;
                  flag = 1;
               }
               if(highbar != i)
               {
                  /*for(int i = highbar-1;i > 0;i--)
                  {
                     if(Close[i] < Open[i])
                     {
                        count++;
                        break;
                     }
                  }*/
                  //if(/*Low[1] < iMA(NULL,0,MAPeriod,0,MODE_SMA,PRICE_CLOSE,0) && */pathhibar < pathlobar /*&& count > 0*/)
                  //{
                     if(iStochastic(NULL,0,5,3,3,MODE_SMA,0,MODE_SIGNAL,i+1)-iStochastic(NULL,0,5,3,3,MODE_SMA,0,MODE_MAIN,i+1)
                        < iStochastic(NULL,0,5,3,3,MODE_SMA,0,MODE_SIGNAL,i)-iStochastic(NULL,0,5,3,3,MODE_SMA,0,MODE_MAIN,i)
                        && iStochastic(NULL,0,5,3,3,MODE_SMA,0,MODE_MAIN,i) < iStochastic(NULL,0,5,3,3,MODE_SMA,0,MODE_SIGNAL,i)
                        
                        && iStochastic(NULL,0,13,5,8,MODE_SMA,0,MODE_MAIN,i)-iStochastic(NULL,0,13,5,8,MODE_SMA,0,MODE_SIGNAL,i) < 5
                        //&& iBands(NULL,0,20,2,0,PRICE_CLOSE,MODE_MAIN,i)-iBands(NULL,0,20,2,0,PRICE_CLOSE,MODE_MAIN,i+1) <= 3*Point 
                        && ((iStochastic(NULL,0,13,5,8,MODE_SMA,0,MODE_MAIN,i) > 75 && iStochastic(NULL,0,5,3,3,MODE_SMA,0,MODE_MAIN,i) > 30)
                        || iStochastic(NULL,0,13,5,8,MODE_SMA,0,MODE_MAIN,i) < iStochastic(NULL,0,13,5,8,MODE_SMA,0,MODE_MAIN,i+1)-10)
                        && iMFI(NULL,0,14,i) < iMFI(NULL,0,14,i+1)-5 && sflag < 1)
                     {
                        stryBuffer[i] = Low[i];
                        sflag = 1;
                        bflag = 0;
                        //count = 0;
                     }
                     else if(iStochastic(NULL,0,5,3,3,MODE_SMA,0,MODE_MAIN,i) > iStochastic(NULL,0,5,3,3,MODE_SMA,0,MODE_SIGNAL,i))
                        sflag = 0;
                  //}
               }
               else
               {
                  /*for(int i = lowbar-1;i > 0;i--)
                  {
                     if(Close[i] > Open[i])
                     {
                        count++;
                        break;
                     }
                  }*/
                  //if(/*High[1] > iMA(NULL,0,MAPeriod,0,MODE_SMA,PRICE_CLOSE,0) && */pathhibar > pathlobar /*&& count > 0*/)
                  //{
                     if(iStochastic(NULL,0,5,3,3,MODE_SMA,0,MODE_MAIN,i+1)-iStochastic(NULL,0,5,3,3,MODE_SMA,0,MODE_SIGNAL,i+1)
                        < iStochastic(NULL,0,5,3,3,MODE_SMA,0,MODE_MAIN,i)-iStochastic(NULL,0,5,3,3,MODE_SMA,0,MODE_SIGNAL,i)
                        && iStochastic(NULL,0,5,3,3,MODE_SMA,0,MODE_MAIN,i) > iStochastic(NULL,0,5,3,3,MODE_SMA,0,MODE_SIGNAL,i)
                        
                        && iStochastic(NULL,0,13,5,8,MODE_SMA,0,MODE_SIGNAL,i)-iStochastic(NULL,0,13,5,8,MODE_SMA,0,MODE_MAIN,i) < 5
                        //&& iBands(NULL,0,20,2,0,PRICE_CLOSE,MODE_MAIN,i)-iBands(NULL,0,20,2,0,PRICE_CLOSE,MODE_MAIN,i+1) >= -3*Point
                        && ((iStochastic(NULL,0,13,5,8,MODE_SMA,0,MODE_MAIN,i) < 25 && iStochastic(NULL,0,5,3,3,MODE_SMA,0,MODE_MAIN,i) < 70)
                        || iStochastic(NULL,0,13,5,8,MODE_SMA,0,MODE_MAIN,i) > iStochastic(NULL,0,13,5,8,MODE_SMA,0,MODE_MAIN,i+1)+10) 
                        && iMFI(NULL,0,14,i) > iMFI(NULL,0,14,i+1)+5 && bflag < 1)
                     {
                        btryBuffer[i] = High[i];
                        bflag = 1;
                        sflag = 0;
                        //count = 0;
                     }
                     else if(iStochastic(NULL,0,5,3,3,MODE_SMA,0,MODE_MAIN,i) < iStochastic(NULL,0,5,3,3,MODE_SMA,0,MODE_SIGNAL,i))
                        bflag = 0;
                  //}
               }
               continue;
               
            default:
               if(Low[i] < iBands(NULL,0,20,2,0,PRICE_CLOSE,MODE_LOWER,i) && Low[i] < iEnvelopes(NULL,0,14,MODE_SMA,0,PRICE_CLOSE,0.1,MODE_LOWER,i))
               {
                  lowbar = i;
                  flag = 1;
               }
               if(High[i] > iBands(NULL,0,20,2,0,PRICE_CLOSE,MODE_UPPER,i) && High[i] > iEnvelopes(NULL,0,14,MODE_SMA,0,PRICE_CLOSE,0.1,MODE_UPPER,i))
               {
                  highbar = i;
                  flag = 2;
               }
               continue;
         }
      }
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
