//+------------------------------------------------------------------+
//|                                             buy_double_limit.mq4 |
//|                        Copyright 2014, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2014, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
//--- parameters
double         basepoint;
int            ticket;
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
//---
      for(int i = 0;i <= 5;i++)
      {
         if(i == 5)
         {
            ticket = OrderSend(NULL,OP_BUYSTOP,0.01*MathPow(2,i),Ask+40*i*10*Point,3,0,0,"double",0,0,clrGreen);
            if(ticket < 0)
               Alert(Symbol(),"SellStop failed");
         }
         else if(i == 0)
         {
            ticket = OrderSend(NULL,OP_SELL,0.01*MathPow(2,i),Ask+40*i*10*Point,3,0,0,"double",0,0,clrGreen);
            if(ticket < 0)
               Alert(Symbol(),"Buy failed");
         }
         else
         {
            ticket = OrderSend(NULL,OP_SELLLIMIT,0.01*MathPow(2,i),Ask+40*i*10*Point,3,0,0,"double",0,0,clrGreen);
            if(ticket < 0)
               Alert(Symbol(),"BuyLimit failed");
         }         
      }
  }
//+------------------------------------------------------------------+
