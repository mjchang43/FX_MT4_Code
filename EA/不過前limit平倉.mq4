//+------------------------------------------------------------------+
//|                                                   不過前limit平倉.mq4 |
//|                        Copyright 2014, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2014, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"
#property strict
//--- input parameters
input int      幾根bar不過=3;
input double   單根急拉跌點數平倉=15;
input int      單號;
//--- parameters
int ssflag = 0;

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
        /* if(OrderSelect(單號,SELECT_BY_TICKET,MODE_TRADES)==true)
         {
            if(OrderType()== OP_BUY )
            {
               if(iClose(NULL,0,0) <= iHigh(NULL,0,iHighest(NULL,0,MODE_HIGH,3,0))-(單根急拉跌點數平倉/10000))
               {
                  if(!OrderClose(OrderTicket(),OrderLots(),Bid,3,Blue))
                  {
                     Print("OrderClose returned error of",GetLastError());
                  }
               }
               if(iHighest(NULL,0,MODE_HIGH,(幾根bar不過+2),0) >= (幾根bar不過+1))
               {
 
                  if(!OrderClose(OrderTicket(),OrderLots(),Bid,3,Blue))
                  {
                     Print("OrderClose returned error of",GetLastError());
                  }
               }
            }
            else if(OrderType()== OP_SELL )
            {
                 if(iClose(NULL,0,0) >= iLow(NULL,0,iLowest(NULL,0,MODE_LOW,3,0))+(單根急拉跌點數平倉/10000))
               {
                  if(!OrderClose(OrderTicket(),OrderLots(),Ask,3,Blue))
                  {
                     Print("OrderClose returned error of",GetLastError());
                  }
               }
                if(iLowest(NULL,0,MODE_LOW,(幾根bar不過+2),0) >= (幾根bar不過+1))
               {
                  if(!OrderClose(OrderTicket(),OrderLots(),Ask,3,Blue))
                  {
                     Print("OrderClose returned error of",GetLastError());
                  }
               }
            }
            else if ((OrderType()== OP_BUYLIMIT) || (OrderType()== OP_SELLLIMIT) || (OrderType()== OP_BUYSTOP) || (OrderType()== OP_SELLSTOP))
            {
               if(!OrderDelete(OrderTicket()))
               {
                  Print("OrderDelete returned error of",GetLastError());
               }
            }
         }   
      totalorders = OrdersTotal();
      for(int i = 0;i < totalorders;i++)
      {
         if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
         {
            if(OrderType() <= OP_SELL && OrderSymbol() == Symbol()) 
            {
               if(OrderType() == OP_BUY)
               {
                  if(trailingstop > 0)  
                  {                 
                     // 如果現在的價差(Bid-OrderOpenPrice()) 
                       // 已經超過追蹤止損(Point*TrailingStop) 點數的話(買單有賺錢, 但還沒到 TP)
                     if(Bid-OrderOpenPrice() > trailingstop*10*Point)
                     {
                        // 如果預設的止損價( OrderStopLoss ) 低於(Bid-Point*TrailingStop) 
                         //  或者 止損價沒有設定( OrderStopLoss==0 )
                        if((OrderStopLoss() < Bid-trailingstop*10*Point) || (OrderStopLoss()==0))
                        {
                           //修改定單的止損價為 Bid-Point*TrailingStop (向上移動)
                           OrderModify(OrderTicket(),OrderOpenPrice(),Bid-trailingstop*10*Point,OrderTakeProfit(),0,Green);
                           return(0);
                        }
                     }
                  }
               }
               else // go to short position 處理賣單
               {
                  // check for trailing stop
                  //-- 還沒出現 平倉訊號前, 有設定 追蹤止損 的話
                  if(trailingstop > 0)  
                  {                 
                     // 如果現在的價差(OrderOpenPrice()-Ask) 已經超過追蹤止損(Point*TrailingStop) 點數的話
                      //  (賣單有賺錢, 但還沒到 TP)
                     if(OrderOpenPrice()-Ask > trailingstop*10*Point)
                     {
                        // 如果預設的止損價( OrderStopLoss ) 高於(Ask+Point*TrailingStop) 
                         //  或者 止損價沒有設定( OrderStopLoss==0 )
                        if((OrderStopLoss() > (Ask+trailingstop*10*Point)) || (OrderStopLoss() == 0))
                        {
                            //修改定單的止損價為 Ask+Point*TrailingStop (向下移動)
                            OrderModify(OrderTicket(),OrderOpenPrice(),Ask+trailingstop*10*Point,OrderTakeProfit(),0,Red);
                            return(0);
                        }
                     }
                  }
               }
            }
         }
      }*/
         if(!OrderSelect(2799660,SELECT_BY_TICKET,MODE_TRADES))
         {
            if(OrderDelete(2800765))
               {
                  Alert(Symbol(),"2800765 Orderstop delete successfully");
                  
               }
               else
                  Alert(Symbol(),"2800765 Orderstop delete failed with error #",GetLastError());
         }
         
         if(OrderSelect(2800765,SELECT_BY_TICKET,MODE_TRADES))
         {
            if(OrderType()== OP_SELL && ssflag < 1)
            {
               int ticket = OrderSend(NULL,OP_BUYSTOP,0.04,147.486,4,147.186,147.736);
               if(ticket < 0)
               {
                  Alert(Symbol(),"Orderstop failed with error #",GetLastError());
               }
               else
               {
                  Alert(Symbol(),"Orderstop placed successfully");
               }
               ssflag = 1;
            }
         }
  }
//+------------------------------------------------------------------+
