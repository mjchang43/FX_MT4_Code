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
input double   首張1手獲利價格= 500.0;
input double   手數 = 1;
input int      buy單間距 = 30;
input int      sell單間距 = 30;
input int      補單間距 = 10;
input int      鎖浮盈起始張數 = 13;
input double   鎖浮盈手數倍數 = 6;
input int      鎖浮盈點數 = 20;
input int      滑價 = 13;
input int      重啟時間 = 30;
//--- parameters
double         ctrPrice;
int            ticket;
bool           lock;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   lock = false;
   if(OrdersTotal() != 0)
   {
      if(OrderSelect(0,SELECT_BY_POS,MODE_TRADES))
      {
         if( StringFind(OrderComment(),"Sell") >= 0)
         {
            ctrPrice = StrToDouble(StringSubstr(OrderComment(),0,StringFind(OrderComment(),"Sell")));
            Print("::::::"+DoubleToStr(ctrPrice,5));
         }
         else if(StringFind(OrderComment(),"Buy") >= 0)
         {
            ctrPrice = StrToDouble(StringSubstr(OrderComment(),0,StringFind(OrderComment(),"Buy")));
            Print("::::::"+DoubleToStr(ctrPrice,5));
         }
      }
   }
   else
   {
      ctrPrice = Close[0];
      Print("::::::"+DoubleToStr(ctrPrice,5));
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
      if(Close[0] > ctrPrice+(sell單間距*(鎖浮盈起始張數-1))*10*Point && !lock)
      {
         orderLock(totalorders,ctrPriceStr,4);
         lock = true;
      }
      if(Close[0] > ctrPrice+(sell單間距*20+鎖浮盈點數+補單間距)*10*Point && !chkOrderComment(totalorders,ctrPriceStr+"Sell20"))
      {
         ticket = OrderSend(NULL,OP_SELLSTOP,手數*鎖浮盈手數倍數,ctrPrice+(sell單間距*20+鎖浮盈點數)*10*Point,滑價*10,0,0,ctrPriceStr+"Sell20",0,0,clrGreen);
         if(ticket < 0)
         {
            Alert(Symbol(),"Sell20 failed");
         }
      }else if(Close[0] > ctrPrice+(sell單間距*19+鎖浮盈點數+補單間距)*10*Point && !chkOrderComment(totalorders,ctrPriceStr+"Sell19"))
      {
         ticket = OrderSend(NULL,OP_SELLSTOP,手數*鎖浮盈手數倍數,ctrPrice+(sell單間距*19+鎖浮盈點數)*10*Point,滑價*10,0,0,ctrPriceStr+"Sell19",0,0,clrGreen);
         if(ticket < 0)
         {
            Alert(Symbol(),"Sell19 failed");
         }
      }else if(Close[0] > ctrPrice+(sell單間距*18+鎖浮盈點數+補單間距)*10*Point && !chkOrderComment(totalorders,ctrPriceStr+"Sell18"))
      {
         ticket = OrderSend(NULL,OP_SELLSTOP,手數*鎖浮盈手數倍數,ctrPrice+(sell單間距*18+鎖浮盈點數)*10*Point,滑價*10,0,0,ctrPriceStr+"Sell18",0,0,clrGreen);
         if(ticket < 0)
         {
            Alert(Symbol(),"Sell18 failed");
         }
      }else if(Close[0] > ctrPrice+(sell單間距*17+鎖浮盈點數+補單間距)*10*Point && !chkOrderComment(totalorders,ctrPriceStr+"Sell17"))
      {
         ticket = OrderSend(NULL,OP_SELLSTOP,手數*鎖浮盈手數倍數,ctrPrice+(sell單間距*17+鎖浮盈點數)*10*Point,滑價*10,0,0,ctrPriceStr+"Sell17",0,0,clrGreen);
         if(ticket < 0)
         {
            Alert(Symbol(),"Sell17 failed");
         }
      }else if(Close[0] > ctrPrice+(sell單間距*16+鎖浮盈點數+補單間距)*10*Point && !chkOrderComment(totalorders,ctrPriceStr+"Sell16"))
      {
         ticket = OrderSend(NULL,OP_SELLSTOP,手數*鎖浮盈手數倍數,ctrPrice+(sell單間距*16+鎖浮盈點數)*10*Point,滑價*10,0,0,ctrPriceStr+"Sell16",0,0,clrGreen);
         if(ticket < 0)
         {
            Alert(Symbol(),"Sell16 failed");
         }
      }else if(Close[0] > ctrPrice+(sell單間距*15+鎖浮盈點數+補單間距)*10*Point && !chkOrderComment(totalorders,ctrPriceStr+"Sell15"))
      {
         ticket = OrderSend(NULL,OP_SELLSTOP,手數*鎖浮盈手數倍數,ctrPrice+(sell單間距*15+鎖浮盈點數)*10*Point,滑價*10,0,0,ctrPriceStr+"Sell15",0,0,clrGreen);
         if(ticket < 0)
         {
            Alert(Symbol(),"Sell15 failed");
         }
      }else if(Close[0] > ctrPrice+(sell單間距*14+鎖浮盈點數+補單間距)*10*Point && !chkOrderComment(totalorders,ctrPriceStr+"Sell14"))
      {
         ticket = OrderSend(NULL,OP_SELLSTOP,手數*鎖浮盈手數倍數,ctrPrice+(sell單間距*14+鎖浮盈點數)*10*Point,滑價*10,0,0,ctrPriceStr+"Sell14",0,0,clrGreen);
         if(ticket < 0)
         {
            Alert(Symbol(),"Sell14 failed");
         }
      }else if(Close[0] > ctrPrice+(sell單間距*13+鎖浮盈點數+補單間距)*10*Point && !chkOrderComment(totalorders,ctrPriceStr+"Sell13"))
      {
         ticket = OrderSend(NULL,OP_SELLSTOP,手數*鎖浮盈手數倍數,ctrPrice+(sell單間距*13+鎖浮盈點數)*10*Point,滑價*10,0,0,ctrPriceStr+"Sell13",0,0,clrGreen);
         if(ticket < 0)
         {
            Alert(Symbol(),"Sell13 failed");
         }
      }else if(Close[0] > ctrPrice+(sell單間距*12+補單間距)*10*Point && !chkOrderComment(totalorders,ctrPriceStr+"Sell12"))
      {
         ticket = OrderSend(NULL,OP_SELLSTOP,手數,ctrPrice+sell單間距*12*10*Point,滑價*10,0,0,ctrPriceStr+"Sell12",0,0,clrGreen);
         if(ticket < 0)
         {
            Alert(Symbol(),"Sell12 failed");
         }
      }else if(Close[0] > ctrPrice+(sell單間距*11+補單間距)*10*Point && !chkOrderComment(totalorders,ctrPriceStr+"Sell11"))
      {
         ticket = OrderSend(NULL,OP_SELLSTOP,手數,ctrPrice+sell單間距*11*10*Point,滑價*10,0,0,ctrPriceStr+"Sell11",0,0,clrGreen);
         if(ticket < 0)
         {
            Alert(Symbol(),"Sell11 failed");
         }
      }else if(Close[0] > ctrPrice+(sell單間距*10+補單間距)*10*Point && !chkOrderComment(totalorders,ctrPriceStr+"Sell10"))
      {
         ticket = OrderSend(NULL,OP_SELLSTOP,手數,ctrPrice+sell單間距*10*10*Point,滑價*10,0,0,ctrPriceStr+"Sell10",0,0,clrGreen);
         if(ticket < 0)
         {
            Alert(Symbol(),"Sell10 failed");
         }
      }else if(Close[0] > ctrPrice+(sell單間距*9+補單間距)*10*Point && !chkOrderComment(totalorders,ctrPriceStr+"Sell9"))
      {
         ticket = OrderSend(NULL,OP_SELLSTOP,手數,ctrPrice+sell單間距*9*10*Point,滑價*10,0,0,ctrPriceStr+"Sell9",0,0,clrGreen);
         if(ticket < 0)
         {
            Alert(Symbol(),"Sell9 failed");
         }
      }else if(Close[0] > ctrPrice+(sell單間距*8+補單間距)*10*Point && !chkOrderComment(totalorders,ctrPriceStr+"Sell8"))
      {
         ticket = OrderSend(NULL,OP_SELLSTOP,手數,ctrPrice+sell單間距*8*10*Point,滑價*10,0,0,ctrPriceStr+"Sell8",0,0,clrGreen);
         if(ticket < 0)
         {
            Alert(Symbol(),"Sell8 failed");
         }
      }else if(Close[0] > ctrPrice+(sell單間距*7+補單間距)*10*Point && !chkOrderComment(totalorders,ctrPriceStr+"Sell7"))
      {
         ticket = OrderSend(NULL,OP_SELLSTOP,手數,ctrPrice+sell單間距*7*10*Point,滑價*10,0,0,ctrPriceStr+"Sell7",0,0,clrGreen);
         if(ticket < 0)
         {
            Alert(Symbol(),"Sell7 failed");
         }
      }else if(Close[0] > ctrPrice+(sell單間距*6+補單間距)*10*Point && !chkOrderComment(totalorders,ctrPriceStr+"Sell6"))
      {
         ticket = OrderSend(NULL,OP_SELLSTOP,手數,ctrPrice+sell單間距*6*10*Point,滑價*10,0,0,ctrPriceStr+"Sell6",0,0,clrGreen);
         if(ticket < 0)
         {
            Alert(Symbol(),"Sell6 failed");
         }
      }else if(Close[0] > ctrPrice+(sell單間距*5+補單間距)*10*Point && !chkOrderComment(totalorders,ctrPriceStr+"Sell5"))
      {
         ticket = OrderSend(NULL,OP_SELLSTOP,手數,ctrPrice+sell單間距*5*10*Point,滑價*10,0,0,ctrPriceStr+"Sell5",0,0,clrGreen);
         if(ticket < 0)
         {
            Alert(Symbol(),"Sell5 failed");
         }
      }else if(Close[0] > ctrPrice+(sell單間距*4+補單間距)*10*Point && !chkOrderComment(totalorders,ctrPriceStr+"Sell4"))
      {
         ticket = OrderSend(NULL,OP_SELLSTOP,手數,ctrPrice+sell單間距*4*10*Point,滑價*10,0,0,ctrPriceStr+"Sell4",0,0,clrGreen);
         if(ticket < 0)
         {
            Alert(Symbol(),"Sell4 failed");
         }
      }else if(Close[0] > ctrPrice+(sell單間距*3+補單間距)*10*Point && !chkOrderComment(totalorders,ctrPriceStr+"Sell3"))
      {
         ticket = OrderSend(NULL,OP_SELLSTOP,手數,ctrPrice+sell單間距*3*10*Point,滑價*10,0,0,ctrPriceStr+"Sell3",0,0,clrGreen);
         if(ticket < 0)
         {
            Alert(Symbol(),"Sell3 failed");
         }
      }else if(Close[0] > ctrPrice+(sell單間距*2+補單間距)*10*Point && !chkOrderComment(totalorders,ctrPriceStr+"Sell2"))
      {
         ticket = OrderSend(NULL,OP_SELLSTOP,手數,ctrPrice+sell單間距*2*10*Point,滑價*10,0,0,ctrPriceStr+"Sell2",0,0,clrGreen);
         if(ticket < 0)
         {
            Alert(Symbol(),"Sell2 failed");
         }
      }else if(Close[0] > ctrPrice+(sell單間距*1+補單間距)*10*Point && !chkOrderComment(totalorders,ctrPriceStr+"Sell1"))
      {
         ticket = OrderSend(NULL,OP_SELLSTOP,手數,ctrPrice+sell單間距*1*10*Point,滑價*10,0,0,ctrPriceStr+"Sell1",0,0,clrGreen);
         if(ticket < 0)
         {
            Alert(Symbol(),"Sell1 failed");
         }
      }
   }else if(Close[0] < ctrPrice)
   {
      if(Close[0] < ctrPrice-(buy單間距*(鎖浮盈起始張數-1))*10*Point && !lock)
      {
         orderLock(totalorders,ctrPriceStr,5);
         lock = true;
      }
      if(Close[0] < ctrPrice-(buy單間距*20+鎖浮盈點數+補單間距)*10*Point && !chkOrderComment(totalorders,ctrPriceStr+"Buy20"))
      {
         ticket = OrderSend(NULL,OP_BUYSTOP,手數*鎖浮盈手數倍數,ctrPrice-(buy單間距*20+鎖浮盈點數)*10*Point,滑價*10,0,0,ctrPriceStr+"Buy20",0,0,clrRed);
         if(ticket < 0)
            Alert(Symbol(),"Buy20 failed");
      }else if(Close[0] < ctrPrice-(buy單間距*19+鎖浮盈點數+補單間距)*10*Point && !chkOrderComment(totalorders,ctrPriceStr+"Buy19"))
      {
         ticket = OrderSend(NULL,OP_BUYSTOP,手數*鎖浮盈手數倍數,ctrPrice-(buy單間距*19+鎖浮盈點數)*10*Point,滑價*10,0,0,ctrPriceStr+"Buy19",0,0,clrRed);
         if(ticket < 0)
            Alert(Symbol(),"Buy19 failed");
      }else if(Close[0] < ctrPrice-(buy單間距*18+鎖浮盈點數+補單間距)*10*Point && !chkOrderComment(totalorders,ctrPriceStr+"Buy18"))
      {
         ticket = OrderSend(NULL,OP_BUYSTOP,手數*鎖浮盈手數倍數,ctrPrice-(buy單間距*18+鎖浮盈點數)*10*Point,滑價*10,0,0,ctrPriceStr+"Buy18",0,0,clrRed);
         if(ticket < 0)
            Alert(Symbol(),"Buy18 failed");
      }else if(Close[0] < ctrPrice-(buy單間距*17+鎖浮盈點數+補單間距)*10*Point && !chkOrderComment(totalorders,ctrPriceStr+"Buy17"))
      {
         ticket = OrderSend(NULL,OP_BUYSTOP,手數*鎖浮盈手數倍數,ctrPrice-(buy單間距*17+鎖浮盈點數)*10*Point,滑價*10,0,0,ctrPriceStr+"Buy17",0,0,clrRed);
         if(ticket < 0)
            Alert(Symbol(),"Buy17 failed");
      }else if(Close[0] < ctrPrice-(buy單間距*16+鎖浮盈點數+補單間距)*10*Point && !chkOrderComment(totalorders,ctrPriceStr+"Buy16"))
      {
         ticket = OrderSend(NULL,OP_BUYSTOP,手數*鎖浮盈手數倍數,ctrPrice-(buy單間距*16+鎖浮盈點數)*10*Point,滑價*10,0,0,ctrPriceStr+"Buy16",0,0,clrRed);
         if(ticket < 0)
            Alert(Symbol(),"Buy16 failed");
      }else if(Close[0] < ctrPrice-(buy單間距*15+鎖浮盈點數+補單間距)*10*Point && !chkOrderComment(totalorders,ctrPriceStr+"Buy15"))
      {
         ticket = OrderSend(NULL,OP_BUYSTOP,手數*鎖浮盈手數倍數,ctrPrice-(buy單間距*15+鎖浮盈點數)*10*Point,滑價*10,0,0,ctrPriceStr+"Buy15",0,0,clrRed);
         if(ticket < 0)
            Alert(Symbol(),"Buy15 failed");
      }else if(Close[0] < ctrPrice-(buy單間距*14+鎖浮盈點數+補單間距)*10*Point && !chkOrderComment(totalorders,ctrPriceStr+"Buy14"))
      {
         ticket = OrderSend(NULL,OP_BUYSTOP,手數*鎖浮盈手數倍數,ctrPrice-(buy單間距*14+鎖浮盈點數)*10*Point,滑價*10,0,0,ctrPriceStr+"Buy14",0,0,clrRed);
         if(ticket < 0)
            Alert(Symbol(),"Buy14 failed");
      }else if(Close[0] < ctrPrice-(buy單間距*13+鎖浮盈點數+補單間距)*10*Point && !chkOrderComment(totalorders,ctrPriceStr+"Buy13"))
      {
         ticket = OrderSend(NULL,OP_BUYSTOP,手數*鎖浮盈手數倍數,ctrPrice-(buy單間距*13+鎖浮盈點數)*10*Point,滑價*10,0,0,ctrPriceStr+"Buy13",0,0,clrRed);
         if(ticket < 0)
            Alert(Symbol(),"Buy13 failed");
      }else if(Close[0] < ctrPrice-(buy單間距*12+補單間距)*10*Point && !chkOrderComment(totalorders,ctrPriceStr+"Buy12"))
      {
         ticket = OrderSend(NULL,OP_BUYSTOP,手數,ctrPrice-buy單間距*12*10*Point,滑價*10,0,0,ctrPriceStr+"Buy12",0,0,clrRed);
         if(ticket < 0)
            Alert(Symbol(),"Buy12 failed");
      }else if(Close[0] < ctrPrice-(buy單間距*11+補單間距)*10*Point && !chkOrderComment(totalorders,ctrPriceStr+"Buy11"))
      {
         ticket = OrderSend(NULL,OP_BUYSTOP,手數,ctrPrice-buy單間距*11*10*Point,滑價*10,0,0,ctrPriceStr+"Buy11",0,0,clrRed);
         if(ticket < 0)
            Alert(Symbol(),"Buy11 failed");
      }else if(Close[0] < ctrPrice-(buy單間距*10+補單間距)*10*Point && !chkOrderComment(totalorders,ctrPriceStr+"Buy10"))
      {
         ticket = OrderSend(NULL,OP_BUYSTOP,手數,ctrPrice-buy單間距*10*10*Point,滑價*10,0,0,ctrPriceStr+"Buy10",0,0,clrRed);
         if(ticket < 0)
            Alert(Symbol(),"Buy10 failed");
      }else if(Close[0] < ctrPrice-(buy單間距*9+補單間距)*10*Point && !chkOrderComment(totalorders,ctrPriceStr+"Buy9"))
      {
         ticket = OrderSend(NULL,OP_BUYSTOP,手數,ctrPrice-buy單間距*9*10*Point,滑價*10,0,0,ctrPriceStr+"Buy9",0,0,clrRed);
         if(ticket < 0)
            Alert(Symbol(),"Buy9 failed");
      }else if(Close[0] < ctrPrice-(buy單間距*8+補單間距)*10*Point && !chkOrderComment(totalorders,ctrPriceStr+"Buy8"))
      {
         ticket = OrderSend(NULL,OP_BUYSTOP,手數,ctrPrice-buy單間距*8*10*Point,滑價*10,0,0,ctrPriceStr+"Buy8",0,0,clrRed);
         if(ticket < 0)
            Alert(Symbol(),"Buy8 failed");
      }else if(Close[0] < ctrPrice-(buy單間距*7+補單間距)*10*Point && !chkOrderComment(totalorders,ctrPriceStr+"Buy7"))
      {
         ticket = OrderSend(NULL,OP_BUYSTOP,手數,ctrPrice-buy單間距*7*10*Point,滑價*10,0,0,ctrPriceStr+"Buy7",0,0,clrRed);
         if(ticket < 0)
            Alert(Symbol(),"Buy7 failed");
      }else if(Close[0] < ctrPrice-(buy單間距*6+補單間距)*10*Point && !chkOrderComment(totalorders,ctrPriceStr+"Buy6"))
      {
         ticket = OrderSend(NULL,OP_BUYSTOP,手數,ctrPrice-buy單間距*6*10*Point,滑價*10,0,0,ctrPriceStr+"Buy6",0,0,clrRed);
         if(ticket < 0)
            Alert(Symbol(),"Buy6 failed");
      }else if(Close[0] < ctrPrice-(buy單間距*5+補單間距)*10*Point && !chkOrderComment(totalorders,ctrPriceStr+"Buy5"))
      {
         ticket = OrderSend(NULL,OP_BUYSTOP,手數,ctrPrice-buy單間距*5*10*Point,滑價*10,0,0,ctrPriceStr+"Buy5",0,0,clrRed);
         if(ticket < 0)
            Alert(Symbol(),"Buy5 failed");
      }else if(Close[0] < ctrPrice-(buy單間距*4+補單間距)*10*Point && !chkOrderComment(totalorders,ctrPriceStr+"Buy4"))
      {
         ticket = OrderSend(NULL,OP_BUYSTOP,手數,ctrPrice-buy單間距*4*10*Point,滑價*10,0,0,ctrPriceStr+"Buy4",0,0,clrRed);
         if(ticket < 0)
            Alert(Symbol(),"Buy4 failed");
      }else if(Close[0] < ctrPrice-(buy單間距*3+補單間距)*10*Point && !chkOrderComment(totalorders,ctrPriceStr+"Buy3"))
      {
         ticket = OrderSend(NULL,OP_BUYSTOP,手數,ctrPrice-buy單間距*3*10*Point,滑價*10,0,0,ctrPriceStr+"Buy3",0,0,clrRed);
         if(ticket < 0)
            Alert(Symbol(),"Buy3 failed");
      }else if(Close[0] < ctrPrice-(buy單間距*2+補單間距)*10*Point && !chkOrderComment(totalorders,ctrPriceStr+"Buy2"))
      {
         ticket = OrderSend(NULL,OP_BUYSTOP,手數,ctrPrice-buy單間距*2*10*Point,滑價*10,0,0,ctrPriceStr+"Buy2",0,0,clrRed);
         if(ticket < 0)
            Alert(Symbol(),"Buy2 failed");
      }else if(Close[0] < ctrPrice-(buy單間距*1+補單間距)*10*Point && !chkOrderComment(totalorders,ctrPriceStr+"Buy1"))
      {
         ticket = OrderSend(NULL,OP_BUYSTOP,手數,ctrPrice-buy單間距*1*10*Point,滑價*10,0,0,ctrPriceStr+"Buy1",0,0,clrRed);
         if(ticket < 0)
            Alert(Symbol(),"Buy1 failed");
      }
   }
   double orderdef = MathAbs(chkOdrType(totalorders,0)-chkOdrType(totalorders,1));
   if( orderdef == 1.0)
   {
       if(AccountProfit() >= 首張1手獲利價格*手數)
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
       if(AccountProfit() >= 首張1手獲利價格*手數*2)
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
       if(AccountProfit() >= 首張1手獲利價格*手數*2+MathPow(orderdef,2)*20*手數)
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
       if(AccountProfit() >= 100*手數)
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
   datetime after = TimeLocal()+重啟時間;
   do
   {
      now = TimeLocal();
   }while(now < after);
}

//+--------------------------------------------------------------------+
void orderLock(int to,string ctrPriceStr,int property)
{
   for(int i = to-1;i >= 0;i--)
   {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
      {
         if(StringFind(OrderComment(),"Lock") >= 0)
         {
            return;
         }
      }
   }
   if(property == 4)
   {
      for(int i = 鎖浮盈起始張數;i <= 20 ; i++)
      {
         ticket = OrderSend(NULL,property,手數*鎖浮盈手數倍數,ctrPrice+sell單間距*i*10*Point,1000,0,0,ctrPriceStr+"Lock"+IntegerToString(i),0,0,clrGreen);
            if(ticket < 0)
            {
               Alert(Symbol(),"Lock"+IntegerToString(i)+" failed");
            }
      }
   }else if(property == 5)
   {
      for(int i = 鎖浮盈起始張數;i <= 20 ; i++)
      {
         ticket = OrderSend(NULL,property,手數*鎖浮盈手數倍數,ctrPrice-buy單間距*i*10*Point,1000,0,0,ctrPriceStr+"Lock"+IntegerToString(i),0,0,clrGreen);
            if(ticket < 0)
            {
               Alert(Symbol(),"Lock"+IntegerToString(i)+" failed");
            }
      }
   }
}
