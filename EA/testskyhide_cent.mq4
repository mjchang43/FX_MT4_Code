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
input double   首張1手獲利價格= 300.0;
input double   單張手數 = 1;
input int      buy單間距 = 30;
input int      sell單間距 = 30;
input double   各單間距放大倍數 = 2;
input int      補單間距 = 10;
input double   補單間距放大倍數 = 3;
input int      單邊最大張數 = 30;
input int      鎖浮盈起始張數 = 13;
input double   鎖浮盈手數倍數 = 6;
input int      鎖浮盈點數 = 30;
input int      滑價 = 3;
input int      吃進第幾張單開始採用公式 = 3;
input int      公式獲利減幅百分比 = 80;
input int      吃進第幾張單開始採次止盈 = 13;
input double   次止盈獲利價格= 100.0;
input int      重啟時間 = 30;
//--- parameters
double         ctrPrice;
int            ticket;
double         sPrice[];
double         bPrice[];
bool           lock;
double         手數;
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
         if(OrderType() <= 1){
            
            手數 = OrderLots();
         }else{
         
            手數 = 單張手數;
         }
         
         if( StringFind(OrderComment(),"Sell") >= 0)
         {
            ctrPrice = StrToDouble(StringSubstr(OrderComment(),0,StringFind(OrderComment(),"Sell")));
         }
         else if(StringFind(OrderComment(),"Buy") >= 0)
         {
            ctrPrice = StrToDouble(StringSubstr(OrderComment(),0,StringFind(OrderComment(),"Buy")));
         }
         
         if(StringFind(OrderComment(),"Lock") >= 0)
         {
            lock = true;
         }
      }
   }
   else
   {
      ctrPrice = Close[0];
      if(AccountBalance() >= 單張手數*700*100)
      {
         手數 = 單張手數;
      }else if(AccountBalance() < 700*100)
      {
         手數 = 1;
      }
      else{
         
         手數 = floor(AccountBalance()/700/100);
      }
   }
   Print("::::::"+DoubleToStr(手數));
   Print("::::::"+DoubleToStr(ctrPrice,5));
   ArrayResize(sPrice,單邊最大張數);
   ArrayResize(bPrice,單邊最大張數);
   for(int i = 1;i <= 單邊最大張數;i++)
   {
      if(i < 鎖浮盈起始張數)
      {
         sPrice[i-1] = ctrPrice+sell單間距*i*10*Point;
         bPrice[i-1] = ctrPrice-buy單間距*i*10*Point;
      }
      else
      {
         sPrice[i-1] = sPrice[鎖浮盈起始張數-2]+sell單間距*(i-鎖浮盈起始張數+1)*各單間距放大倍數*10*Point;
         bPrice[i-1] = bPrice[鎖浮盈起始張數-2]-buy單間距*(i-鎖浮盈起始張數+1)*各單間距放大倍數*10*Point;
      }
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
   double pointDif = Ask-Bid;
   
   if(Close[0] > ctrPrice)
   {
      if(!lock && Close[0] > ctrPrice+(sell單間距*(鎖浮盈起始張數-1))*10*Point)
      {
         orderLock(totalorders,ctrPriceStr,4);
         lock = true;
      }
      for(int i = 0;i < 單邊最大張數;i++)
      {
         if(i >= 鎖浮盈起始張數-1)
         {
            if(chkOrderTypeAndComment(totalorders,0,ctrPriceStr+"Lock"+IntegerToString(i+2)) 
               && !chkOrderComment(totalorders,ctrPriceStr+"Sell"+IntegerToString(i+1)))
            {
               ticket = OrderSend(NULL,OP_SELLSTOP,手數*鎖浮盈手數倍數,sPrice[i]+pointDif+鎖浮盈點數*10*Point,(鎖浮盈點數+滑價)*10,0,0,ctrPriceStr+"Sell"+IntegerToString(i+1),0,0,clrGreen);
               if(ticket < 0)
               {
                  Alert(Symbol(),"Sell"+IntegerToString(i+1)+" failed"+DoubleToStr(sPrice[i]+pointDif+鎖浮盈點數*10*Point,5));
               }
            }
         }
         else
         {
            if(Close[0] > sPrice[i]+補單間距*10*Point && !chkOrderComment(totalorders,ctrPriceStr+"Sell"+IntegerToString(i+1)))
            {
               ticket = OrderSend(NULL,OP_SELLSTOP,手數,sPrice[i],(補單間距+滑價)*10,0,0,ctrPriceStr+"Sell"+IntegerToString(i+1),0,0,clrGreen);
               if(ticket < 0)
               {
                  Alert(Symbol(),"Sell"+IntegerToString(i+1)+" failed"+DoubleToStr(sPrice[i],5));
               }
            }
         }
      }
   }else if(Close[0] < ctrPrice)
   {
      if(!lock && Close[0] < ctrPrice-(buy單間距*(鎖浮盈起始張數-1))*10*Point)
      {
         orderLock(totalorders,ctrPriceStr,5);
         lock = true;
      }
      for(int i = 0;i < 單邊最大張數;i++)
      {
         if(i >= 鎖浮盈起始張數-1)
         {
            if(chkOrderTypeAndComment(totalorders,1,ctrPriceStr+"Lock"+IntegerToString(i+2)) 
               && !chkOrderComment(totalorders,ctrPriceStr+"Buy"+IntegerToString(i+1)))
            {
               ticket = OrderSend(NULL,OP_BUYSTOP,手數*鎖浮盈手數倍數,bPrice[i]-pointDif-鎖浮盈點數*10*Point,(鎖浮盈點數+滑價)*10,0,0,ctrPriceStr+"Buy"+IntegerToString(i+1),0,0,clrRed);
               if(ticket < 0)
               {
                  Alert(Symbol(),"Buy"+IntegerToString(i+1)+" failed"+DoubleToStr(bPrice[i]-pointDif-鎖浮盈點數*10*Point,5));
               }
            }
         }
         else
         {
            if(Close[0] < bPrice[i]-補單間距*10*Point && !chkOrderComment(totalorders,ctrPriceStr+"Buy"+IntegerToString(i+1)))
            {
               ticket = OrderSend(NULL,OP_BUYSTOP,手數,bPrice[i],(補單間距+滑價)*10,0,0,ctrPriceStr+"Buy"+IntegerToString(i+1),0,0,clrRed);
               if(ticket < 0)
               {
                  Alert(Symbol(),"Buy"+IntegerToString(i+1)+" failed"+DoubleToStr(bPrice[i],5));
               }
            }
         }
      }
   }
   
   int buyCount = 0;
   double buyLots =0.0;
   int sellCount = 0;
   double sellLots =0.0;
   
   for(int i = totalorders-1;i >= 0;i--)
   {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
      {
         if(OrderType() == 0)
         {
            buyCount++;
            buyLots += OrderLots();
         }
         else if(OrderType() == 1)
         {
            sellCount++;
            sellLots += OrderLots();
         }
      }
   }
   
   int orderdef = MathAbs(buyCount-sellCount);
   double lotsDef = MathAbs(buyLots-sellLots);
   
   if(orderdef > 0 && orderdef < 吃進第幾張單開始採用公式)
   {
       if(AccountProfit() >= 首張1手獲利價格*手數*orderdef)
       {
         clrOrders(totalorders);
       }
   }else if(orderdef >= (吃進第幾張單開始採次止盈-1) && buyCount > 0 && sellCount > 0)
   {
      if(鎖浮盈起始張數%2 == 0)
      {
         if((buyCount+sellCount)%2 == 0)
         {
            if(buyCount > sellCount)
            {
               if(AccountProfit() >= 次止盈獲利價格*手數 || Close[0] >= iBands(NULL,240,20,2,0,PRICE_CLOSE,MODE_MAIN,0))
               {
                  clrOrders(totalorders);
               }
            }
            else if(sellCount > buyCount)
            {
               if(AccountProfit() >= 次止盈獲利價格*手數 || Close[0] <= iBands(NULL,240,20,2,0,PRICE_CLOSE,MODE_MAIN,0))
               {
                  clrOrders(totalorders);
               }
            }
         }
      }
      else
      {
         if((buyCount+sellCount)%2 == 1)
         {
            if(buyCount > sellCount)
            {
               if(AccountProfit() >= 次止盈獲利價格*手數 || Close[0] >= iBands(NULL,240,20,2,0,PRICE_CLOSE,MODE_MAIN,0))
               {
                  clrOrders(totalorders);
               }
            }
            else if(sellCount > buyCount)
            {
               if(AccountProfit() >= 次止盈獲利價格*手數 || Close[0] <= iBands(NULL,240,20,2,0,PRICE_CLOSE,MODE_MAIN,0))
               {
                  clrOrders(totalorders);
               }
            }
         }
      }
       
   }else{
   
      //if(AccountProfit() >= 首張1手獲利價格*手數*2+MathPow(orderdef,2)*20*手數)
      if(orderdef > 0 && AccountProfit() >= 首張1手獲利價格*手數*orderdef*公式獲利減幅百分比/100)
      {
         clrOrders(totalorders);
      }
   }
  }
//+------------------------------------------------------------------+
void clrOrders(int to)
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
               break;
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
               break;
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
               break;
            }
            else
               to--;
         }
      }
   }while(to > 0);
   
   if(OrdersTotal() > 0)
   {
      clrOrders(OrdersTotal());
   }
   
   onTimer();
   OnInit();
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
bool chkOrderTypeAndComment(int to,int type,string comment)
{
   for(int i = to-1;i >= 0;i--)
   {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
      {
         if(StringCompare(OrderComment(),comment) == 0 && OrderType() == type)
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
      for(int i = 鎖浮盈起始張數-1;i < 單邊最大張數 ; i++)
      {
         ticket = OrderSend(NULL,property,手數*鎖浮盈手數倍數,sPrice[i],10000,0,0,ctrPriceStr+"Lock"+IntegerToString(i+1),0,0,clrGreen);
            if(ticket < 0)
            {
               Alert(Symbol(),"Lock"+IntegerToString(i+1)+" failed"+DoubleToStr(sPrice[i],5));
            }
      }
   }else if(property == 5)
   {
      for(int i = 鎖浮盈起始張數-1;i < 單邊最大張數 ; i++)
      {
         ticket = OrderSend(NULL,property,手數*鎖浮盈手數倍數,bPrice[i],10000,0,0,ctrPriceStr+"Lock"+IntegerToString(i+1),0,0,clrGreen);
            if(ticket < 0)
            {
               Alert(Symbol(),"Lock"+IntegerToString(i+1)+" failed"+DoubleToStr(bPrice[i],5));
            }
      }
   }
}
