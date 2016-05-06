//+------------------------------------------------------------------+
//|                                                    HasOrders.mq4 |
//|                        Copyright 2015, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2015, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
//---
   int totalorders = OrdersTotal();
   
   if(totalorders > 0 && AccountProfit() >= 0)
   {
      clrOrders(totalorders);
   }
   
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
            if(!OrderClose(OrderTicket(),OrderLots(),Bid,30))
            {
               Alert("OrderClose returned error of",GetLastError());
            }
            else if(to == 1)
            {
               to--;
               break;
            }
            else
               to--;
         }
         else if(OrderType() == OP_SELL )
         {
            if(!OrderClose(OrderTicket(),OrderLots(),Ask,30))
            {
               Alert("OrderClose returned error of",GetLastError());
            }
            else if(to == 1)
            {
               to--;
               break;
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
            else if(to == 1)
            {
               to--;
               break;
            }
            else
               to--;
         }
      }
   }while(to > 0);
   
   if(OrdersTotal() > 0)
   {
      clrOrders(OrdersTotal());
   }
   
}