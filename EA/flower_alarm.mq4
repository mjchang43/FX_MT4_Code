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
//--- parameters
int            ticket,flag,mark,highbar,lowbar;
double         highestvalue,lowestvalue;
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

   
   if(mark == 1)
   {
      if(Low[1] < lowestvalue)
      {
         lowestvalue = Low[1];
         flag = 0;
      }
      if((Low[1] > lowestvalue) && (Close[1] > Open[1]) && (flag == 0))
      {
         Alert(Symbol()," buy");
         flag = 1;
         return;
      }
      if(High[1] > iBands(NULL,0,20,2,0,PRICE_CLOSE,MODE_UPPER,1))
      {
         highestvalue = High[1];
         mark = 2;
         return;
      }
   }
   else if(mark == 2)
   {
      if(High[1] > highestvalue)
      {
         highestvalue = High[1];
         flag = 1;
      }
      if((High[1] < highestvalue ) && (Close[1] < Open[1]) && (flag == 1))
      {
         Alert(Symbol()," sell");
         flag = 0;
         return;
      }
      if(Low[1] < iBands(NULL,0,20,2,0,PRICE_CLOSE,MODE_LOWER,1))
      {
         lowestvalue = Low[1];
         mark = 1;
         return;
      }
   }
   else
   {
      highbar = iHighest(NULL,0,MODE_HIGH,4,1);
      lowbar = iLowest(NULL,0,MODE_LOW,4,1);
      if(Low[lowbar] < iBands(NULL,0,20,2,0,PRICE_CLOSE,MODE_LOWER,lowbar))
      {
         lowestvalue = Low[lowbar];
         mark = 1;
         return;
      }
      if(High[highbar] > iBands(NULL,0,20,2,0,PRICE_CLOSE,MODE_UPPER,highbar))
      {
         highestvalue = High[highbar];
         mark = 2;
         return;
      }
   }
   /*if(totalorders >= 0)
   {
      if((highestvalue > 0) && (highbar != 1) && (flag == 0))
      {
         highestvalue = High[highbar];
            if(/*(High[1] < highestvalue)(highbar != 1) && (Close[1] < Open[1]))
            {
               Alert(Symbol()," sell");
               flag = 1;
               return;
            }         
      }
      if((Low[lowbar] < iBands(NULL,0,20,2,0,PRICE_CLOSE,MODE_LOWER,lowbar)) && (flag == 1))
      {
         if(/*(Low[1] > lowestvalue)(lowbar != 1) && (Close[1] > Open[1]))
         {
            Alert(Symbol()," buy");
            flag = 0;
            return;
         }
      }
      if(/*High[1] >= highestvaluehighbar == 1)
      {
         //highestvalue = High[1];
         flag = 0;
         return;
      }         
      if(/*Low[1] <= lowestvaluelowbar == 1)
      {
         //lowestvalue = Low[1];
         flag = 1;
         return;
      }         
   }*/
   if((totalorders > 0) && (AccountProfit() >= profit))
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