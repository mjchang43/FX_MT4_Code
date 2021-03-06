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
input int      firstinterval = 20;
input int      buytotalorders = 10;
input int      buyinterval = 30;
input double   buylots = 0.01;
input double   buylottimes = 1.5;
input int      selltotalorders = 10;
input int      sellinterval = 30;
input double   selllots = 0.01;
input double   selllottimes = 1.5;
input int      accountprofit = 2;
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
      for(int i = 0;i < buytotalorders;i++)
      {
         ticket = OrderSend(NULL,OP_SELLLIMIT,buylots*MathPow(buylottimes,i),ctrPrice+(firstinterval+buyinterval*i)*10*Point,3,0,0,"Sky",0,0,clrGreen);
         if(ticket < 0)
            Alert(Symbol(),"buyStop failed");
      }
      for(int i = 0;i < selltotalorders;i++)
      {
         ticket = OrderSend(NULL,OP_BUYLIMIT,selllots*MathPow(selllottimes,i),ctrPrice-(firstinterval+sellinterval*i)*10*Point,3,0,0,"Sky",0,0,clrRed);
         if(ticket < 0)
            Alert(Symbol(),"sellStop failed");
      }
   }
   //if((AccountProfit() >= (MathMod(AccountBalance(),1500)+300)*profitpercent/100)/* || chkOdrType(totalorders,0) >= buytotalorders || chkOdrType(totalorders,1) >= selltotalorders*/)
   if(AccountProfit() >= accountprofit)//AccountBalance()*profitpercent/100)
      clrOrders(totalorders);
   /*else
   {
      for(int i = 1;i <= buytotalorders;i++)
      {
         if(Ask <= ctrPrice-buyinterval*(i+1)*Point && !chkOdrPrice(totalorders,0,4,ctrPrice-buyinterval*i*Point))
         {
            ticket = OrderSend(NULL,OP_BUYSTOP,buylots*MathPow(buylottimes,(i-1)),ctrPrice-buyinterval*i*Point,3,0,0,"Sky",0,0,clrGreen);
            if(ticket < 0)
               Alert(Symbol(),"buyStop failed");
         }
      }
      for(int i = 1;i <= selltotalorders;i++)
      {
         if(Bid >= ctrPrice+sellinterval*(i+1)*Point && !chkOdrPrice(totalorders,1,5,ctrPrice+sellinterval*i*Point))
         {
            ticket = OrderSend(NULL,OP_SELLSTOP,selllots*MathPow(selllottimes,(i-1)),ctrPrice+sellinterval*i*Point,3,0,0,"Sky",0,0,clrRed);
            if(ticket < 0)
               Alert(Symbol(),"sellStop failed");
         }
      }
   }*/
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
   /*for(int i = totalorders-1;i >= 0;i--)
      {
         if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
         {
            if(OrderType() == OP_BUY )
            {
               if(!OrderClose(OrderTicket(),OrderLots(),Bid,3))
               {
                  Alert("OrderClose returned error of",GetLastError());
               }
            }
            else if(OrderType() == OP_SELL )
            {
               if(!OrderClose(OrderTicket(),OrderLots(),Ask,3))
               {
                  Alert("OrderClose returned error of",GetLastError());
               }
            }
            else
            {
               if(!OrderDelete(OrderTicket()))
               {
                  Alert("OrderDelete returned error of",GetLastError());
               }
            }
         }      
      }*/  
}
//+------------------------------------------------------------------+
int chkOdrType(int totalorders,int ordertype)
{
   int count = 0;
   for(int i = totalorders-1;i >= 0;i--)
   {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
      {
         if(OrderType() == ordertype)
            count++;
      }
   }
   return count;
}
//+------------------------------------------------------------------+
bool chkOdrPrice(int totalorders,int ordertype1,int ordertype2,double odrPrice)
{
   for(int i = totalorders-1;i >= 0;i--)
   {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
      {
         if(OrderType() == ordertype1 || OrderType() == ordertype2)
         {
            if(OrderOpenPrice() <= odrPrice+4*Point && OrderOpenPrice() >= odrPrice-4*Point)
               return true;
         }
      }
   }
   return false;
}