//+------------------------------------------------------------------+
//|                                                     Martin下單.mq4 |
//|                        Copyright 2015, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2015, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
//--- input parameters
//input bool     buy=false;
//--- parameters
int            buyticket,sellticket,buyticket2nd,sellticket2nd,lowbar,highbar;
int            flag = 0;
int            buymark = 0;
int            sellmark = 0;
int            buymark2nd = 0;
int            sellmark2nd = 0;
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
      //Alert(Symbol()," 場上沒單,即將離開戰場!");
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
      int totalbars = Bars-1;
      for(int i = totalbars;i >= 0;i--)
      {
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
               continue;
            
            case 2:
               if(High[i] > High[highbar])
                  highbar = i;
               
               if(Low[i] < iBands(NULL,0,20,2,0,PRICE_CLOSE,MODE_LOWER,i) && Low[i] < iEnvelopes(NULL,0,14,MODE_SMA,0,PRICE_CLOSE,0.1,MODE_LOWER,i))
               {
                  lowbar = i;
                  flag = 1;
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
      double K33Previous,D33Previous,K33Current,D33Current,K58Current,D58Current,MFICurrent,MFIPrevious;
      int count = 0;
      K33Previous = iStochastic(NULL,0,5,3,3,MODE_SMA,0,MODE_MAIN,1);
      D33Previous = iStochastic(NULL,0,5,3,3,MODE_SMA,0,MODE_SIGNAL,1);
      K33Current = iStochastic(NULL,0,5,3,3,MODE_SMA,0,MODE_MAIN,0);
      D33Current = iStochastic(NULL,0,5,3,3,MODE_SMA,0,MODE_SIGNAL,0);
      K58Current = iStochastic(NULL,0,13,5,8,MODE_SMA,0,MODE_MAIN,0);
      D58Current = iStochastic(NULL,0,13,5,8,MODE_SMA,0,MODE_SIGNAL,0);
      MFICurrent = iMFI(NULL,0,14,0);
      MFIPrevious = iMFI(NULL,0,14,1);
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
            if(K33Previous-D33Previous < K33Current-D33Current && K33Current > D33Current
               && D58Current-K58Current < 5 && K58Current < 25 && K33Current < 70 && count > 0 
               && MFICurrent > MFIPrevious+5 && Bid >= Open[0] && buymark == 0)
            {
               buyticket = OrderSend(NULL,OP_BUY,0.01,Ask,1,Ask-40*Point,Bid+10*Point,"martin ea",0,0,clrBlue);
               if(buyticket < 0)
                  Alert(Symbol()," ",buyticket," Orderbuy failed with error #",GetLastError());
               else
               {
                  buymark = 1;
                  count = 0;
                  return;
               }
            }
            else if(K33Current < D33Current && !OrderSelect(buyticket,SELECT_BY_TICKET))
               buymark = 0;
         }
         else 
         {
            for(int i = 5;i >= 0;i--)
            {
               if(iMFI(NULL,0,14,i) > 77)
               {
                  count++;
                  break;
               }
            }
            if(D33Previous-K33Previous < D33Current-K33Current && K33Current < D33Current 
               && K58Current-D58Current < 5 && K58Current > 75 && K33Current > 30
               && count > 0 && MFICurrent < MFIPrevious-5 && Ask <= Open[0] && sellmark == 0)
            {
               sellticket = OrderSend(NULL,OP_SELL,0.01,Bid,1,Bid+40*Point,Ask-10*Point,"martin ea",0,0,clrBlue);
               if(sellticket < 0)
                  Alert(Symbol()," ",sellticket," Ordersell failed with error #",GetLastError());
               else
               {
                  sellmark = 1;
                  count = 0;
                  return;
               }
            }
            else if(K33Current > D33Current && !OrderSelect(sellticket,SELECT_BY_TICKET))
               sellmark = 0;
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
            if(D33Previous-K33Previous < D33Current-K33Current && K33Current < D33Current 
               && K58Current-D58Current < 5 && K58Current > 75 && K33Current > 30
               && count > 0 && MFICurrent < MFIPrevious-5 && Ask <= Open[0] && sellmark == 0)
            {
               sellticket = OrderSend(NULL,OP_SELL,0.01,Bid,1,Bid+40*Point,Ask-10*Point,"martin ea",0,0,clrBlue);
               if(sellticket < 0)
                  Alert(Symbol()," ",sellticket," Ordersell failed with error #",GetLastError());
               else
               {
                  sellmark = 1;
                  count = 0;
                  return;
               }
            }
            else if(K33Current > D33Current && !OrderSelect(sellticket,SELECT_BY_TICKET))
               sellmark = 0;
         }
         else
         {
            for(int i = 5;i >= 0;i--)
            {
               if(iMFI(NULL,0,14,i) < 23)
               {
                  count++;
                  break;
               }
            }
            if(K33Previous-D33Previous < K33Current-D33Current && K33Current > D33Current
               && D58Current-K58Current < 5 && K58Current < 25 && K33Current < 70 && count > 0 
               && MFICurrent > MFIPrevious+5 && Bid >= Open[0] && buymark == 0)
            {
               buyticket = OrderSend(NULL,OP_BUY,0.01,Ask,1,Ask-40*Point,Bid+10*Point,"martin ea",0,0,clrBlue);
               if(buyticket < 0)
                  Alert(Symbol()," ",buyticket," Orderbuy failed with error #",GetLastError());
               else
               {
                  buymark = 1;
                  count = 0;
                  return;
               }
            }
            else if(K33Current < D33Current && !OrderSelect(buyticket,SELECT_BY_TICKET))
               buymark = 0;
         }
      }
      if(OrderSelect(buyticket,SELECT_BY_TICKET))
      {
        if(Ask <= OrderOpenPrice()-20*Point && buymark2nd == 0)
        {
            buyticket2nd = OrderSend(NULL,OP_BUY,0.01,Ask,1,OrderStopLoss(),OrderOpenPrice()-5*Point,"martin ea2",0,0,clrBlue);
            if(buyticket2nd < 0)
               Alert(Symbol()," ",buyticket2nd," Orderbuy failed with error #",GetLastError());
            else
            {
               buymark2nd = 1;
               if(!OrderModify(buyticket,OrderOpenPrice(),OrderStopLoss(),OrderOpenPrice()-5*Point,0,clrTeal))
                  Alert("OrderModify error ",GetLastError());
               return;
            }
         }
      }
      else
         buymark2nd = 0;
      if(OrderSelect(sellticket,SELECT_BY_TICKET))
      {
         if(Bid >= OrderOpenPrice()+20*Point && sellmark2nd == 0)
         {
            sellticket2nd = OrderSend(NULL,OP_SELL,0.01,Bid,1,OrderStopLoss(),OrderOpenPrice()+5*Point,"martin ea2",0,0,clrBlue);
            if(sellticket2nd < 0)
               Alert(Symbol()," ",sellticket2nd," Orderbuy failed with error #",GetLastError());
            else
            {
               sellmark2nd = 1;
               if(!OrderModify(sellticket,OrderOpenPrice(),OrderStopLoss(),OrderOpenPrice()+5*Point,0,clrTeal))
                  Alert("OrderModify error ",GetLastError());
               return;
            }
         }
      }
      else
         sellmark2nd = 0;
      //   ExpertRemove();
      
  }
//+------------------------------------------------------------------+
