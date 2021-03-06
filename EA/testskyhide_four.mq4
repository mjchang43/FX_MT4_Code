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
input double   首張獲利價格= 5.0;
input double   手數 = 0.01;
input int      首張buy單間距 = 30;
input int      buy單間距 = 30;
input int      首張sell單間距 = 30;
input int      sell單間距 = 30;
input int      補單間距 = 10;
//--- parameters
double         ctrPrice;
int            ticket;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   ctrPrice = Close[0];
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
   if(Close[0] > ctrPrice)
   {
      if(Close[0] > ctrPrice+(首張sell單間距+sell單間距*19+補單間距)*Point && !chkOrderComment(totalorders,"Sell20"))
      {
         ticket = OrderSend(NULL,OP_SELLSTOP,手數,ctrPrice+(首張sell單間距+sell單間距*19)*Point,3,0,0,"Sell20",0,0,clrGreen);
         if(ticket < 0)
         {
            Alert(Symbol(),"Sell20 failed");
         }
      }else if(Close[0] > ctrPrice+(首張sell單間距+sell單間距*18+補單間距)*Point && !chkOrderComment(totalorders,"Sell19"))
      {
         ticket = OrderSend(NULL,OP_SELLSTOP,手數,ctrPrice+(首張sell單間距+sell單間距*18)*Point,3,0,0,"Sell19",0,0,clrGreen);
         if(ticket < 0)
         {
            Alert(Symbol(),"Sell19 failed");
         }
      }else if(Close[0] > ctrPrice+(首張sell單間距+sell單間距*17+補單間距)*Point && !chkOrderComment(totalorders,"Sell18"))
      {
         ticket = OrderSend(NULL,OP_SELLSTOP,手數,ctrPrice+(首張sell單間距+sell單間距*17)*Point,3,0,0,"Sell18",0,0,clrGreen);
         if(ticket < 0)
         {
            Alert(Symbol(),"Sell18 failed");
         }
      }else if(Close[0] > ctrPrice+(首張sell單間距+sell單間距*16+補單間距)*Point && !chkOrderComment(totalorders,"Sell17"))
      {
         ticket = OrderSend(NULL,OP_SELLSTOP,手數,ctrPrice+(首張sell單間距+sell單間距*16)*Point,3,0,0,"Sell17",0,0,clrGreen);
         if(ticket < 0)
         {
            Alert(Symbol(),"Sell17 failed");
         }
      }else if(Close[0] > ctrPrice+(首張sell單間距+sell單間距*15+補單間距)*Point && !chkOrderComment(totalorders,"Sell16"))
      {
         ticket = OrderSend(NULL,OP_SELLSTOP,手數,ctrPrice+(首張sell單間距+sell單間距*15)*Point,3,0,0,"Sell16",0,0,clrGreen);
         if(ticket < 0)
         {
            Alert(Symbol(),"Sell16 failed");
         }
      }else if(Close[0] > ctrPrice+(首張sell單間距+sell單間距*14+補單間距)*Point && !chkOrderComment(totalorders,"Sell15"))
      {
         ticket = OrderSend(NULL,OP_SELLSTOP,手數,ctrPrice+(首張sell單間距+sell單間距*14)*Point,3,0,0,"Sell15",0,0,clrGreen);
         if(ticket < 0)
         {
            Alert(Symbol(),"Sell15 failed");
         }
      }else if(Close[0] > ctrPrice+(首張sell單間距+sell單間距*13+補單間距)*Point && !chkOrderComment(totalorders,"Sell14"))
      {
         ticket = OrderSend(NULL,OP_SELLSTOP,手數,ctrPrice+(首張sell單間距+sell單間距*13)*Point,3,0,0,"Sell14",0,0,clrGreen);
         if(ticket < 0)
         {
            Alert(Symbol(),"Sell14 failed");
         }
      }else if(Close[0] > ctrPrice+(首張sell單間距+sell單間距*12+補單間距)*Point && !chkOrderComment(totalorders,"Sell13"))
      {
         ticket = OrderSend(NULL,OP_SELLSTOP,手數,ctrPrice+(首張sell單間距+sell單間距*12)*Point,3,0,0,"Sell13",0,0,clrGreen);
         if(ticket < 0)
         {
            Alert(Symbol(),"Sell13 failed");
         }
      }else if(Close[0] > ctrPrice+((首張sell單間距+sell單間距*11)+補單間距)*Point && !chkOrderComment(totalorders,"Sell12"))
      {
         ticket = OrderSend(NULL,OP_SELLSTOP,手數,ctrPrice+(首張sell單間距+sell單間距*11)*Point,3,0,0,"Sell12",0,0,clrGreen);
         if(ticket < 0)
         {
            Alert(Symbol(),"Sell12 failed");
         }
      }else if(Close[0] > ctrPrice+(首張sell單間距+sell單間距*10+補單間距)*Point && !chkOrderComment(totalorders,"Sell11"))
      {
         ticket = OrderSend(NULL,OP_SELLSTOP,手數,ctrPrice+(首張sell單間距+sell單間距*10)*Point,3,0,0,"Sell11",0,0,clrGreen);
         if(ticket < 0)
         {
            Alert(Symbol(),"Sell11 failed");
         }
      }else if(Close[0] > ctrPrice+((首張sell單間距+sell單間距*9)+補單間距)*Point && !chkOrderComment(totalorders,"Sell10"))
      {
         ticket = OrderSend(NULL,OP_SELLSTOP,手數,ctrPrice+(首張sell單間距+sell單間距*9)*Point,3,0,0,"Sell10",0,0,clrGreen);
         if(ticket < 0)
         {
            Alert(Symbol(),"Sell10 failed");
         }
      }else if(Close[0] > ctrPrice+(首張sell單間距+sell單間距*8+補單間距)*Point && !chkOrderComment(totalorders,"Sell9"))
      {
         ticket = OrderSend(NULL,OP_SELLSTOP,手數,ctrPrice+(首張sell單間距+sell單間距*8)*Point,3,0,0,"Sell9",0,0,clrGreen);
         if(ticket < 0)
         {
            Alert(Symbol(),"Sell9 failed");
         }
      }else if(Close[0] > ctrPrice+(首張sell單間距+sell單間距*7+補單間距)*Point && !chkOrderComment(totalorders,"Sell8"))
      {
         ticket = OrderSend(NULL,OP_SELLSTOP,手數,ctrPrice+(首張sell單間距+sell單間距*7)*Point,3,0,0,"Sell8",0,0,clrGreen);
         if(ticket < 0)
         {
            Alert(Symbol(),"Sell8 failed");
         }
      }else if(Close[0] > ctrPrice+((首張sell單間距+sell單間距*6)+補單間距)*Point && !chkOrderComment(totalorders,"Sell7"))
      {
         ticket = OrderSend(NULL,OP_SELLSTOP,手數,ctrPrice+(首張sell單間距+sell單間距*6)*Point,3,0,0,"Sell7",0,0,clrGreen);
         if(ticket < 0)
         {
            Alert(Symbol(),"Sell7 failed");
         }
      }else if(Close[0] > ctrPrice+(首張sell單間距+sell單間距*5+補單間距)*Point && !chkOrderComment(totalorders,"Sell6"))
      {
         ticket = OrderSend(NULL,OP_SELLSTOP,手數,ctrPrice+(首張sell單間距+sell單間距*5)*Point,3,0,0,"Sell6",0,0,clrGreen);
         if(ticket < 0)
         {
            Alert(Symbol(),"Sell6 failed");
         }
      }else if(Close[0] > ctrPrice+(首張sell單間距+sell單間距*4+補單間距)*Point && !chkOrderComment(totalorders,"Sell5"))
      {
         ticket = OrderSend(NULL,OP_SELLSTOP,手數,ctrPrice+(首張sell單間距+sell單間距*4)*Point,3,0,0,"Sell5",0,0,clrGreen);
         if(ticket < 0)
         {
            Alert(Symbol(),"Sell5 failed");
         }
      }else if(Close[0] > ctrPrice+((首張sell單間距+sell單間距*3)+補單間距)*Point && !chkOrderComment(totalorders,"Sell4"))
      {
         ticket = OrderSend(NULL,OP_SELLSTOP,手數,ctrPrice+(首張sell單間距+sell單間距*3)*Point,3,0,0,"Sell4",0,0,clrGreen);
         if(ticket < 0)
         {
            Alert(Symbol(),"Sell4 failed");
         }
      }else if(Close[0] > ctrPrice+(首張sell單間距+sell單間距*2+補單間距)*Point && !chkOrderComment(totalorders,"Sell3"))
      {
         ticket = OrderSend(NULL,OP_SELLSTOP,手數,ctrPrice+(首張sell單間距+sell單間距*2)*Point,3,0,0,"Sell3",0,0,clrGreen);
         if(ticket < 0)
         {
            Alert(Symbol(),"Sell3 failed");
         }
      }else if(Close[0] > ctrPrice+(首張sell單間距+sell單間距*1+補單間距)*Point && !chkOrderComment(totalorders,"Sell2"))
      {
         ticket = OrderSend(NULL,OP_SELLSTOP,手數,ctrPrice+(首張sell單間距+sell單間距*1)*Point,3,0,0,"Sell2",0,0,clrGreen);
         if(ticket < 0)
         {
            Alert(Symbol(),"Sell2 failed");
         }
      }else if(Close[0] > ctrPrice+(首張sell單間距+補單間距)*Point && !chkOrderComment(totalorders,"Sell1"))
      {
         ticket = OrderSend(NULL,OP_SELLSTOP,手數,ctrPrice+首張sell單間距*Point,3,0,0,"Sell1",0,0,clrGreen);
         if(ticket < 0)
         {
            Alert(Symbol(),"Sell1 failed");
         }
      }
   }else if(Close[0] < ctrPrice)
   {
      if(Close[0] < ctrPrice-((首張buy單間距+buy單間距*19)+補單間距)*Point && !chkOrderComment(totalorders,"Buy20"))
      {
         ticket = OrderSend(NULL,OP_BUYSTOP,手數,ctrPrice-(首張buy單間距+buy單間距*19)*Point,3,0,0,"Buy20",0,0,clrRed);
         if(ticket < 0)
            Alert(Symbol(),"Buy20 failed");
      }else if(Close[0] < ctrPrice-((首張buy單間距+buy單間距*18)+補單間距)*Point && !chkOrderComment(totalorders,"Buy19"))
      {
         ticket = OrderSend(NULL,OP_BUYSTOP,手數,ctrPrice-(首張buy單間距+buy單間距*18)*Point,3,0,0,"Buy19",0,0,clrRed);
         if(ticket < 0)
            Alert(Symbol(),"Buy19 failed");
      }else if(Close[0] < ctrPrice-(首張buy單間距+buy單間距*17+補單間距)*Point && !chkOrderComment(totalorders,"Buy18"))
      {
         ticket = OrderSend(NULL,OP_BUYSTOP,手數,ctrPrice-(首張buy單間距+buy單間距*17)*Point,3,0,0,"Buy18",0,0,clrRed);
         if(ticket < 0)
            Alert(Symbol(),"Buy18 failed");
      }else if(Close[0] < ctrPrice-(首張buy單間距+buy單間距*16+補單間距)*Point && !chkOrderComment(totalorders,"Buy17"))
      {
         ticket = OrderSend(NULL,OP_BUYSTOP,手數,ctrPrice-(首張buy單間距+buy單間距*16)*Point,3,0,0,"Buy17",0,0,clrRed);
         if(ticket < 0)
            Alert(Symbol(),"Buy17 failed");
      }else if(Close[0] < ctrPrice-(首張buy單間距+buy單間距*15+補單間距)*Point && !chkOrderComment(totalorders,"Buy16"))
      {
         ticket = OrderSend(NULL,OP_BUYSTOP,手數,ctrPrice-(首張buy單間距+buy單間距*15)*Point,3,0,0,"Buy16",0,0,clrRed);
         if(ticket < 0)
            Alert(Symbol(),"Buy16 failed");
      }else if(Close[0] < ctrPrice-(首張buy單間距+buy單間距*14+補單間距)*Point && !chkOrderComment(totalorders,"Buy15"))
      {
         ticket = OrderSend(NULL,OP_BUYSTOP,手數,ctrPrice-(首張buy單間距+buy單間距*14)*Point,3,0,0,"Buy15",0,0,clrRed);
         if(ticket < 0)
            Alert(Symbol(),"Buy15 failed");
      }else if(Close[0] < ctrPrice-(首張buy單間距+buy單間距*13+補單間距)*Point && !chkOrderComment(totalorders,"Buy14"))
      {
         ticket = OrderSend(NULL,OP_BUYSTOP,手數,ctrPrice-(首張buy單間距+buy單間距*13)*Point,3,0,0,"Buy14",0,0,clrRed);
         if(ticket < 0)
            Alert(Symbol(),"Buy14 failed");
      }else if(Close[0] < ctrPrice-((首張buy單間距+buy單間距*12)+補單間距)*Point && !chkOrderComment(totalorders,"Buy13"))
      {
         ticket = OrderSend(NULL,OP_BUYSTOP,手數,ctrPrice-(首張buy單間距+buy單間距*12)*Point,3,0,0,"Buy13",0,0,clrRed);
         if(ticket < 0)
            Alert(Symbol(),"Buy13 failed");
      }else if(Close[0] < ctrPrice-(首張buy單間距+buy單間距*11+補單間距)*Point && !chkOrderComment(totalorders,"Buy12"))
      {
         ticket = OrderSend(NULL,OP_BUYSTOP,手數,ctrPrice-(首張buy單間距+buy單間距*11)*Point,3,0,0,"Buy12",0,0,clrRed);
         if(ticket < 0)
            Alert(Symbol(),"Buy12 failed");
      }else if(Close[0] < ctrPrice-(首張buy單間距+buy單間距*10+補單間距)*Point && !chkOrderComment(totalorders,"Buy11"))
      {
         ticket = OrderSend(NULL,OP_BUYSTOP,手數,ctrPrice-(首張buy單間距+buy單間距*10)*Point,3,0,0,"Buy11",0,0,clrRed);
         if(ticket < 0)
            Alert(Symbol(),"Buy11 failed");
      }else if(Close[0] < ctrPrice-(首張buy單間距+buy單間距*9+補單間距)*Point && !chkOrderComment(totalorders,"Buy10"))
      {
         ticket = OrderSend(NULL,OP_BUYSTOP,手數,ctrPrice-(首張buy單間距+buy單間距*9)*Point,3,0,0,"Buy10",0,0,clrRed);
         if(ticket < 0)
            Alert(Symbol(),"Buy10 failed");
      }else if(Close[0] < ctrPrice-(首張buy單間距+buy單間距*8+補單間距)*Point && !chkOrderComment(totalorders,"Buy9"))
      {
         ticket = OrderSend(NULL,OP_BUYSTOP,手數,ctrPrice-(首張buy單間距+buy單間距*8)*Point,3,0,0,"Buy9",0,0,clrRed);
         if(ticket < 0)
            Alert(Symbol(),"Buy9 failed");
      }else if(Close[0] < ctrPrice-(首張buy單間距+buy單間距*7+補單間距)*Point && !chkOrderComment(totalorders,"Buy8"))
      {
         ticket = OrderSend(NULL,OP_BUYSTOP,手數,ctrPrice-(首張buy單間距+buy單間距*7)*Point,3,0,0,"Buy8",0,0,clrRed);
         if(ticket < 0)
            Alert(Symbol(),"Buy8 failed");
      }else if(Close[0] < ctrPrice-(首張buy單間距+buy單間距*6+補單間距)*Point && !chkOrderComment(totalorders,"Buy7"))
      {
         ticket = OrderSend(NULL,OP_BUYSTOP,手數,ctrPrice-(首張buy單間距+buy單間距*6)*Point,3,0,0,"Buy7",0,0,clrRed);
         if(ticket < 0)
            Alert(Symbol(),"Buy7 failed");
      }else if(Close[0] < ctrPrice-(首張buy單間距+buy單間距*5+補單間距)*Point && !chkOrderComment(totalorders,"Buy6"))
      {
         ticket = OrderSend(NULL,OP_BUYSTOP,手數,ctrPrice-(首張buy單間距+buy單間距*5)*Point,3,0,0,"Buy6",0,0,clrRed);
         if(ticket < 0)
            Alert(Symbol(),"Buy6 failed");
      }else if(Close[0] < ctrPrice-(首張buy單間距+buy單間距*4+補單間距)*Point && !chkOrderComment(totalorders,"Buy5"))
      {
         ticket = OrderSend(NULL,OP_BUYSTOP,手數,ctrPrice-(首張buy單間距+buy單間距*4)*Point,3,0,0,"Buy5",0,0,clrRed);
         if(ticket < 0)
            Alert(Symbol(),"Buy5 failed");
      }else if(Close[0] < ctrPrice-(首張buy單間距+buy單間距*3+補單間距)*Point && !chkOrderComment(totalorders,"Buy4"))
      {
         ticket = OrderSend(NULL,OP_BUYSTOP,手數,ctrPrice-(首張buy單間距+buy單間距*3)*Point,3,0,0,"Buy4",0,0,clrRed);
         if(ticket < 0)
            Alert(Symbol(),"Buy4 failed");
      }else if(Close[0] < ctrPrice-(首張buy單間距+buy單間距*2+補單間距)*Point && !chkOrderComment(totalorders,"Buy3"))
      {
         ticket = OrderSend(NULL,OP_BUYSTOP,手數,ctrPrice-(首張buy單間距+buy單間距*2)*Point,3,0,0,"Buy3",0,0,clrRed);
         if(ticket < 0)
            Alert(Symbol(),"Buy3 failed");
      }else if(Close[0] < ctrPrice-(首張buy單間距+buy單間距*1+補單間距)*Point && !chkOrderComment(totalorders,"Buy2"))
      {
         ticket = OrderSend(NULL,OP_BUYSTOP,手數,ctrPrice-(首張buy單間距+buy單間距*1)*Point,3,0,0,"Buy2",0,0,clrRed);
         if(ticket < 0)
            Alert(Symbol(),"Buy2 failed");
      }else if(Close[0] < ctrPrice-(首張buy單間距+補單間距)*Point && !chkOrderComment(totalorders,"Buy1"))
      {
         ticket = OrderSend(NULL,OP_BUYSTOP,手數,ctrPrice-首張buy單間距*Point,3,0,0,"Buy1",0,0,clrRed);
         if(ticket < 0)
            Alert(Symbol(),"Buy1 failed");
      }
   }
   double orderdef = MathAbs(chkOdrType(totalorders,0)-chkOdrType(totalorders,1));
   if( orderdef == 1.0)
   {
       if(AccountProfit() >= 首張獲利價格)
       {
         if(clrOrders(totalorders))
            OnInit();
         else
            ExpertRemove();
       }
   }else if(orderdef == 2.0)
   {
       if(AccountProfit() >= 首張獲利價格*2)
       {
         if(clrOrders(totalorders))
            OnInit();
         else
            ExpertRemove();
       }
   }else if(orderdef >= 3.0)
   {
       if(AccountProfit() >= 首張獲利價格*2+MathPow(orderdef,2)*20*手數)
       {
         if(clrOrders(totalorders))
            OnInit();
         else
            ExpertRemove();
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
            if(!OrderClose(OrderTicket(),OrderLots(),Bid,3))
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
            if(!OrderClose(OrderTicket(),OrderLots(),Ask,3))
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