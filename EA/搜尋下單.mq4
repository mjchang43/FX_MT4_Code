//+------------------------------------------------------------------+
//|                                                         搜尋下單.mq4 |
//|                        Copyright 2014, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2014, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"
#property strict
//--- input parameters
input int      買賣單號 = 0;
input int      預掛單號 = 0;
input int      下手次數 = 1;
input int      最大下手次數 = 4;
input bool     順勢 = false;
//--- parameters
int            ticket;
int            mark = 0;
int            selmark = 0;
int            i = 0;
double         price = 0;
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
         i = 下手次數;
         if(!OrderSelect(買賣單號,SELECT_BY_TICKET,MODE_TRADES))
         {
            if(OrderDelete(預掛單號))
               {
                  Alert(Symbol(),預掛單號," Orderstop delete successfully");
                  
               }
               else
                  Alert(Symbol(),預掛單號," Orderstop delete failed with error #",GetLastError());
         }
         else
         {
            price = OrderStopLoss();
         }
         
         if(OrderSelect(預掛單號,SELECT_BY_TICKET,MODE_TRADES))
         {
            if(OrderType()== OP_SELL && mark < 1)
            {
               ticket = OrderSend(NULL,OP_BUYSTOP,0.01*pow(2,i),price,4,price-300*Point,0.77614);
               if(ticket < 0)
               {
                  Alert(Symbol(),"Orderstop failed with error #",GetLastError());
               }
               else
               {
                  Alert(Symbol(),"Orderstop placed successfully");
               }
               mark = 1;
            }
            else if(OrderType()== OP_BUY && mark < 1)
            {
               ticket = OrderSend(NULL,OP_SELLSTOP,0.16,0.76914,4,0.76614,0.77614);
               if(ticket < 0)
               {
                  Alert(Symbol(),"Orderstop failed with error #",GetLastError());
               }
               else
               {
                  Alert(Symbol(),"Orderstop placed successfully");
               }
               mark = 1;
            }
         }
  }
//+------------------------------------------------------------------+
