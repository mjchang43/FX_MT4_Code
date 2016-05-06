//+------------------------------------------------------------------+
//|                                                       trysky.mq4 |
//|                        Copyright 2015, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2015, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
//--- input parameters
//input double   profitpercent= 1;
input double   profit = 5;
input int      orders = 20;
input int      buyinterval = 100;
input double   buylots = 0.01;
input double   buylottimes = 2;
//input int      selltotalorders = 10;
input int      sellinterval = 100;
input double   selllots = 0.01;
input double   selllottimes = 2;
//--- parameters
double         ctrPrice;
int            ticket;
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
   int totalorders = OrdersTotal();
   if(totalorders == 0)
   {
      ctrPrice = Close[0];
      for(int i = 0;i < orders/2;i++)
      {
         ticket = OrderSend(NULL,OP_SELLLIMIT,buylots*MathPow(buylottimes,i),ctrPrice+(100+buyinterval*i)*Point,3,0,0,"Sky",0,0,clrGreen);
         if(ticket < 0)
         {
            clrOrders(OrdersTotal());
            return;
         }   
         ticket = OrderSend(NULL,OP_BUYLIMIT,selllots*MathPow(selllottimes,i),ctrPrice-(100+sellinterval*i)*Point,3,0,0,"Sky",0,0,clrRed);
         if(ticket < 0)
         {
            clrOrders(OrdersTotal());
            return;
         }
      }
   }
   if(AccountProfit() >= profit)
      clrOrders(totalorders);
  }
//+------------------------------------------------------------------+
void clrOrders(int totalorders)
{
   int to = totalorders;
   do
   {
      if(OrderSelect(0,SELECT_BY_POS,MODE_TRADES))
      {
         if(OrderType() == OP_BUY )
         {
            if(!OrderClose(OrderTicket(),OrderLots(),Bid,3))
            {
               Alert("OrderClose returned error of",GetLastError());
            }
            else
               to--;
         }
         else if(OrderType() == OP_SELL )
         {
            if(!OrderClose(OrderTicket(),OrderLots(),Ask,3))
            {
               Alert("OrderClose returned error of",GetLastError());
            }
            else
               to--;
         }
         else
         {
            if(!OrderDelete(OrderTicket()))
            {
               Alert("OrderDelete returned error of",GetLastError());
            }
            else
               to--;
         }
      }
   }while(to > 0);
}