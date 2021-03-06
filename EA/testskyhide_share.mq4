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
input double   手數 = 0.01;
input int      buy單間距 = 10;
input int      sell單間距 = 10;
input int      補單間距 = 10;
//--- parameters
double         ctrPrice;
int            ticket;
double         sPrice[20];
double         bPrice[20];
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   if(OrdersTotal() != 0)
   {
      if(OrderSelect(0,SELECT_BY_POS,MODE_TRADES))
      {
         if( StringFind(OrderComment(),"Sell") >= 0)
         {
            ctrPrice = StrToDouble(StringSubstr(OrderComment(),0,StringFind(OrderComment(),"Sell")));
         }
         else if(StringFind(OrderComment(),"Buy") >= 0)
         {
            ctrPrice = StrToDouble(StringSubstr(OrderComment(),0,StringFind(OrderComment(),"Buy")));
         }
      }
   }
   else
   {
      ctrPrice = Close[0];
   }
   Print("::::::"+DoubleToStr(ctrPrice,5));
   for(int i = 1;i <= 20;i++)
   {
      sPrice[i-1] = ctrPrice+sell單間距*i*10*Point;
      bPrice[i-1] = ctrPrice-buy單間距*i*10*Point;
   }
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
   string ctrPriceStr = DoubleToStr(ctrPrice,5);
   
   if(Close[0] > ctrPrice)
   {
      if(Close[0] > sPrice[9]+補單間距*10*Point && !chkOrderComment(totalorders,ctrPriceStr+"Sell10"))
      {
         ticket = OrderSend(NULL,OP_SELLSTOP,手數,sPrice[9],1000,0,0,ctrPriceStr+"Sell10",0,0,clrGreen);
         if(ticket < 0)
         {
            Alert(Symbol(),"Sell10 failed");
         }
      }else if(Close[0] > sPrice[8]+補單間距*10*Point && !chkOrderComment(totalorders,ctrPriceStr+"Sell9"))
      {
         ticket = OrderSend(NULL,OP_SELLSTOP,手數,sPrice[8],1000,0,0,ctrPriceStr+"Sell9",0,0,clrGreen);
         if(ticket < 0)
         {
            Alert(Symbol(),"Sell9 failed");
         }
      }else if(Close[0] > sPrice[7]+補單間距*10*Point && !chkOrderComment(totalorders,ctrPriceStr+"Sell8"))
      {
         ticket = OrderSend(NULL,OP_SELLSTOP,手數,sPrice[7],1000,0,0,ctrPriceStr+"Sell8",0,0,clrGreen);
         if(ticket < 0)
         {
            Alert(Symbol(),"Sell8 failed");
         }
      }else if(Close[0] > sPrice[6]+補單間距*10*Point && !chkOrderComment(totalorders,ctrPriceStr+"Sell7"))
      {
         ticket = OrderSend(NULL,OP_SELLSTOP,手數,sPrice[6],1000,0,0,ctrPriceStr+"Sell7",0,0,clrGreen);
         if(ticket < 0)
         {
            Alert(Symbol(),"Sell7 failed");
         }
      }else if(Close[0] > sPrice[5]+補單間距*10*Point && !chkOrderComment(totalorders,ctrPriceStr+"Sell6"))
      {
         ticket = OrderSend(NULL,OP_SELLSTOP,手數,sPrice[5],1000,0,0,ctrPriceStr+"Sell6",0,0,clrGreen);
         if(ticket < 0)
         {
            Alert(Symbol(),"Sell6 failed");
         }
      }else if(Close[0] > sPrice[4]+補單間距*10*Point && !chkOrderComment(totalorders,ctrPriceStr+"Sell5"))
      {
         ticket = OrderSend(NULL,OP_SELLSTOP,手數,sPrice[4],1000,0,0,ctrPriceStr+"Sell5",0,0,clrGreen);
         if(ticket < 0)
         {
            Alert(Symbol(),"Sell5 failed");
         }
      }else if(Close[0] > sPrice[3]+補單間距*10*Point && !chkOrderComment(totalorders,ctrPriceStr+"Sell4"))
      {
         ticket = OrderSend(NULL,OP_SELLSTOP,手數,sPrice[3],1000,0,0,ctrPriceStr+"Sell4",0,0,clrGreen);
         if(ticket < 0)
         {
            Alert(Symbol(),"Sell4 failed");
         }
      }else if(Close[0] > sPrice[2]+補單間距*10*Point && !chkOrderComment(totalorders,ctrPriceStr+"Sell3"))
      {
         ticket = OrderSend(NULL,OP_SELLSTOP,手數,sPrice[2],1000,0,0,ctrPriceStr+"Sell3",0,0,clrGreen);
         if(ticket < 0)
         {
            Alert(Symbol(),"Sell3 failed");
         }
      }else if(Close[0] > sPrice[1]+補單間距*10*Point && !chkOrderComment(totalorders,ctrPriceStr+"Sell2"))
      {
         ticket = OrderSend(NULL,OP_SELLSTOP,手數,sPrice[1],1000,0,0,ctrPriceStr+"Sell2",0,0,clrGreen);
         if(ticket < 0)
         {
            Alert(Symbol(),"Sell2 failed");
         }
      }else if(Close[0] > sPrice[0]+補單間距*10*Point && !chkOrderComment(totalorders,ctrPriceStr+"Sell1"))
      {
         ticket = OrderSend(NULL,OP_SELLSTOP,手數,sPrice[0],1000,0,0,ctrPriceStr+"Sell1",0,0,clrGreen);
         if(ticket < 0)
         {
            Alert(Symbol(),"Sell1 failed");
         }
      }
   }else if(Close[0] < ctrPrice)
   {
      if(Close[0] < bPrice[9]-補單間距*10*Point && !chkOrderComment(totalorders,ctrPriceStr+"Buy10"))
      {
         ticket = OrderSend(NULL,OP_BUYSTOP,手數,bPrice[9],1000,0,0,ctrPriceStr+"Buy10",0,0,clrRed);
         if(ticket < 0)
            Alert(Symbol(),"Buy10 failed");
      }else if(Close[0] < bPrice[8]-補單間距*10*Point && !chkOrderComment(totalorders,ctrPriceStr+"Buy9"))
      {
         ticket = OrderSend(NULL,OP_BUYSTOP,手數,bPrice[8],1000,0,0,ctrPriceStr+"Buy9",0,0,clrRed);
         if(ticket < 0)
            Alert(Symbol(),"Buy9 failed");
      }else if(Close[0] < bPrice[7]-補單間距*10*Point && !chkOrderComment(totalorders,ctrPriceStr+"Buy8"))
      {
         ticket = OrderSend(NULL,OP_BUYSTOP,手數,bPrice[7],1000,0,0,ctrPriceStr+"Buy8",0,0,clrRed);
         if(ticket < 0)
            Alert(Symbol(),"Buy8 failed");
      }else if(Close[0] < bPrice[6]-補單間距*10*Point && !chkOrderComment(totalorders,ctrPriceStr+"Buy7"))
      {
         ticket = OrderSend(NULL,OP_BUYSTOP,手數,bPrice[6],1000,0,0,ctrPriceStr+"Buy7",0,0,clrRed);
         if(ticket < 0)
            Alert(Symbol(),"Buy7 failed");
      }else if(Close[0] < bPrice[5]-補單間距*10*Point && !chkOrderComment(totalorders,ctrPriceStr+"Buy6"))
      {
         ticket = OrderSend(NULL,OP_BUYSTOP,手數,bPrice[5],1000,0,0,ctrPriceStr+"Buy6",0,0,clrRed);
         if(ticket < 0)
            Alert(Symbol(),"Buy6 failed");
      }else if(Close[0] < bPrice[4]-補單間距*10*Point && !chkOrderComment(totalorders,ctrPriceStr+"Buy5"))
      {
         ticket = OrderSend(NULL,OP_BUYSTOP,手數,bPrice[4],1000,0,0,ctrPriceStr+"Buy5",0,0,clrRed);
         if(ticket < 0)
            Alert(Symbol(),"Buy5 failed");
      }else if(Close[0] < bPrice[3]-補單間距*10*Point && !chkOrderComment(totalorders,ctrPriceStr+"Buy4"))
      {
         ticket = OrderSend(NULL,OP_BUYSTOP,手數,bPrice[3],1000,0,0,ctrPriceStr+"Buy4",0,0,clrRed);
         if(ticket < 0)
            Alert(Symbol(),"Buy4 failed");
      }else if(Close[0] < bPrice[2]-補單間距*10*Point && !chkOrderComment(totalorders,ctrPriceStr+"Buy3"))
      {
         ticket = OrderSend(NULL,OP_BUYSTOP,手數,bPrice[2],1000,0,0,ctrPriceStr+"Buy3",0,0,clrRed);
         if(ticket < 0)
            Alert(Symbol(),"Buy3 failed");
      }else if(Close[0] < bPrice[1]-補單間距*10*Point && !chkOrderComment(totalorders,ctrPriceStr+"Buy2"))
      {
         ticket = OrderSend(NULL,OP_BUYSTOP,手數,bPrice[1],1000,0,0,ctrPriceStr+"Buy2",0,0,clrRed);
         if(ticket < 0)
            Alert(Symbol(),"Buy2 failed");
      }else if(Close[0] < bPrice[0]-補單間距*10*Point && !chkOrderComment(totalorders,ctrPriceStr+"Buy1"))
      {
         ticket = OrderSend(NULL,OP_BUYSTOP,手數,bPrice[0],1000,0,0,ctrPriceStr+"Buy1",0,0,clrRed);
         if(ticket < 0)
            Alert(Symbol(),"Buy1 failed");
      }
   }
   double orderdef = MathAbs(chkOdrType(totalorders,0)-chkOdrType(totalorders,1));
   if( orderdef == 1.0)
   {
       if(AccountProfit() >= 5)
       {
         if(clrOrders(totalorders))
         {
            onTimer();
            OnInit();
         }
         else
         {
            totalorders = OrdersTotal();
            clrOrders(totalorders);
            ExpertRemove();
         }
       }
   }else if(orderdef == 2.0)
   {
       if(AccountProfit() >= 5)
       {
         if(clrOrders(totalorders))
         {
            onTimer();
            OnInit();
         }
         else
         {
            totalorders = OrdersTotal();
            clrOrders(totalorders);
            ExpertRemove();
         }
       }
   }else if(orderdef >= 3.0 && orderdef <= 12.0)
   {
       if(AccountProfit() >= 5)
       {
         if(clrOrders(totalorders))
         {
            onTimer();
            OnInit();
         }
         else
         {
            totalorders = OrdersTotal();
            clrOrders(totalorders);
            ExpertRemove();
         }
       }
   }else if(orderdef > 12.0)
   {
       if(AccountProfit() >= 5)
       {
         if(clrOrders(totalorders))
         {
            onTimer();
            OnInit();
         }
         else
         {
            totalorders = OrdersTotal();
            clrOrders(totalorders);
            ExpertRemove();
         }
       }
   }
  }
//+------------------------------------------------------------------+
bool clrOrders(int to)
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
               return true;
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
               return true;
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
               return true;
            }
            else
               to--;
         }
      }
   }while(to > 0);
   return false;
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
//+--------------------------------------------------------------------+
bool chkOrderComment(int to,string comment)
{
   for(int i = to-1;i >= 0;i--)
   {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
      {
         if(StringCompare(OrderComment(),comment) == 0)
         {
            return true;
         }
      }
   }
   return false;
}
//+--------------------------------------------------------------------+
void onTimer()
{
   datetime now = TimeLocal();
   datetime after = TimeLocal()+30;
   do
   {
      now = TimeLocal();
   }while(now < after);
}
//+--------------------------------------------------------------------+
