//+------------------------------------------------------------------+
//|                                                          全平倉.mq4 |
//|                        Copyright 2014, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2014, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"
#property strict
#property script_show_confirm
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
//---
      int to = OrdersTotal();
      do
      {
         if(OrderSelect(0,SELECT_BY_POS,MODE_TRADES))
         {
            if(OrderType() == OP_BUY )
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
      }while(to > 0);
  }
//+------------------------------------------------------------------+
