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
      double cp = iClose(NULL,0,0);
      double cl = iLow(NULL,0,lowbar);
      double ch = iHigh(NULL,0,highbar);
      int count = 0;
      pathhibar = iHighest(NULL,PERIOD_H1,MODE_HIGH,25,0);
      pathlobar = iLowest(NULL,PERIOD_H1,MODE_LOW,25,0);
      
      if(flag == 1)
      {
         if(lowbar != 0)
         {
            for(int i = 5;i >= 0;i--)
            {
               if(iMFI(NULL,0,14,i) < 23)
               {
                  count++;
                  break;
               }
            }
            //if(/*High[1] > iMA(NULL,0,MAPeriod,0,MODE_SMA,PRICE_CLOSE,0) && */pathhibar > pathlobar /*&& count > 0*/)
            //{
               if(iStochastic(NULL,0,5,3,3,MODE_SMA,0,MODE_MAIN,1)-iStochastic(NULL,0,5,3,3,MODE_SMA,0,MODE_SIGNAL,1)
                  < iStochastic(NULL,0,5,3,3,MODE_SMA,0,MODE_MAIN,0)-iStochastic(NULL,0,5,3,3,MODE_SMA,0,MODE_SIGNAL,0)
                  && iStochastic(NULL,0,5,3,3,MODE_SMA,0,MODE_MAIN,0) > iStochastic(NULL,0,5,3,3,MODE_SMA,0,MODE_SIGNAL,0)
                  && iStochastic(NULL,0,13,5,8,MODE_SMA,0,MODE_SIGNAL,0)-iStochastic(NULL,0,13,5,8,MODE_SMA,0,MODE_MAIN,0) < 5
                  //&& iBands(NULL,0,20,2,0,PRICE_CLOSE,MODE_MAIN,0)-iBands(NULL,0,20,2,0,PRICE_CLOSE,MODE_MAIN,1) >= -3*Point
                  && iStochastic(NULL,0,13,5,8,MODE_SMA,0,MODE_MAIN,0) < 25 && iStochastic(NULL,0,5,3,3,MODE_SMA,0,MODE_MAIN,0) < 70
                  && count > 0 && iMFI(NULL,0,14,0) > iMFI(NULL,0,14,1)+5 && Bid >= Open[0]  && bflag < 1)
               {
                  Alert(Symbol()," 進入下BUY單範圍");
                  bflag = 1;
                  sflag = 0;
                  count = 0;
               }
               else if(iStochastic(NULL,0,5,3,3,MODE_SMA,0,MODE_MAIN,0) < iStochastic(NULL,0,5,3,3,MODE_SMA,0,MODE_SIGNAL,0))
                  bflag = 0;
            //}
         }
         else
         {
            /*if(iStochastic(NULL,0,5,3,3,MODE_SMA,0,MODE_SIGNAL,1)-iStochastic(NULL,0,5,3,3,MODE_SMA,0,MODE_MAIN,1) 
               < iStochastic(NULL,0,5,3,3,MODE_SMA,0,MODE_SIGNAL,0)-iStochastic(NULL,0,5,3,3,MODE_SMA,0,MODE_MAIN,0) 
               && iStochastic(NULL,0,5,3,3,MODE_SMA,0,MODE_MAIN,0) < iStochastic(NULL,0,5,3,3,MODE_SMA,0,MODE_SIGNAL,0)
               && iStochastic(NULL,0,5,3,3,MODE_SMA,0,MODE_MAIN,0) > 30
               && iStochastic(NULL,0,13,5,8,MODE_SMA,0,MODE_MAIN,0)-iStochastic(NULL,0,13,5,8,MODE_SMA,0,MODE_SIGNAL,0) < 5
               //&& iBands(NULL,0,20,2,0,PRICE_CLOSE,MODE_MAIN,0)-iBands(NULL,0,20,2,0,PRICE_CLOSE,MODE_MAIN,1) <= 3*Point
               && iStochastic(NULL,0,13,5,8,MODE_SMA,0,MODE_MAIN,0) > 75
               && Low[1] < iMA(NULL,0,MAPeriod/2,0,MODE_SMA,PRICE_CLOSE,0) && pathhibar < pathlobar && fsflag < 1)
            {
               Alert(Symbol()," 下花現身");
               fsflag = 1;
               fbflag = 0;
            }*/
            for(int i = 5;i >= 0;i--)
            {
               if(iMFI(NULL,0,14,i) > 77)
               {
                  count++;
                  break;
               }
            }
            //if(/*Low[1] < iMA(NULL,0,MAPeriod,0,MODE_SMA,PRICE_CLOSE,0) && */pathhibar < pathlobar /*&& count > 0*/)
            //{
               if(iStochastic(NULL,0,5,3,3,MODE_SMA,0,MODE_SIGNAL,1)-iStochastic(NULL,0,5,3,3,MODE_SMA,0,MODE_MAIN,1)
                  < iStochastic(NULL,0,5,3,3,MODE_SMA,0,MODE_SIGNAL,0)-iStochastic(NULL,0,5,3,3,MODE_SMA,0,MODE_MAIN,0) 
                  && iStochastic(NULL,0,5,3,3,MODE_SMA,0,MODE_MAIN,0) < iStochastic(NULL,0,5,3,3,MODE_SMA,0,MODE_SIGNAL,0)
                  && iStochastic(NULL,0,13,5,8,MODE_SMA,0,MODE_MAIN,0)-iStochastic(NULL,0,13,5,8,MODE_SMA,0,MODE_SIGNAL,0) < 5
                  //&& iBands(NULL,0,20,2,0,PRICE_CLOSE,MODE_MAIN,0)-iBands(NULL,0,20,2,0,PRICE_CLOSE,MODE_MAIN,1) <= 3*Point
                  && iStochastic(NULL,0,13,5,8,MODE_SMA,0,MODE_MAIN,0) > 75 && iStochastic(NULL,0,5,3,3,MODE_SMA,0,MODE_MAIN,0) > 30
                  && count > 0 && iMFI(NULL,0,14,0) < iMFI(NULL,0,14,1)-5 && Ask <= Open[0]&& sflag < 1)
               {
                  Alert(Symbol()," 進入下SELL單範圍");
                  sflag = 1;
                  bflag = 0;
                  count = 0;
               }
               else if(iStochastic(NULL,0,5,3,3,MODE_SMA,0,MODE_MAIN,0) > iStochastic(NULL,0,5,3,3,MODE_SMA,0,MODE_SIGNAL,0))
                  sflag = 0;
            //}
         }
      }
      else if(flag == 2)
      {
         if(highbar != 0)
         {
            for(int i = 5;i >= 0;i--)
            {
               if(iMFI(NULL,0,14,i) > 77)
               {
                  count++;
                  break;
               }
            }
            //if(/*Low[1] < iMA(NULL,0,MAPeriod,0,MODE_SMA,PRICE_CLOSE,0) && */pathhibar < pathlobar /*&& count > 0*/)
            //{
               if(iStochastic(NULL,0,5,3,3,MODE_SMA,0,MODE_SIGNAL,1)-iStochastic(NULL,0,5,3,3,MODE_SMA,0,MODE_MAIN,1)
                  < iStochastic(NULL,0,5,3,3,MODE_SMA,0,MODE_SIGNAL,0)-iStochastic(NULL,0,5,3,3,MODE_SMA,0,MODE_MAIN,0)
                  && iStochastic(NULL,0,5,3,3,MODE_SMA,0,MODE_MAIN,0) < iStochastic(NULL,0,5,3,3,MODE_SMA,0,MODE_SIGNAL,0)
                  && iStochastic(NULL,0,13,5,8,MODE_SMA,0,MODE_MAIN,0)-iStochastic(NULL,0,13,5,8,MODE_SMA,0,MODE_SIGNAL,0) < 5
                  //&& iBands(NULL,0,20,2,0,PRICE_CLOSE,MODE_MAIN,0)-iBands(NULL,0,20,2,0,PRICE_CLOSE,MODE_MAIN,1) <= 3*Point 
                  && iStochastic(NULL,0,13,5,8,MODE_SMA,0,MODE_MAIN,0) > 75 && iStochastic(NULL,0,5,3,3,MODE_SMA,0,MODE_MAIN,0) > 30
                  && count > 0 && iMFI(NULL,0,14,0) < iMFI(NULL,0,14,1)-5 && Ask <= Open[0] && sflag < 1)
               {
                  Alert(Symbol()," 進入下SELL單範圍");
                  sflag = 1;
                  bflag = 0;
                  count = 0;
               }
               else if(iStochastic(NULL,0,5,3,3,MODE_SMA,0,MODE_MAIN,0) > iStochastic(NULL,0,5,3,3,MODE_SMA,0,MODE_SIGNAL,0))
                  sflag = 0;
            //}
         }
         else
         {
            /*if(iStochastic(NULL,0,5,3,3,MODE_SMA,0,MODE_MAIN,1)-iStochastic(NULL,0,5,3,3,MODE_SMA,0,MODE_SIGNAL,1) 
               < iStochastic(NULL,0,5,3,3,MODE_SMA,0,MODE_MAIN,0)-iStochastic(NULL,0,5,3,3,MODE_SMA,0,MODE_SIGNAL,0)
               && iStochastic(NULL,0,5,3,3,MODE_SMA,0,MODE_MAIN,0) > iStochastic(NULL,0,5,3,3,MODE_SMA,0,MODE_SIGNAL,0)
               && iStochastic(NULL,0,5,3,3,MODE_SMA,0,MODE_MAIN,0) < 70
               && iStochastic(NULL,0,13,5,8,MODE_SMA,0,MODE_SIGNAL,0)-iStochastic(NULL,0,13,5,8,MODE_SMA,0,MODE_MAIN,0) < 5
               //&& iBands(NULL,0,20,2,0,PRICE_CLOSE,MODE_MAIN,0)-iBands(NULL,0,20,2,0,PRICE_CLOSE,MODE_MAIN,1) >= -3*Point
               && iStochastic(NULL,0,13,5,8,MODE_SMA,0,MODE_MAIN,0) < 25
               && pathhibar > pathlobar && High[1] > iMA(NULL,0,MAPeriod/2,0,MODE_SMA,PRICE_CLOSE,0) && fbflag < 1)
            {
               Alert(Symbol()," 上花現身");
               fbflag = 1;
               fsflag = 0;
            }*/
            for(int i = 5;i >= 0;i--)
            {
               if(iMFI(NULL,0,14,i) < 23)
               {
                  count++;
                  break;
               }
            }
            //if(/*High[1] > iMA(NULL,0,MAPeriod,0,MODE_SMA,PRICE_CLOSE,0) && */pathhibar > pathlobar /*&& count > 0*/)
            //{
               if(iStochastic(NULL,0,5,3,3,MODE_SMA,0,MODE_MAIN,1)-iStochastic(NULL,0,5,3,3,MODE_SMA,0,MODE_SIGNAL,1)
                  < iStochastic(NULL,0,5,3,3,MODE_SMA,0,MODE_MAIN,0)-iStochastic(NULL,0,5,3,3,MODE_SMA,0,MODE_SIGNAL,0)
                  && iStochastic(NULL,0,5,3,3,MODE_SMA,0,MODE_MAIN,0) > iStochastic(NULL,0,5,3,3,MODE_SMA,0,MODE_SIGNAL,0)
                  && iStochastic(NULL,0,13,5,8,MODE_SMA,0,MODE_SIGNAL,0)-iStochastic(NULL,0,13,5,8,MODE_SMA,0,MODE_MAIN,0) < 5
                  //&& iBands(NULL,0,20,2,0,PRICE_CLOSE,MODE_MAIN,0)-iBands(NULL,0,20,2,0,PRICE_CLOSE,MODE_MAIN,1) >= -3*Point
                  && iStochastic(NULL,0,13,5,8,MODE_SMA,0,MODE_MAIN,0) < 25 && iStochastic(NULL,0,5,3,3,MODE_SMA,0,MODE_MAIN,0) < 70 
                  && count > 0 && iMFI(NULL,0,14,0) > iMFI(NULL,0,14,1)+5 && Bid >= Open[0] && bflag < 1)
               {
                  Alert(Symbol()," 進入下BUY單範圍");
                  bflag = 1;
                  sflag = 0;
                  count = 0;
               }
               else if(iStochastic(NULL,0,5,3,3,MODE_SMA,0,MODE_MAIN,0) < iStochastic(NULL,0,5,3,3,MODE_SMA,0,MODE_SIGNAL,0))
                  bflag = 0;
            //}
         }
      }
      
      /*if(flag == 1)
      {
         if(lowbar != 0)
         {
            if(cp > cl+指標距離通知點數*10*Point && cp < cl+指標距離通知點數*10*Point+通知範圍*10*Point && bflag < 1)
            {
               Alert(Symbol()," ",Period()," OrderBuy placed stand by");
               bflag = 1;
            }
         }
         else
         {
            if(cp < ch-指標距離通知點數*10*Point && cp > ch-指標距離通知點數*10*Point-通知範圍*10*Point && sflag < 1)
            {
               Alert(Symbol()," ",Period()," OrderSell placed stand by");
               sflag = 1;
            }
         }
      }
      else if(flag == 2)
      {   
         if(highbar != 0)
         {
            if(cp < ch-指標距離通知點數*10*Point && cp > ch-指標距離通知點數*10*Point-通知範圍*10*Point && sflag < 1)
            {
               Alert(Symbol()," ",Period()," OrderSell placed stand by");
               sflag = 1;
            }
         }
         else
         {
            if(cp > cl+指標距離通知點數*10*Point && cp < cl+指標距離通知點數*10*Point+通知範圍*10*Point && bflag < 1)
            {
            Alert(Symbol()," ",Period()," OrderBuy placed stand by");
            bflag = 1;
            }
         }
      }*/
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
