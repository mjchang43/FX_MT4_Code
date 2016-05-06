/*
*********************************************************************
          
                      Bollinger Squeeze v8
                  Original code by Nick Bilak
                   Modifications by Akuma99
                   Copyright ?2006-07  Akuma99
                  http://www.beginnertrader.com  

       For help on this indicator, tutorials and information 
               visit http://www.beginnertrader.com 
                  
*********************************************************************
*/

#property copyright "Copyright ?2006-07, Akuma99"
#property link      "http://www.beginnertrader.com "

#property indicator_separate_window
#property indicator_buffers 3
#property indicator_color1 Green //uptrend
#property indicator_width1 2  
#property indicator_color2 IndianRed  //downtrend
#property indicator_width2 2  
#property indicator_color3 DarkGreen // First Stochastic line
#property indicator_width3 2  


extern string note1 = "First Stochastic";
extern int    StochPeriod1=14;
extern int    DPeriod1=3;
extern int    SlowingPeriod1=3;

double upB[];
double loB[];
double Stoch1[];
//+------------------------------------------------------------------+
int init() {

   IndicatorBuffers(3);
   
   SetIndexStyle(0,DRAW_HISTOGRAM,STYLE_SOLID,indicator_width1,indicator_color1);
   SetIndexBuffer(0,upB);
   SetIndexEmptyValue(0,EMPTY_VALUE);
   
   SetIndexStyle(1,DRAW_HISTOGRAM,STYLE_SOLID,indicator_width2,indicator_color2); //downtrend
   SetIndexBuffer(1,loB);
   SetIndexEmptyValue(1,EMPTY_VALUE);

   SetIndexStyle(2,DRAW_LINE);
   SetIndexBuffer(2,Stoch1);
   return(0);
}
//+------------------------------------------------------------------+

int start() {

   int counted_bars=IndicatorCounted();
   int shift,limit;
   
   IndicatorShortName("Stoch Histogram ("+StochPeriod1+","+DPeriod1+","+SlowingPeriod1+")");
   if (counted_bars<0) return(-1);
   if (counted_bars>0) counted_bars--;
  
   limit=Bars-31;
   if(counted_bars>=31) limit=Bars-counted_bars-1;

   for (shift=limit;shift>=0;shift--)   {
      
      Stoch1[shift]=iStochastic(NULL,0,StochPeriod1,DPeriod1,SlowingPeriod1,MODE_SMA,0,MODE_MAIN,shift)-50;      
     
      if(Stoch1[shift]>0) {
         
         upB[shift]=Stoch1[shift];
         
      } else if (Stoch1[shift]<0){
      
         loB[shift]=Stoch1[shift];
         
      }
   }
   
   return(0);

}
//+------------------------------------------------------------------+

