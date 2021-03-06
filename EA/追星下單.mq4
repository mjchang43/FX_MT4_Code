//+------------------------------------------------------------------+
//|                                                         追星下單.mq4 |
//|                        Copyright 2014, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2014, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"
#property strict
//--- input parameters
input double   orderlots = 0.01;
input int      orderdistance = 20;
input int      stoploss = 20 ;
input int      takeprofit = 200 ;
input int      trailingstop=10;
//--- parameters
int flag = 0;
int ticket;
double bcp,cp;
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
      if(flag < 1)
      {
         bcp = iClose(NULL,0,0);
         flag = 1;
      }
      else if (flag == 1)
      {
         cp = iClose(NULL,0,0);
         if(Ask-Bid < 8)
         {
            if(cp > bcp+orderdistance*10*Point)
            {
               ticket = OrderSend(NULL,OP_BUY,orderlots,Ask,3,Ask-stoploss*10*Point,Ask+takeprofit*10*Point);
               if(ticket < 0)
               {
                  Alert(Symbol(),"Orderbuy failed with error #",GetLastError());
               }
               else
               {
                  Alert(Symbol(),"Orderbuy placed successfully");
                  flag = 2;
               }
            }
            else if(cp < bcp-orderdistance*10*Point)
            {
               ticket = OrderSend(NULL,OP_SELL,orderlots,Bid,3,Bid+stoploss*10*Point,Bid-takeprofit*10*Point);
               if(ticket < 0)
               {
                  Alert(Symbol(),"Ordersell failed with error #",GetLastError());
               }
               else
               {
                  Alert(Symbol(),"Ordersell placed successfully");
                  flag = 2;
               }
            }
         }
      }
      if(OrdersTotal() > 0)
      {
         if(OrderSelect(ticket,SELECT_BY_TICKET,MODE_TRADES))
         {
            if(OrderType() == OP_BUY)
            {
               if(trailingstop > 0)  
               {                 
                  /* 如果現在的價差(Bid-OrderOpenPrice()) 
                           已經超過追蹤止損(Point*TrailingStop) 點數的話(買單有賺錢, 但還沒到 TP)*/
                  if(Bid-OrderOpenPrice() > trailingstop*10*Point)
                  {
                     /* 如果預設的止損價( OrderStopLoss ) 低於(Bid-Point*TrailingStop) 
                              或者 止損價沒有設定( OrderStopLoss==0 )*/
                     if((OrderStopLoss() < Bid-trailingstop*10*Point) || (OrderStopLoss()==0))
                     {
                        //修改定單的止損價為 Bid-Point*TrailingStop (向上移動)
                        if(!OrderModify(ticket,OrderOpenPrice(),Bid-(trailingstop-3)*10*Point,OrderTakeProfit(),0,Green))
                        {
                           
                        }
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
                  /* 如果現在的價差(OrderOpenPrice()-Ask) 已經超過追蹤止損(Point*TrailingStop) 點數的話
                           (賣單有賺錢, 但還沒到 TP)*/
                  if(OrderOpenPrice()-Ask > trailingstop*10*Point)
                  {
                     /* 如果預設的止損價( OrderStopLoss ) 高於(Ask+Point*TrailingStop) 
                              或者 止損價沒有設定( OrderStopLoss==0 )*/
                     if((OrderStopLoss() > (Ask+trailingstop*10*Point)) || (OrderStopLoss() == 0))
                     {
                        //修改定單的止損價為 Ask+Point*TrailingStop (向下移動)
                        if(!OrderModify(ticket,OrderOpenPrice(),Ask+(trailingstop-3)*10*Point,OrderTakeProfit(),0,Red))
                        {
                           
                        }
                     }
                  }
               }
            }
         }
      }
  }
//+------------------------------------------------------------------+
