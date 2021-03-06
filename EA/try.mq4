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
int            buyticket,sellticket,buyticket2nd,sellticket2nd,lowbar,highbar,totalbars;
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
      totalbars = Bars-1;
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
      double K33Previous,D33Previous,K33Current,D33Current,MFICurrent,MFIPrevious;
      double K58Current,D58Current,K58Previous,D58Previous,BBCurrent,BBPrevious,AOCurrent,AOPrevious,AO2;
      int count = 0;
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
      MFICurrent = iMFI(NULL,0,14,1);
      MFIPrevious = iMFI(NULL,0,14,2);
      AOCurrent = iAO(NULL,0,0);
      AOPrevious = iAO(NULL,0,1);
      AO2 = iAO(NULL,0,2);
      if(flag == 1)
      {
         if(lowbar != 0)
         {
            /*for(int i = 5;i > 0;i--)
            {
               if(iMFI(NULL,0,14,i) < 28)
               {
                  count++;
                  break;
               }
            }*/
            if(ChkKD("buy") && D58Previous-K58Previous < 5 && K58Previous < 30 && K33Previous < 70 /*&& count > 0 
               && MFICurrent > MFIPrevious+5 */&& AOPrevious > AO2 && buymark == 0)
            {
               buyticket = OrderSend(NULL,OP_BUY,0.01,Ask,1,Ask-30*Point,0,"martin ea",0,0,clrBlue);
               if(buyticket < 0)
                  Alert(Symbol()," ",buyticket," Orderbuy failed with error #",GetLastError());
               else
               {
                  buymark = 1;
                  buymark2nd = 0;
                  count = 0;
                  return;
               }
            }
            else if(K33Previous < D33Previous && !ChkPool(buyticket))
               buymark = 0;
         }
         else 
         {
            /*for(int i = 5;i > 0;i--)
            {
               if(iMFI(NULL,0,14,i) > 72)
               {
                  count++;
                  break;
               }
            }*/
            if(ChkKD("sell") && K58Previous-D58Previous < 5 && K58Previous > 70 && K33Previous > 30
               /*&& count > 0 && MFICurrent < MFIPrevious-5 */&& AOPrevious < AO2 && sellmark == 0)
            {
               sellticket = OrderSend(NULL,OP_SELL,0.01,Bid,1,Bid+30*Point,0,"martin ea",0,0,clrBlue);
               if(sellticket < 0)
                  Alert(Symbol()," ",sellticket," Ordersell failed with error #",GetLastError());
               else
               {
                  sellmark = 1;
                  sellmark2nd = 0;
                  count = 0;
                  return;
               }
            }
            else if(K33Previous > D33Previous && !ChkPool(sellticket))
               sellmark = 0;
         }
         if(ChkPool(buyticket))
        {
            if(OrderSelect(buyticket,SELECT_BY_TICKET,MODE_TRADES))
            {
               if(BBCurrent < BBPrevious-2*Point && Bid >= BBCurrent)
               {
                  if(!OrderClose(buyticket,OrderLots(),Bid,1,clrRed))
                     Alert(buyticket," OrderClose error ",GetLastError());
                  return;
               }
               /*else if(Bid >= OrderOpenPrice()+10*Point && OrderStopLoss() < Bid-10*Point)
               {
                  if(!OrderModify(buyticket,OrderOpenPrice(),Bid-5*Point,OrderTakeProfit(),0,clrGreenYellow))
                     Alert(buyticket," OrderModify error ",GetLastError());
               }   */
            }
        }
        else if(ChkPool(sellticket))
        {
            if(OrderSelect(sellticket,SELECT_BY_TICKET,MODE_TRADES))
            {
               if(K58Current < 35 && K33Current > D33Current)
               {
                  if(!OrderClose(sellticket,OrderLots(),Ask,1,clrRed))
                     Alert("OrderClose error ",GetLastError());
                  return;
               }
              /* else if(Ask <= OrderOpenPrice()-10*Point && OrderStopLoss() > Ask+10*Point)
               {
                  if(!OrderModify(sellticket,OrderOpenPrice(),Ask+5*Point,OrderTakeProfit(),0,clrGreenYellow))
                     Alert(sellticket," OrderModify error ",GetLastError());
               }*/
            }
        }
      }
      else if(flag == 2)
      {
         if(highbar != 0)
         {
            /*for(int i = 5;i > 0;i--)
            {
               if(iMFI(NULL,0,14,i) > 72)
               {
                  count++;
                  break;
               }
            }*/
            if(ChkKD("sell") && K58Previous-D58Previous < 5 && K58Previous > 70 && K33Previous > 30
               /*&& count > 0 && MFICurrent < MFIPrevious-5 */&& AOPrevious < AO2 && sellmark == 0)
            {
               sellticket = OrderSend(NULL,OP_SELL,0.01,Bid,1,Bid+30*Point,0,"martin ea",0,0,clrBlue);
               if(sellticket < 0)
                  Alert(Symbol()," ",sellticket," Ordersell failed with error #",GetLastError());
               else
               {
                  sellmark = 1;
                  sellmark2nd = 0;
                  count = 0;
                  return;
               }
            }
            else if(K33Previous > D33Previous && !ChkPool(sellticket))
               sellmark = 0;
         }
         else
         {
            /*for(int i = 5;i > 0;i--)
            {
               if(iMFI(NULL,0,14,i) < 28)
               {
                  count++;
                  break;
               }
            }*/
            if(ChkKD("buy") && D58Previous-K58Previous < 5 && K58Previous < 30 && K33Previous < 70 /*&& count > 0 
               && MFICurrent > MFIPrevious+5 */&& AOPrevious > AO2 && buymark == 0)
            {
               buyticket = OrderSend(NULL,OP_BUY,0.01,Ask,1,Ask-30*Point,0,"martin ea",0,0,clrBlue);
               if(buyticket < 0)
                  Alert(Symbol()," ",buyticket," Orderbuy failed with error #",GetLastError());
               else
               {
                  buymark = 1;
                  buymark2nd = 0;
                  count = 0;
                  return;
               }
            }
            else if(K33Previous < D33Previous && !ChkPool(buyticket))
               buymark = 0;
         }
         if(ChkPool(buyticket))
        {
            if(OrderSelect(buyticket,SELECT_BY_TICKET,MODE_TRADES))
            {
               if(K58Current > 65 && K33Current < D33Current)
               {
                  if(!OrderClose(buyticket,OrderLots(),Bid,1,clrRed))
                     Alert("OrderClose error ",GetLastError());
                  return;
               } 
              /* else if(Bid >= OrderOpenPrice()+10*Point && OrderStopLoss() < Bid-10*Point)
               {
                  if(!OrderModify(buyticket,OrderOpenPrice(),Bid-5*Point,OrderTakeProfit(),0,clrGreenYellow))
                     Alert(buyticket," OrderModify error ",GetLastError());
               } */  
            }
        }
        else if(ChkPool(sellticket))
        {
            if(OrderSelect(sellticket,SELECT_BY_TICKET,MODE_TRADES))
            {
               if(BBCurrent > BBPrevious+2*Point && Bid <= BBCurrent)
               {
                  if(!OrderClose(sellticket,OrderLots(),Ask,1,clrRed))
                        Alert("OrderClose error ",GetLastError());
                  return;
               }
             /*  else if(Ask <= OrderOpenPrice()-10*Point && OrderStopLoss() > Ask+10*Point)
               {
                  if(!OrderModify(sellticket,OrderOpenPrice(),Ask+5*Point,OrderTakeProfit(),0,clrGreenYellow))
                     Alert(sellticket," OrderModify error ",GetLastError());
               }*/
            }
        }
      }
     /*if(ChkPool(buyticket))
     {
         if(OrderSelect(buyticket,SELECT_BY_TICKET,MODE_TRADES))
         {
            if(highbar == 1)
            {
               if(!OrderClose(buyticket,OrderLots(),Bid,1,clrRed))
                     Alert("OrderClose error ",GetLastError());
               return;
            }            
         }
     }
     else if(ChkPool(sellticket))
     {
         if(OrderSelect(sellticket,SELECT_BY_TICKET,MODE_TRADES))
         {
            if(lowbar == 1)
            {
               if(!OrderClose(sellticket,OrderLots(),Ask,1,clrRed))
                     Alert("OrderClose error ",GetLastError());
               return;
            }
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
         sellmark2nd = 0;*/
      //   ExpertRemove();
      
  }
//+------------------------------------------------------------------+
bool ChkPool(int ticket)
{
   int totalorders = OrdersTotal();
   for(int i = totalorders-1;i >= 0;i--)
   {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
      {
         if(OrderTicket() == ticket)
            return true;
      }
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