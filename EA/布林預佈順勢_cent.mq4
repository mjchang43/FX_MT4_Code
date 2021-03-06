//+------------------------------------------------------------------+
//|                                                       布林預佈順勢.mq4 |
//|                        Copyright 2015, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2015, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
//--- input parameters
input double   單張手數 = 1;
input int      滑價 = 3;
input int      重啟時間 = 14400;
//--- parameters
int        trendType;
int        bandType;
int        ticket;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
      if(OrdersTotal() != 0)
      {
         if(OrderSelect(0,SELECT_BY_POS,MODE_TRADES))
         {
            if(OrderType() == 0)
            {
               trendType = 1;
               bandType = 0;
            }else if(OrderType() == 1)
            {
               trendType = 0;
               bandType = 1;
            }
            
            int barCount = iBarShift(NULL,PERIOD_H4,OrderOpenTime());
            for(int i = 0; i < barCount ; i++)
            {
               if(High[i] > iBands(NULL,240,20,2,0,PRICE_CLOSE,MODE_UPPER,i))
               {
                  bandType = 1;
                  break;
               }else if(Low[i] < iBands(NULL,240,20,2,0,PRICE_CLOSE,MODE_LOWER,i))
               {
                  bandType = 0;
                  break;
               }
            }
         }
      }else
      {
         int barCount = iBars(NULL,PERIOD_H4);
         for(int i = 0; i < barCount ; i++)
         {
            if(High[i] > iBands(NULL,240,20,2,0,PRICE_CLOSE,MODE_UPPER,i)
               && Low[i] < iBands(NULL,240,20,2,0,PRICE_CLOSE,MODE_LOWER,i))
            {
               trendType = -1;
               break;
            }
            else if(High[i] > iBands(NULL,240,20,2,0,PRICE_CLOSE,MODE_UPPER,i))
            {
               trendType = 0;
               bandType = 1;
               break;
            }else if(Low[i] < iBands(NULL,240,20,2,0,PRICE_CLOSE,MODE_LOWER,i))
            {
               trendType = 1;
               bandType = 0;
               break;
            }
         }
      }
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
      if(bandType == 0 && High[0] > iBands(NULL,240,20,2,0,PRICE_CLOSE,MODE_UPPER,0))  //突破布林高點
      {
         bandType = 1;
      }else if(bandType == 1 && Low[0] < iBands(NULL,240,20,2,0,PRICE_CLOSE,MODE_LOWER,0))   //突破布林低點
      {
         bandType = 0;
      }
      
      if(Hour() % 4 == 3 && Minute() >= 59)
      {
         if(trendType == 1)   //布林下方佈局-buy
         {
            if(Low[0] > Low[1] && Close[0] > Open[0]
               && Low[0] > iBands(NULL,240,20,2,0,PRICE_CLOSE,MODE_LOWER,0)
               && High[0] < iBands(NULL,240,20,2,0,PRICE_CLOSE,MODE_MAIN,0))
            {
               ticket = OrderSend(NULL,OP_BUY,單張手數,Ask,滑價*10,0,0,"BandBuy",0,0);
               if(ticket < 0)
               {
                  Alert(Symbol(),"BandBuy failed");
               }
            }
            
            int orderCount = OrdersTotal();
            if(orderCount > 0 && bandType == 1 && High[0] < High[1] && Close[0] < Open[0]
               && High[0] < iBands(NULL,240,20,2,0,PRICE_CLOSE,MODE_UPPER,0))
            {
               clrOrders(orderCount);
            }         
         }else if(trendType == 0)   //布林上方佈局-sell
         {
            if(High[0] < High[1] && Close[0] < Open[0]
               && High[0] < iBands(NULL,240,20,2,0,PRICE_CLOSE,MODE_UPPER,0)
               && Low[0] > iBands(NULL,240,20,2,0,PRICE_CLOSE,MODE_MAIN,0))
            {
               ticket = OrderSend(NULL,OP_SELL,單張手數,Bid,滑價*10,0,0,"BandSell",0,0);
               if(ticket < 0)
               {
                  Alert(Symbol(),"BandSell failed");
               }
            }
            
            int orderCount = OrdersTotal();
            if(orderCount > 0 && bandType == 0 && Low[0] > Low[1] && Close[0] > Open[0]
               && Low[0] > iBands(NULL,240,20,2,0,PRICE_CLOSE,MODE_LOWER,0))
            {
               clrOrders(orderCount);
            }
         }else//不合理狀況
         {
            OnInit();
         }
      }
  }
//+------------------------------------------------------------------+
void onTimer(int sec)
{
   datetime now = TimeLocal();
   datetime after = TimeLocal() + sec;
   do
   {
      now = TimeLocal();
   }while(now < after);
}
//+------------------------------------------------------------------+
void clrOrders(int to)
{
   do
   {
      if(OrderSelect(0,SELECT_BY_POS,MODE_TRADES))
      {
         if(OrderType() == OP_BUY )
         {
            if(!OrderClose(OrderTicket(),OrderLots(),Bid,滑價*10))
            {
               Alert("OrderClose returned error of",GetLastError());
            }
            else
            {
               to--;
            }
         }
         else if(OrderType() == OP_SELL )
         {
            if(!OrderClose(OrderTicket(),OrderLots(),Ask,滑價*10))
            {
               Alert("OrderClose returned error of",GetLastError());
            }
            else
            {
               to--;
            }
         }
         else
         {
            if(!OrderDelete(OrderTicket()))
            {
               Alert("OrderDelete returned error of",GetLastError());
            }
            else
            {
               to--;
            }
         }
      }
   }while(to > 0);
   
   if(OrdersTotal() > 0)
   {
      clrOrders(OrdersTotal());
   }
   
   OnInit();
}