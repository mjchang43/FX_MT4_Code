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
int            lowbar,highbar,totalbars;
int            flag = 0;
int            alert = 0;
int            buymark = 0;
int            sellmark = 0;
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
      double K33Previous,D33Previous,K33Current,D33Current,AOCurrent,AOPrevious,AO2;
      double K58Current,D58Current,K58Previous,D58Previous,BBCurrent,BBPrevious;
      K33Previous = iStochastic(NULL,0,5,3,3,MODE_SMA,0,MODE_MAIN,1);
      D33Previous = iStochastic(NULL,0,5,3,3,MODE_SMA,0,MODE_SIGNAL,1);
      K33Current = iStochastic(NULL,0,5,3,3,MODE_SMA,0,MODE_MAIN,0);
      D33Current = iStochastic(NULL,0,5,3,3,MODE_SMA,0,MODE_SIGNAL,0);
      K58Current = iStochastic(NULL,0,13,5,8,MODE_SMA,0,MODE_MAIN,0);
      D58Current = iStochastic(NULL,0,13,5,8,MODE_SMA,0,MODE_SIGNAL,0);
      K58Previous = iStochastic(NULL,0,13,5,8,MODE_SMA,0,MODE_MAIN,1);
      D58Previous = iStochastic(NULL,0,13,5,8,MODE_SMA,0,MODE_SIGNAL,1);
      BBCurrent = iBands(NULL,0,20,2,0,PRICE_CLOSE,MODE_MAIN,0);
      BBPrevious = iBands(NULL,0,20,2,0,PRICE_CLOSE,MODE_MAIN,1);
      AOCurrent = iAO(NULL,0,0);
      AOPrevious = iAO(NULL,0,1);
      AO2 = iAO(NULL,0,2);
      if(flag == 1)
      {
         if(lowbar != 0)
         {
            if(ChkKD("buy") && D58Previous-K58Previous < 5 && K58Previous < 50 && K33Previous < 70 && AOPrevious > AO2 && buymark == 0)
            {
               Alert(Symbol()," 進入下BUY單範圍");
               buymark = 1;
            }
            else if(K33Previous < D33Previous && !ChkPool("buy"))
               buymark = 0;
         }
         else 
         {
            if(ChkKD("sell") && K58Previous-D58Previous < 5 && K58Previous > 50 && K33Previous > 30 && AOPrevious < AO2 && sellmark == 0)
            {
               Alert(Symbol()," 進入下SELL單範圍");
               sellmark = 1;
            }
            else if(K33Previous > D33Previous && !ChkPool("sell"))
               sellmark = 0;
         }
      }
      else if(flag == 2)
      {
         if(highbar != 0)
         {
            if(ChkKD("sell") && K58Previous-D58Previous < 5 && K58Previous > 50 && K33Previous > 30 && AOPrevious < AO2 && sellmark == 0)
            {
               Alert(Symbol()," 進入下SELL單範圍");
               sellmark = 1;
            }
            else if(K33Previous > D33Previous && !ChkPool("sell"))
               sellmark = 0;
         }
         else
         {
            if(ChkKD("buy") && D58Previous-K58Previous < 5 && K58Previous < 50 && K33Previous < 70 && AOPrevious > AO2 && buymark == 0)
            {
               Alert(Symbol()," 進入下BUY單範圍");
               buymark = 1;
            }
            else if(K33Current < D33Current && !ChkPool("buy"))
               buymark = 0;
         }
      }
      if((K58Previous < 35 && K33Previous > D33Previous) || (K58Previous > 65 && K33Previous < D33Previous))
      {
         if(alert == 0)
         {
            Alert(Symbol()," 確認戰場士兵!");
            alert = 1;
         }
      }
      else
         alert = 0;
   //--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
bool ChkPool(string mark)
{
   int totalorders = OrdersTotal();
   if(StringCompare(mark,"buy") == 0)
   {
      for(int i = totalorders-1;i >= 0;i--)
      {
         if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
         {
            if(OrderSymbol() == Symbol() && OrderType() == OP_BUY)
               return true;
         }
      }
      return false;
   }
   else if(StringCompare(mark,"sell") == 0)
   {
      for(int i = totalorders-1;i >= 0;i--)
      {
         if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
         {
            if(OrderSymbol() == Symbol() && OrderType() == OP_SELL)
               return true;
         }
      }
      return false;
   }
   return false;
}
//+------------------------------------------------------------------+
bool ChkKD(string mark)
{
   if(StringCompare(mark,"buy") == 0)
   {
      for(int i = 0;i < 3;i++)
      {
         if(iStochastic(NULL,0,5,3,3,MODE_SMA,0,MODE_MAIN,i+1) < iStochastic(NULL,0,5,3,3,MODE_SMA,0,MODE_SIGNAL,i+1)
            && iStochastic(NULL,0,5,3,3,MODE_SMA,0,MODE_MAIN,i) >= iStochastic(NULL,0,5,3,3,MODE_SMA,0,MODE_SIGNAL,i))
            return true;
      }
      return false;
   }
   else if(StringCompare(mark,"sell") == 0)
   {
      for(int i = 0;i < 3;i++)
      {
         if(iStochastic(NULL,0,5,3,3,MODE_SMA,0,MODE_MAIN,i+1) > iStochastic(NULL,0,5,3,3,MODE_SMA,0,MODE_SIGNAL,i+1)
            && iStochastic(NULL,0,5,3,3,MODE_SMA,0,MODE_MAIN,i) <= iStochastic(NULL,0,5,3,3,MODE_SMA,0,MODE_SIGNAL,i))
            return true;
      }
      return false;
   }
   return false;
}