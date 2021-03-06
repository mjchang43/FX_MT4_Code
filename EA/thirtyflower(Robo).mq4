//+------------------------------------------------------------------+
//|                                                         三十大花.mq4 |
//|                        Copyright 2014, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2014, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"
#property strict
//--- parameters
int            flag = 0;
int            bflag = 0;
int            sflag = 0;
int            highbar,lowbar,totalbars;
int            bluecount = 0;
int            redcount = 0;
int            buyticket,sellticket;
//--- input parameters
input double   指標間隔 = 30;
input double   順勢手數 = 0.03;
input double   順勢止損 = 0;
input double   順勢獲利 = 15;
input double   順勢追蹤止損 = 7.5;
input double   逆勢手數 = 0.01;
input double   逆勢止損 = 0;
input double   逆勢獲利 = 10;
input double   逆勢追蹤止損 = 5;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
      
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
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
                  lowbar = i;
               }
               
               if(High[i] > iBands(NULL,0,20,1.8,0,PRICE_CLOSE,MODE_UPPER,i))
               {
                  highbar = i;
                  flag = 2;
               }
               continue;
            
            case 2:
               if(High[i] > High[highbar])
               {
                  highbar = i;
               }
               
               if(Low[i] < iBands(NULL,0,20,1.8,0,PRICE_CLOSE,MODE_LOWER,(i)))
               {
                  lowbar = i;
                  flag = 1;
               }
               continue;
               
            default:
               if(Low[i] < iBands(NULL,0,20,1.8,0,PRICE_CLOSE,MODE_LOWER,i))
               {
                  lowbar = i;
                  flag = 1;
               }
               if(High[i] > iBands(NULL,0,20,1.8,0,PRICE_CLOSE,MODE_UPPER,i))
               {
                  highbar = i;
                  flag = 2;
               }
               continue;
         }
      }
      double cp = iClose(NULL,0,0);
      double cl = iLow(NULL,0,lowbar);
      double ch = iHigh(NULL,0,highbar);
      
      if(flag == 1)
      {
         if(lowbar != 0)  //指標在低點,但不在現bar
         {
            if(Bid >= cl+指標間隔*Point && Bid < cl+(指標間隔+1)*Point && bflag < 1)
            {
               sflag = 0;
               if(iStochastic(NULL,PERIOD_H1,13,5,8,MODE_SMA,0,MODE_MAIN,0) < 80 && iStochastic(NULL,0,13,5,8,MODE_SMA,0,MODE_MAIN,0) < 85
                  && iStochastic(NULL,PERIOD_H1,13,5,8,MODE_SMA,0,MODE_MAIN,0) > iStochastic(NULL,PERIOD_H1,13,5,8,MODE_SMA,0,MODE_SIGNAL,0)+3
                  && iStochastic(NULL,0,13,5,8,MODE_SMA,0,MODE_MAIN,0) > iStochastic(NULL,0,13,5,8,MODE_SMA,0,MODE_SIGNAL,0))
               {
                  for(int i = 3; i >= 0; i--)  //前三根bar須有兩根以上為黑棒且高點不過,現棒也為高點不過
                  {
                     if(i > 0)
                     {
                        if(Close[i] >= Open[i] && High[i] < cl+(指標間隔+1)*Point)
                        {
                           bluecount++;
                        }
                     }
                     else
                     {
                        if(High[i] > cl+(指標間隔+3)*Point)
                           bluecount -= 2;
                     }
                     
                  }
                  if(bluecount >= 1 && Ask-Bid <= 5*Point)   //點差限制
                  {
                     if((iStochastic(NULL,PERIOD_H1,13,5,8,MODE_SMA,0,MODE_MAIN,0) > 20 && iStochastic(NULL,PERIOD_H1,13,5,8,MODE_SMA,0,MODE_MAIN,0) <= 35
                        && iStochastic(NULL,0,13,5,8,MODE_SMA,0,MODE_MAIN,0) < 80 && iOsMA(NULL,0,12,26,9,PRICE_CLOSE,0) > 0)
                        || (iStochastic(NULL,PERIOD_H1,13,5,8,MODE_SMA,0,MODE_MAIN,0) > 35 && iStochastic(NULL,PERIOD_H1,13,5,8,MODE_SMA,0,MODE_MAIN,0) <= 65 
                        && iStochastic(NULL,PERIOD_H1,13,5,8,MODE_SMA,0,MODE_SIGNAL,0) <= 50 
                        && (iStochastic(NULL,PERIOD_H1,13,5,8,MODE_SMA,0,MODE_MAIN,5)-iStochastic(NULL,PERIOD_H1,13,5,8,MODE_SMA,0,MODE_MAIN,3)) < 0 
                        && (iStochastic(NULL,PERIOD_H1,13,5,8,MODE_SMA,0,MODE_MAIN,3)-iStochastic(NULL,PERIOD_H1,13,5,8,MODE_SMA,0,MODE_MAIN,1)) < 0
                        && iStochastic(NULL,0,13,5,8,MODE_SMA,0,MODE_MAIN,0) < 80 && iOsMA(NULL,0,12,26,9,PRICE_CLOSE,0) > 0)
                        || (iStochastic(NULL,PERIOD_H1,13,5,8,MODE_SMA,0,MODE_MAIN,0) > 65 && iStochastic(NULL,PERIOD_H1,13,5,8,MODE_SMA,0,MODE_SIGNAL,0) <= 50
                        && iStochastic(NULL,0,13,5,8,MODE_SMA,0,MODE_MAIN,0) < 80 && iOsMA(NULL,0,12,26,9,PRICE_CLOSE,0) > 0))   //順逆勢判斷
                     {
                        if((iStochastic(NULL,0,13,5,8,MODE_SMA,0,MODE_MAIN,0) <= 35 && iStochastic(NULL,PERIOD_H4,13,5,8,MODE_SMA,0,MODE_MAIN,0) > iStochastic(NULL,PERIOD_H4,13,5,8,MODE_SMA,0,MODE_SIGNAL,0)
                           && (iStochastic(NULL,PERIOD_H4,13,5,8,MODE_SMA,0,MODE_MAIN,0)-iStochastic(NULL,PERIOD_H4,13,5,8,MODE_SMA,0,MODE_MAIN,1)) > 3) 
                           || (iStochastic(NULL,0,13,5,8,MODE_SMA,0,MODE_MAIN,0) > 65 && iStochastic(NULL,PERIOD_H4,13,5,8,MODE_SMA,0,MODE_MAIN,0) > iStochastic(NULL,PERIOD_H4,13,5,8,MODE_SMA,0,MODE_SIGNAL,0)
                           && (iStochastic(NULL,PERIOD_H4,13,5,8,MODE_SMA,0,MODE_MAIN,0)-iStochastic(NULL,PERIOD_H4,13,5,8,MODE_SMA,0,MODE_MAIN,1)) > 3)
                           || (iStochastic(NULL,0,13,5,8,MODE_SMA,0,MODE_MAIN,0) > 35 && iStochastic(NULL,0,13,5,8,MODE_SMA,0,MODE_MAIN,0) <= 65 
                           && (iStochastic(NULL,0,13,5,8,MODE_SMA,0,MODE_MAIN,5)-iStochastic(NULL,0,13,5,8,MODE_SMA,0,MODE_MAIN,3)) < 0 
                           && (iStochastic(NULL,0,13,5,8,MODE_SMA,0,MODE_MAIN,3)-iStochastic(NULL,0,13,5,8,MODE_SMA,0,MODE_MAIN,1)) < 0
                           && iStochastic(NULL,PERIOD_H4,13,5,8,MODE_SMA,0,MODE_MAIN,0) > iStochastic(NULL,PERIOD_H4,13,5,8,MODE_SMA,0,MODE_SIGNAL,0)
                           && (iStochastic(NULL,PERIOD_H4,13,5,8,MODE_SMA,0,MODE_MAIN,0)-iStochastic(NULL,PERIOD_H4,13,5,8,MODE_SMA,0,MODE_MAIN,1)) > 3))
                        {
                           buyticket = OrderSend(NULL,OP_BUY,順勢手數,Ask,3,cl+10*Point,cl+(指標間隔+順勢獲利)*Point);
                           if(buyticket < 0)
                           {
                              Alert(Symbol()," ",buyticket," Orderbuy failed with error #",GetLastError());
                           }
                           else
                           {
                              Alert(Symbol()," ",buyticket," Orderbuy placed successfully");
                              bflag = 1;
                              bluecount = 0;
                           }
                        }
                        else
                        {
                           buyticket = OrderSend(NULL,OP_BUY,逆勢手數,Ask,3,cl+10*Point,cl+(指標間隔+逆勢獲利)*Point);
                           if(buyticket < 0)
                           {
                              Alert(Symbol()," ",buyticket," Orderbuy failed with error #",GetLastError());
                           }
                           else
                           {
                              Alert(Symbol()," ",buyticket," Orderbuy placed successfully");
                              bflag = 1;
                              bluecount = 0;
                           }
                        }
                     }
                     else
                     {
                        buyticket = OrderSend(NULL,OP_BUY,逆勢手數,Ask,3,cl+10*Point,cl+(指標間隔+逆勢獲利)*Point);
                        if(buyticket < 0)
                        {
                           Alert(Symbol()," ",buyticket," Orderbuy failed with error #",GetLastError());
                        }
                        else
                        {
                           Alert(Symbol()," ",buyticket," Orderbuy placed successfully");
                           bflag = 1;
                           bluecount = 0;
                        }
                        return;
                     }
                  }
               }
            }
         }
         else
         {
            if(Ask <= ch-指標間隔*Point && Ask > ch-(指標間隔+1)*Point && sflag < 1)
            {
               bflag = 0;
               if(iStochastic(NULL,PERIOD_H1,13,5,8,MODE_SMA,0,MODE_MAIN,0) > 20 && iStochastic(NULL,0,13,5,8,MODE_SMA,0,MODE_MAIN,0) > 15
                  && iStochastic(NULL,PERIOD_H1,13,5,8,MODE_SMA,0,MODE_MAIN,0) < iStochastic(NULL,PERIOD_H1,13,5,8,MODE_SMA,0,MODE_SIGNAL,0)-3
                  && iStochastic(NULL,0,13,5,8,MODE_SMA,0,MODE_MAIN,0) < iStochastic(NULL,0,13,5,8,MODE_SMA,0,MODE_SIGNAL,0))
               {
                  for(int i = 3; i >= 0; i--)
                  {
                     if(i > 0)
                     {
                        if(Close[i] <= Open[i] && Low[i] > ch-(指標間隔+1)*Point)
                           redcount++;
                     }
                     else
                     {
                        if(Low[i] < ch-(指標間隔+3)*Point)
                           redcount -= 2;
                     }
                  }
                  if(redcount >= 1 && Ask-Bid <= 5*Point)
                  {
                     if((iStochastic(NULL,PERIOD_H1,13,5,8,MODE_SMA,0,MODE_MAIN,0) < 80 && iStochastic(NULL,PERIOD_H1,13,5,8,MODE_SMA,0,MODE_MAIN,0) >= 65 
                        && iStochastic(NULL,0,13,5,8,MODE_SMA,0,MODE_MAIN,0) > 20 && iOsMA(NULL,0,12,26,9,PRICE_CLOSE,0) < 0)
                        || (iStochastic(NULL,PERIOD_H1,13,5,8,MODE_SMA,0,MODE_MAIN,0) < 65 && iStochastic(NULL,PERIOD_H1,13,5,8,MODE_SMA,0,MODE_MAIN,0) >= 35 
                        && (iStochastic(NULL,PERIOD_H1,13,5,8,MODE_SMA,0,MODE_MAIN,5)-iStochastic(NULL,PERIOD_H1,13,5,8,MODE_SMA,0,MODE_MAIN,3)) > 0 
                        && (iStochastic(NULL,PERIOD_H1,13,5,8,MODE_SMA,0,MODE_MAIN,3)-iStochastic(NULL,PERIOD_H1,13,5,8,MODE_SMA,0,MODE_MAIN,1)) > 0 
                        && iStochastic(NULL,PERIOD_H1,13,5,8,MODE_SMA,0,MODE_SIGNAL,0) >= 50
                        && iStochastic(NULL,0,13,5,8,MODE_SMA,0,MODE_MAIN,0) > 20 && iOsMA(NULL,0,12,26,9,PRICE_CLOSE,0) < 0) 
                        || (iStochastic(NULL,PERIOD_H1,13,5,8,MODE_SMA,0,MODE_MAIN,0) < 35 && iStochastic(NULL,PERIOD_H1,13,5,8,MODE_SMA,0,MODE_SIGNAL,0) >= 50
                        && iStochastic(NULL,0,13,5,8,MODE_SMA,0,MODE_MAIN,0) > 20 && iOsMA(NULL,0,12,26,9,PRICE_CLOSE,0) < 0))
                     {
                        if((iStochastic(NULL,0,13,5,8,MODE_SMA,0,MODE_MAIN,0) >= 65 && iStochastic(NULL,PERIOD_H4,13,5,8,MODE_SMA,0,MODE_MAIN,0) < iStochastic(NULL,PERIOD_H4,13,5,8,MODE_SMA,0,MODE_SIGNAL,0)
                           && (iStochastic(NULL,PERIOD_H4,13,5,8,MODE_SMA,0,MODE_MAIN,1)-iStochastic(NULL,PERIOD_H4,13,5,8,MODE_SMA,0,MODE_MAIN,0)) > 3) 
                           || (iStochastic(NULL,0,13,5,8,MODE_SMA,0,MODE_MAIN,0) < 35 && iStochastic(NULL,PERIOD_H4,13,5,8,MODE_SMA,0,MODE_MAIN,0) < iStochastic(NULL,PERIOD_H4,13,5,8,MODE_SMA,0,MODE_SIGNAL,0)
                           && (iStochastic(NULL,PERIOD_H4,13,5,8,MODE_SMA,0,MODE_MAIN,1)-iStochastic(NULL,PERIOD_H4,13,5,8,MODE_SMA,0,MODE_MAIN,0)) > 3)
                           || (iStochastic(NULL,0,13,5,8,MODE_SMA,0,MODE_MAIN,0) < 65 && iStochastic(NULL,0,13,5,8,MODE_SMA,0,MODE_MAIN,0) >= 35 
                           && (iStochastic(NULL,0,13,5,8,MODE_SMA,0,MODE_MAIN,5)-iStochastic(NULL,0,13,5,8,MODE_SMA,0,MODE_MAIN,3)) > 0 
                           && (iStochastic(NULL,0,13,5,8,MODE_SMA,0,MODE_MAIN,3)-iStochastic(NULL,0,13,5,8,MODE_SMA,0,MODE_MAIN,1)) > 0
                           && iStochastic(NULL,PERIOD_H4,13,5,8,MODE_SMA,0,MODE_MAIN,0) < iStochastic(NULL,PERIOD_H4,13,5,8,MODE_SMA,0,MODE_SIGNAL,0)
                           && (iStochastic(NULL,PERIOD_H4,13,5,8,MODE_SMA,0,MODE_MAIN,1)-iStochastic(NULL,PERIOD_H4,13,5,8,MODE_SMA,0,MODE_MAIN,0)) > 3))
                        {
                           sellticket = OrderSend(NULL,OP_SELL,順勢手數,Bid,3,ch-10*Point,ch-(指標間隔+順勢獲利)*Point);
                           if(sellticket < 0)
                           {
                              Alert(Symbol()," ",sellticket," Ordersell failed with error #",GetLastError());
                           }
                           else
                           {
                              Alert(Symbol()," ",sellticket," Ordersell placed successfully");
                              sflag = 1;
                              redcount = 0;
                           }
                           return;
                        }
                        else
                        {
                           sellticket = OrderSend(NULL,OP_SELL,逆勢手數,Bid,3,ch-10*Point,ch-(指標間隔+逆勢獲利)*Point);
                           if(sellticket < 0)
                           {
                              Alert(Symbol()," ",sellticket," Ordersell failed with error #",GetLastError());
                           }
                           else
                           {
                              Alert(Symbol()," ",sellticket," Ordersell placed successfully");
                              sflag = 1;
                              redcount = 0;
                           }
                           return;
                        }
                     }
                     else
                     {
                        sellticket = OrderSend(NULL,OP_SELL,逆勢手數,Bid,3,ch-10*Point,ch-(指標間隔+逆勢獲利)*Point);
                        if(sellticket < 0)
                        {
                           Alert(Symbol()," ",sellticket," Ordersell failed with error #",GetLastError());
                        }
                        else
                        {
                           Alert(Symbol()," ",sellticket," Ordersell placed successfully");
                           sflag = 1;
                           redcount = 0;
                        }
                        return;
                     }
                  }
               }
            }
         }
      }
      else if(flag == 2)
      {   
         if(highbar != 0)
         {
            if(Ask <= ch-指標間隔*Point && Ask > ch-(指標間隔+1)*Point && sflag < 1)
            {
               bflag = 0;
               if(iStochastic(NULL,PERIOD_H1,13,5,8,MODE_SMA,0,MODE_MAIN,0) > 20 && iStochastic(NULL,0,13,5,8,MODE_SMA,0,MODE_MAIN,0) > 15
                  && iStochastic(NULL,PERIOD_H1,13,5,8,MODE_SMA,0,MODE_MAIN,0) < iStochastic(NULL,PERIOD_H1,13,5,8,MODE_SMA,0,MODE_SIGNAL,0)
                  && iStochastic(NULL,0,13,5,8,MODE_SMA,0,MODE_MAIN,0) < iStochastic(NULL,0,13,5,8,MODE_SMA,0,MODE_SIGNAL,0))
               {
                  for(int i = 3; i >= 0; i--)
                  {
                     if(i > 0)
                     {
                        if(Close[i] <= Open[i] && Low[i] > ch-(指標間隔+1)*Point)
                           redcount++;
                     }
                     else
                     {
                        if(Low[i] < ch-(指標間隔+3)*Point)
                           redcount -= 2;
                     }
                  }
                  if(redcount >= 1 && Ask-Bid <= 5*Point)
                  {
                     if((iStochastic(NULL,PERIOD_H1,13,5,8,MODE_SMA,0,MODE_MAIN,0) < 80 && iStochastic(NULL,PERIOD_H1,13,5,8,MODE_SMA,0,MODE_MAIN,0) >= 65 
                        && iStochastic(NULL,0,13,5,8,MODE_SMA,0,MODE_MAIN,0) > 20 && iOsMA(NULL,0,12,26,9,PRICE_CLOSE,0) < 0)
                        || (iStochastic(NULL,PERIOD_H1,13,5,8,MODE_SMA,0,MODE_MAIN,0) < 65 && iStochastic(NULL,PERIOD_H1,13,5,8,MODE_SMA,0,MODE_MAIN,0) >= 35 
                        && (iStochastic(NULL,PERIOD_H1,13,5,8,MODE_SMA,0,MODE_MAIN,5)-iStochastic(NULL,PERIOD_H1,13,5,8,MODE_SMA,0,MODE_MAIN,3)) > 0 
                        && (iStochastic(NULL,PERIOD_H1,13,5,8,MODE_SMA,0,MODE_MAIN,3)-iStochastic(NULL,PERIOD_H1,13,5,8,MODE_SMA,0,MODE_MAIN,1)) > 0 
                        && iStochastic(NULL,PERIOD_H1,13,5,8,MODE_SMA,0,MODE_SIGNAL,0) >= 50
                        && iStochastic(NULL,0,13,5,8,MODE_SMA,0,MODE_MAIN,0) > 20 && iOsMA(NULL,0,12,26,9,PRICE_CLOSE,0) < 0) 
                        || (iStochastic(NULL,PERIOD_H1,13,5,8,MODE_SMA,0,MODE_MAIN,0) < 35 && iStochastic(NULL,PERIOD_H1,13,5,8,MODE_SMA,0,MODE_SIGNAL,0) >= 50
                        && iStochastic(NULL,0,13,5,8,MODE_SMA,0,MODE_MAIN,0) > 20 && iOsMA(NULL,0,12,26,9,PRICE_CLOSE,0) < 0))
                     {
                        if((iStochastic(NULL,0,13,5,8,MODE_SMA,0,MODE_MAIN,0) >= 65 && iStochastic(NULL,PERIOD_H4,13,5,8,MODE_SMA,0,MODE_MAIN,0) < iStochastic(NULL,PERIOD_H4,13,5,8,MODE_SMA,0,MODE_SIGNAL,0)
                           && (iStochastic(NULL,PERIOD_H4,13,5,8,MODE_SMA,0,MODE_MAIN,1)-iStochastic(NULL,PERIOD_H4,13,5,8,MODE_SMA,0,MODE_MAIN,0)) > 3) 
                           || (iStochastic(NULL,0,13,5,8,MODE_SMA,0,MODE_MAIN,0) < 35 && iStochastic(NULL,PERIOD_H4,13,5,8,MODE_SMA,0,MODE_MAIN,0) < iStochastic(NULL,PERIOD_H4,13,5,8,MODE_SMA,0,MODE_SIGNAL,0)
                           && (iStochastic(NULL,PERIOD_H4,13,5,8,MODE_SMA,0,MODE_MAIN,1)-iStochastic(NULL,PERIOD_H4,13,5,8,MODE_SMA,0,MODE_MAIN,0)) > 3)
                           || (iStochastic(NULL,0,13,5,8,MODE_SMA,0,MODE_MAIN,0) < 65 && iStochastic(NULL,0,13,5,8,MODE_SMA,0,MODE_MAIN,0) >= 35 
                           && (iStochastic(NULL,0,13,5,8,MODE_SMA,0,MODE_MAIN,5)-iStochastic(NULL,0,13,5,8,MODE_SMA,0,MODE_MAIN,3)) > 0 
                           && (iStochastic(NULL,0,13,5,8,MODE_SMA,0,MODE_MAIN,3)-iStochastic(NULL,0,13,5,8,MODE_SMA,0,MODE_MAIN,1)) > 0
                           && iStochastic(NULL,PERIOD_H4,13,5,8,MODE_SMA,0,MODE_MAIN,0) < iStochastic(NULL,PERIOD_H4,13,5,8,MODE_SMA,0,MODE_SIGNAL,0)
                           && (iStochastic(NULL,PERIOD_H4,13,5,8,MODE_SMA,0,MODE_MAIN,1)-iStochastic(NULL,PERIOD_H4,13,5,8,MODE_SMA,0,MODE_MAIN,0)) > 3))
                        {
                           sellticket = OrderSend(NULL,OP_SELL,順勢手數,Bid,3,ch-10*Point,ch-(指標間隔+順勢獲利)*Point);
                           if(sellticket < 0)
                           {
                              Alert(Symbol()," ",sellticket," Ordersell failed with error #",GetLastError());
                           }
                           else
                           {
                              Alert(Symbol()," ",sellticket," Ordersell placed successfully");
                              sflag = 1;
                              redcount = 0;
                           }
                           return;
                        }
                        else
                        {
                           sellticket = OrderSend(NULL,OP_SELL,逆勢手數,Bid,3,ch-10*Point,ch-(指標間隔+逆勢獲利)*Point);
                           if(sellticket < 0)
                           {
                              Alert(Symbol()," ",sellticket," Ordersell failed with error #",GetLastError());
                           }
                           else
                           {
                              Alert(Symbol()," ",sellticket," Ordersell placed successfully");
                              sflag = 1;
                              redcount = 0;
                           }
                           return;
                        }
                     }
                     else
                     {
                        sellticket = OrderSend(NULL,OP_SELL,逆勢手數,Bid,3,ch-10*Point,ch-(指標間隔+逆勢獲利)*Point);
                        if(sellticket < 0)
                        {
                           Alert(Symbol()," ",sellticket," Ordersell failed with error #",GetLastError());
                        }
                        else
                        {
                           Alert(Symbol()," ",sellticket," Ordersell placed successfully");
                           sflag = 1;
                           redcount = 0;
                        }
                        return;
                     }
                  }
               }
            }
         }
         else
         {
            if(Bid >= cl+指標間隔*Point && Bid < cl+(指標間隔+1)*Point && bflag < 1)
            {
               sflag = 0;
               if(iStochastic(NULL,PERIOD_H1,13,5,8,MODE_SMA,0,MODE_MAIN,0) < 80 && iStochastic(NULL,0,13,5,8,MODE_SMA,0,MODE_MAIN,0) < 85 
                  && iStochastic(NULL,PERIOD_H1,13,5,8,MODE_SMA,0,MODE_MAIN,0) > iStochastic(NULL,PERIOD_H1,13,5,8,MODE_SMA,0,MODE_SIGNAL,0)
                  && iStochastic(NULL,0,13,5,8,MODE_SMA,0,MODE_MAIN,0) > iStochastic(NULL,0,13,5,8,MODE_SMA,0,MODE_SIGNAL,0))
               {
                  for(int i = 3; i >= 0; i--)
                  {
                     if(i > 0)
                     {
                        if(Close[i] >= Open[i] && High[i] < cl+(指標間隔+1)*Point)
                           bluecount++;
                     }
                     else
                     {
                        if(High[i] > cl+(指標間隔+3)*Point)
                           bluecount -= 2;
                     }
                  }
                  if(bluecount >= 1 && Ask-Bid <= 5*Point)
                  {
                     if((iStochastic(NULL,PERIOD_H1,13,5,8,MODE_SMA,0,MODE_MAIN,0) > 20 && iStochastic(NULL,PERIOD_H1,13,5,8,MODE_SMA,0,MODE_MAIN,0) <= 35
                        && iStochastic(NULL,0,13,5,8,MODE_SMA,0,MODE_MAIN,0) < 80 && iOsMA(NULL,0,12,26,9,PRICE_CLOSE,0) > 0)
                        || (iStochastic(NULL,PERIOD_H1,13,5,8,MODE_SMA,0,MODE_MAIN,0) > 35 && iStochastic(NULL,PERIOD_H1,13,5,8,MODE_SMA,0,MODE_MAIN,0) <= 65 
                        && iStochastic(NULL,PERIOD_H1,13,5,8,MODE_SMA,0,MODE_SIGNAL,0) <= 50 
                        && (iStochastic(NULL,PERIOD_H1,13,5,8,MODE_SMA,0,MODE_MAIN,5)-iStochastic(NULL,PERIOD_H1,13,5,8,MODE_SMA,0,MODE_MAIN,3)) < 0 
                        && (iStochastic(NULL,PERIOD_H1,13,5,8,MODE_SMA,0,MODE_MAIN,3)-iStochastic(NULL,PERIOD_H1,13,5,8,MODE_SMA,0,MODE_MAIN,1)) < 0
                        && iStochastic(NULL,0,13,5,8,MODE_SMA,0,MODE_MAIN,0) < 80 && iOsMA(NULL,0,12,26,9,PRICE_CLOSE,0) > 0)
                        || (iStochastic(NULL,PERIOD_H1,13,5,8,MODE_SMA,0,MODE_MAIN,0) > 65 && iStochastic(NULL,PERIOD_H1,13,5,8,MODE_SMA,0,MODE_SIGNAL,0) <= 50
                        && iStochastic(NULL,0,13,5,8,MODE_SMA,0,MODE_MAIN,0) < 80 && iOsMA(NULL,0,12,26,9,PRICE_CLOSE,0) > 0))
                     {
                        if((iStochastic(NULL,0,13,5,8,MODE_SMA,0,MODE_MAIN,0) <= 35 && iStochastic(NULL,PERIOD_H4,13,5,8,MODE_SMA,0,MODE_MAIN,0) > iStochastic(NULL,PERIOD_H4,13,5,8,MODE_SMA,0,MODE_SIGNAL,0)
                           && (iStochastic(NULL,PERIOD_H4,13,5,8,MODE_SMA,0,MODE_MAIN,0)-iStochastic(NULL,PERIOD_H4,13,5,8,MODE_SMA,0,MODE_MAIN,1)) > 3) 
                           || (iStochastic(NULL,0,13,5,8,MODE_SMA,0,MODE_MAIN,0) > 65 && iStochastic(NULL,PERIOD_H4,13,5,8,MODE_SMA,0,MODE_MAIN,0) > iStochastic(NULL,PERIOD_H4,13,5,8,MODE_SMA,0,MODE_SIGNAL,0)
                           && (iStochastic(NULL,PERIOD_H4,13,5,8,MODE_SMA,0,MODE_MAIN,0)-iStochastic(NULL,PERIOD_H4,13,5,8,MODE_SMA,0,MODE_MAIN,1)) > 3)
                           || (iStochastic(NULL,0,13,5,8,MODE_SMA,0,MODE_MAIN,0) > 35 && iStochastic(NULL,0,13,5,8,MODE_SMA,0,MODE_MAIN,0) <= 65 
                           && (iStochastic(NULL,0,13,5,8,MODE_SMA,0,MODE_MAIN,5)-iStochastic(NULL,0,13,5,8,MODE_SMA,0,MODE_MAIN,3)) < 0 
                           && (iStochastic(NULL,0,13,5,8,MODE_SMA,0,MODE_MAIN,3)-iStochastic(NULL,0,13,5,8,MODE_SMA,0,MODE_MAIN,1)) < 0
                           && iStochastic(NULL,PERIOD_H4,13,5,8,MODE_SMA,0,MODE_MAIN,0) > iStochastic(NULL,PERIOD_H4,13,5,8,MODE_SMA,0,MODE_SIGNAL,0)
                           && (iStochastic(NULL,PERIOD_H4,13,5,8,MODE_SMA,0,MODE_MAIN,0)-iStochastic(NULL,PERIOD_H4,13,5,8,MODE_SMA,0,MODE_MAIN,1)) > 3))
                        {
                           buyticket = OrderSend(NULL,OP_BUY,順勢手數,Ask,3,cl+10*Point,cl+(指標間隔+順勢獲利)*Point);
                           if(buyticket < 0)
                           {
                              Alert(Symbol()," ",buyticket," Orderbuy failed with error #",GetLastError());
                           }
                           else
                           {
                              Alert(Symbol()," ",buyticket," Orderbuy placed successfully");
                              bflag = 1;
                              bluecount = 0;
                           }
                           return;
                        }
                        else
                        {
                           buyticket = OrderSend(NULL,OP_BUY,逆勢手數,Ask,3,cl+10*Point,cl+(指標間隔+逆勢獲利)*Point);
                           if(buyticket < 0)
                           {
                              Alert(Symbol()," ",buyticket," Orderbuy failed with error #",GetLastError());
                           }
                           else
                           {
                              Alert(Symbol()," ",buyticket," Orderbuy placed successfully");
                              bflag = 1;
                              bluecount = 0;
                           }
                           return;
                        }
                     }
                     else
                     {
                        buyticket = OrderSend(NULL,OP_BUY,逆勢手數,Ask,3,cl+10*Point,cl+(指標間隔+逆勢獲利)*Point);
                        if(buyticket < 0)
                        {
                           Alert(Symbol()," ",buyticket," Orderbuy failed with error #",GetLastError());
                        }
                        else
                        {
                           Alert(Symbol()," ",buyticket," Orderbuy placed successfully");
                           bflag = 1;
                           bluecount = 0;
                        }
                        return;
                     }
                  }
               }
            }
         }
      }
      /*if(OrdersTotal() > 0)
      {
         if(bflag == 1)
         {
            if(OrderSelect(buyticket,SELECT_BY_TICKET,MODE_TRADES))
            {
               if(OrderLots() == 順勢手數)
               {
                  if(順勢追蹤止損 > 0)  
                  {
                     if(Bid-OrderOpenPrice() > 順勢追蹤止損*Point)
                     {
                        if((OrderStopLoss() < Bid-順勢追蹤止損*Point) || (OrderStopLoss() == 0))
                        {
                           if(!OrderModify(buyticket,OrderOpenPrice(),Bid-(順勢追蹤止損-順勢追蹤止損/5)*Point,OrderTakeProfit(),0,Green))
                           {
                              
                           }
                        }      
                     }
                  }
               }
               else if(OrderLots() == 逆勢手數)
               {
                  if(逆勢追蹤止損 > 0)  
                  {
                     if(Bid-OrderOpenPrice() > 逆勢追蹤止損*Point)
                     {
                        if((OrderStopLoss() < Bid-逆勢追蹤止損*Point) || (OrderStopLoss() == 0))
                        {
                           if(!OrderModify(buyticket,OrderOpenPrice(),Bid-(逆勢追蹤止損-逆勢追蹤止損/5)*Point,OrderTakeProfit(),0,Green))
                           {
                              
                           }
                        }      
                     }
                  }
               }
            }
          }
         if(sflag == 1) 
         {
            if(OrderSelect(sellticket,SELECT_BY_TICKET,MODE_TRADES))
            {
               if(OrderLots() == 順勢手數)
               {
                  if(順勢追蹤止損 > 0)  
                  {
                     if(OrderOpenPrice()-Ask > 順勢追蹤止損*Point)
                     {
                        if((OrderStopLoss() > (Ask+順勢追蹤止損*Point)) || (OrderStopLoss() == 0))
                        {
                           if(!OrderModify(sellticket,OrderOpenPrice(),Ask+(順勢追蹤止損-順勢追蹤止損/5)*Point,OrderTakeProfit(),0,Red))
                           {
                              
                           }
                        }
                     }
                  }
               }
               else if(OrderLots() == 逆勢手數)
               {
                  if(逆勢追蹤止損 > 0)  
                  {
                     if(OrderOpenPrice()-Ask > 逆勢追蹤止損*Point)
                     {
                        if((OrderStopLoss() > Ask+逆勢追蹤止損*Point) || (OrderStopLoss() == 0))
                        {
                           if(!OrderModify(sellticket,OrderOpenPrice(),Ask+(逆勢追蹤止損-逆勢追蹤止損/5)*Point,OrderTakeProfit(),0,Green))
                           {
                              
                           }
                        }      
                     }
                  }
               }
            }
         }
      }*/
  }
//+------------------------------------------------------------------+
