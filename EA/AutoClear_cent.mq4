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
input double   profit= 2;
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
   if((totalorders > 0) && (AccountProfit() >= 20*chkMinlots(totalorders)/0.1))
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
         if(StringFind(OrderSymbol(),"JPY",0) < 0)
         {
            if(OrderType() == OP_BUY)
            {
               if(!OrderClose(OrderTicket(),OrderLots(),Bid,3))
                  Alert("OrderClose returned error of",GetLastError());
               else
                  to--;
            }
            else if(OrderType() == OP_SELL )
            {
               if(!OrderClose(OrderTicket(),OrderLots(),Ask,3))
                  Alert("OrderClose returned error of",GetLastError());
               else
                  to--;
            }
            else
            {
               if(!OrderDelete(OrderTicket()))
                  Alert("OrderDelete returned error of",GetLastError());
               else
                  to--;
            }
         }
      }
   }while(to > 0);
}
//+------------------------------------------------------------------+
double chkMinlots(int totalorders)
{
   int to = totalorders;
   double minlots = 1000;
   for(int i = to-1;i >= 0; i--)
   {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
      {
         if((OrderType() == OP_BUY) || OrderType() == OP_SELL)
         {
            if(OrderLots() < minlots)
               minlots = OrderLots();
         }
      }
   }
   return minlots;
}