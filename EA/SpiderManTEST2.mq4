
//輸入參數對話框---------------------
extern int 輸入開始時間HH=00; 
extern int 輸入結束時間HH=24; 

extern string 　="-------------------------------";

extern string 中心線上方Buy; 
extern double 中心線上方buy手數=0.01;
extern int Buy距中心線上方幾點=20;
extern int 中心線上方buy單數=4;
extern int 中心線上方buy間格=20;
extern bool 中心線上方BuyStop開關=true;
extern bool 中心線上方Buy出場後再補單開關=true;
extern int 中心線上方buy幾點外才補單=5;

extern string  　　="-------------------------------";

extern string 中心線下方sell; 
extern double 中心線下方sell手數=0.01;
extern int sell距中心線下方幾點=20;
extern int 中心線下方sell單數=4;
extern int 中心線下方sell間格=20;
extern bool 中心線下方SellStop開關=true;
extern bool 中心線下方sell出場後再補單開關=true;
extern int 中心線下方sell幾點外才補單=5;

extern string  　　　="-------------------------------";

extern string 中心線上方sell; 
extern double 中心線上方sell手數=0.01;
extern int sell距中心線上方幾點=20;
extern int 中心線上方sell單數=4;
extern int 中心線上方sell間格=20;
extern bool 中心線上方SellStop開關=true;
extern bool 中心線上方sell出場後再補單開關=true;
extern int 中心線上方sell幾點外才補單=5;

int h=TimeHour(TimeLocal()); // 定義目前電腦時間(小時)


double buy_lot= 中心線上方buy手數;
double sell_lot= 中心線下方sell手數;
double sell_lot_up_central_line= 中心線上方sell手數;
int up=Buy距中心線上方幾點;
int down=sell距中心線下方幾點;
int buy_ordernumber=中心線上方buy單數;
int sell_ordernumber=中心線下方sell單數;
int buy_interval=中心線上方buy間格;
int sell_interval=中心線下方sell間格;
int buystop_recall=中心線上方buy幾點外才補單;
int sellstop_recall=中心線下方sell幾點外才補單;
int sellstop_recall_UP=中心線上方sell幾點外才補單;
int i=0;
int j=0;
int y=0;
int t=0;
int k=0;
int p=0;
int s=0;
int buy_ticket;
int buy_ticket1[20];
int sell_ticket;
int sell_ticket1[20];
int sell_ticket_up_central_line[20];
int ticket1;
int a=1;
int b=1;
int c=1;
double buy_ticketprice[20];
double sell_ticketprice[20];
double ticketp[20];
double ticketk[10];

  void SetLevel(string LevelName,double Price,color DocColor)
  {
     ObjectCreate(LevelName, OBJ_HLINE, 0, 0, Price);//水平價位
     ObjectSet(LevelName, OBJPROP_STYLE, STYLE_SOLID);//水平線類型STYLE_DASHDOTDOT
     ObjectSet(LevelName, OBJPROP_COLOR, DocColor);//水平線顏色
  }

//主程式開始--------------------------

int start()
{
//if(OrdersTotal()==0 )
   {
   double buyprice=Bid;//定義買價
   double sellprice=Ask;//定義賣價
    
   SetLevel("CentalLine",Ask,clrYellow);//畫中心線
   
//第一模組 中心線上方Buy Stop------------------------------------------------------------
   
if (h>=輸入開始時間HH&& h<=輸入結束時間HH )
{
  
   if (中心線上方BuyStop開關==true && a==1)
   { 
   
    buy_ticket=OrderSend(NULL,OP_BUYSTOP,buy_lot,buyprice+(up*10*Point),NULL, NULL, NULL, NULL, 0, 0,Green);
    a--; //鋪第一張buy stop
    
      OrderSelect(buy_ticket, SELECT_BY_TICKET);
      buy_ticketprice[0]=OrderOpenPrice();
      
      for (i=1 ; i<buy_ordernumber ; i++ )
    {
      buy_ticket1[i]=OrderSend(NULL,OP_BUYSTOP,buy_lot,buy_ticketprice[i-1]+(buy_interval*10*Point),NULL, NULL, NULL, NULL, 0, 0,Green);
      OrderSelect(buy_ticket1[i], SELECT_BY_TICKET);
      buy_ticketprice[i]=OrderOpenPrice();
    }
    
//第二模組 中心線下方Sell Stop ------------------------------------------------------------
    
   if (中心線下方SellStop開關==true && b==1) 
   {
    sell_ticket=OrderSend(NULL,OP_SELLSTOP,sell_lot,sellprice-(down*10*Point),NULL, NULL, NULL, NULL, 0, 0,Red);
    b--; //鋪第一張sell stop
    
      OrderSelect(sell_ticket, SELECT_BY_TICKET);
      sell_ticketprice[0]=OrderOpenPrice();
      
      for (y=1 ; y<sell_ordernumber ; y++ )
    {
      sell_ticket1[y]=OrderSend(NULL,OP_SELLSTOP,sell_lot,sell_ticketprice[y-1]-(sell_interval*10*Point),NULL, NULL, NULL, NULL, 0, 0,Red);
      OrderSelect(sell_ticket1[y],SELECT_BY_TICKET);
      sell_ticketprice[y]=OrderOpenPrice();
    }     
   }
//第三模組 中心線上方Sell stop ------------------------------------------------------------
  
   if (中心線上方SellStop開關==true )
   {
    if ((Ask-sellprice-sellstop_recall_UP)>=0)
    {
     for (s=1 ; s<sellstop_recall_UP ; s++)
     {
      sell_ticket_up_central_line[s]=OrderSend(NULL,OP_SELLSTOP,sell_lot_up_central_line,Ask-(sellstop_recall_UP*10*Point),NULL, NULL, NULL, NULL, 0, 0,Red); 
     }
    }        
   }
  /* int check_point=1;
       check_point=1;
       
  if (中心線上方Buy出場後再補單開關==true )  
   {
    
   
   for(i=1 ;i<buy_ordernumber ; i++)
   {
   
    OrderSelect(i, SELECT_BY_POS ,MODE_TRADES);
    
     ticketp[i]=OrderOpenPrice();
     
      if(buy_ticketprice[i]!=ticketp[i]) 
      {
        //if ((buyprice-ticketprice[j])>buystop_recall*10*Point)
        //{
         OrderSend(NULL,OP_BUYSTOP,buy_lot,buy_ticketprice[i],NULL, NULL, NULL, NULL, 0, 0,Green);
         
                
//         for(t=1;t<buy_ordernumber;t++)
//         {
//         OrderSelect(ticket1, SELECT_BY_TICKET);      
//         ticketp[t]=OrderOpenPrice();
//         buy_ticketprice[t]=ticketp[t];
//         }
       }
   }
   }
   
   
  if (中心線下方sell出場後再補單開關==true)
  {
    
   k=sell_ordernumber+1;
   for(k ,j=1 ;k<(sell_ordernumber+buy_ordernumber); k++ && j++)
   {
   
    OrderSelect(k, SELECT_BY_POS ,MODE_TRADES);
    
     ticketk[k]=OrderOpenPrice();
     
      if(sell_ticketprice[j]!=ticketk[k]) 
      {
        //if ((buyprice-ticketprice[j])>buystop_recall*10*Point)
        //{
         OrderSend(NULL,OP_SELLSTOP,sell_lot,sell_ticketprice[j],NULL, NULL, NULL, NULL, 0, 0,Green);
         
                
         for(p=k , j=1;p<sell_ordernumber+buy_ordernumber;p++ && j++)
         {
         OrderSelect(p, SELECT_BY_POS, MODE_TRADES);      
         ticketk[p]=OrderOpenPrice();
         sell_ticketprice[j]=ticketk[p];
         }
       }
   }
   
   
   } 
   return(check_point);*/
   }
  
  }
  }
  }
  
  
  