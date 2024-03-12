//+------------------------------------------------------------------+
//|                                                LocalPatterns.mqh |
//|                                  Copyright 2023, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
//+------------------------------------------------------------------+
//| defines                                                          |
//+------------------------------------------------------------------+
// #define MacrosHello   "Hello, world!"
// #define MacrosYear    2010
//+------------------------------------------------------------------+
//| DLL imports                                                      |
//+------------------------------------------------------------------+
// #import "user32.dll"
//   int      SendMessageA(int hWnd,int Msg,int wParam,int lParam);
// #import "my_expert.dll"
//   int      ExpertRecalculate(int wParam,int lParam);
// #import
//+------------------------------------------------------------------+
//| EX5 imports                                                      |
//+------------------------------------------------------------------+
// #import "stdlib.ex5"
//   string ErrorDescription(int error_code);
// #import
//+------------------------------------------------------------------+

#include <Candelstick/Candelsticks.mqh>

bool pierceingLine(MqlRates &current, MqlRates &precedent, double sg){
/*
check a two successif candelstick verify piercing line pattern
Parameters:
   current: recent candelstick
   precedent : previous candelstick
   sg : the threshold of the previous candelstick
return:
   true if it is
   false otherwhise
*/
   bool pierce = false;
   double price = MathAbs(precedent.open-precedent.close)/2 + precedent.close;
   if(upOrdownCandlestick(precedent) == false && upOrdownCandlestick(current) &&closeOpen(precedent) > sg){
         if(current.close >= price)
            pierce = true;
       }
   return pierce;
}
bool darkCloudCover(MqlRates &current, MqlRates &precedent, double sg, double st,double sb){
 /*
check a two successif candelstick verify dark cloud cover pattern
Parameters:
   current: recent candelstick
   precedent : previous candelstick
   sg : the threshold of the previous candelstick
return:
   true if it is
   false otherwhise
*/
   bool cloud = false;
   
   double price = precedent.close - MathAbs(precedent.open-precedent.close)/2 ;
   if(upOrdownCandlestick(precedent) && marubuzo(precedent,st,sb,sg) && upOrdownCandlestick(current) == false){
         if(current.close < price)
             cloud = true;
         }
   return cloud;
}
int marubuzoDoji( MqlRates &rate1, MqlRates &rate2,MqlRates &rate3,MqlRates &rate4, double ssmall, double sbody){
   int marubuzoD = -1;
   if(closeOpen(rate4) > sbody){
      if(closeOpen(rate3) < ssmall){
        if(closeOpen(rate2) < ssmall){
            if(closeOpen(rate1) < ssmall){
               marubuzoD = 3;
               }}}
     }
    else{
       if(closeOpen(rate3) > sbody){
          if(closeOpen(rate2) < ssmall){
            if(closeOpen(rate1) < ssmall){
               marubuzoD = 2;
               }}
         }
         else{
            if(closeOpen(rate2) > sbody){
               if(closeOpen(rate1) < ssmall){
                  marubuzoD = 1; 
                  }}
         }
      }
      return marubuzoD;
}
int marubuzoDojiInverse( MqlRates &rate1, MqlRates &rate2,MqlRates &rate3,MqlRates &rate4, double ssmall, double sbody){
   int marubuzoDI = 0;
   if(closeOpen(rate1) > sbody){
      if(closeOpen(rate2) < ssmall){
            marubuzoDI = marubuzoDI + 1;
        if(closeOpen(rate3) < ssmall){
               marubuzoDI = marubuzoDI + 1;
            if(closeOpen(rate4) < ssmall){
               marubuzoDI = marubuzoDI + 1;
               }}}
     }
      return marubuzoDI;
}
int morningStart(MqlRates &rate0, MqlRates &rate1, MqlRates &rate2,MqlRates &rate3,MqlRates &rate4, double ssmall, double sbody){
   int moring = -1;
   int marubuzoD = marubuzoDoji(rate1,rate2, rate3, rate4, ssmall,sbody);
   if(closeOpen(rate0) > sbody && upOrdownCandlestick(rate0)){
      if(marubuzoD == 1 && upOrdownCandlestick(rate2) == false && rate0.close >= rate2.open)
         moring = 1;
      else{
         if(marubuzoD == 2 && upOrdownCandlestick(rate3) == false && rate0.close >= rate3.open)
                moring = 2;
        else{
            if(marubuzoD == 3 &&upOrdownCandlestick(rate4) == false && rate0.close >= rate4.open)
                  moring = 3;
             }
         }
   }
   return moring;
}
int eveningStart(MqlRates &rate0, MqlRates &rate1, MqlRates &rate2,MqlRates &rate3,MqlRates &rate4, double ssmall, double sbody){
   int evening = -1;
   int marubuzoD = marubuzoDoji(rate1,rate2, rate3, rate4, ssmall,sbody);
   if(closeOpen(rate0) > sbody && upOrdownCandlestick(rate0) == false){
      if(marubuzoD == 1 &&upOrdownCandlestick(rate2) && rate0.close <= rate2.open)
         evening = 1;
      else{
         if(marubuzoD == 2 && upOrdownCandlestick(rate3)&& rate0.close <= rate3.open)
            evening = 2;
         else{
            if(marubuzoD == 3 && upOrdownCandlestick(rate4) && rate0.close <= rate4.open)
                evening = 3;
            }
         }
      }
      return evening;
}

int haramiUD(MqlRates &rate0, MqlRates &rate1, double sbody, double ssmall){
      int harami = 0;
      if(closeOpen(rate1) > sbody && closeOpen(rate0) < ssmall){
         if(upOrdownCandlestick(rate1)){
            //if((rate1.close >= rate0.close || rate1.close >= rate0.open) && rate1.high >= rate0.high)
               harami = 1;
         }
         else{
            if(upOrdownCandlestick(rate1) == false){
               //if((rate1.close <= rate0.close || rate1.close <= rate0.open) && rate1.low <= rate0.low)
                  harami = -1;
            }
           }
       }
       return harami;
}

int engulfingUD(MqlRates &rate0, MqlRates &rate1, double sbody, double ssmall){
      int engulfing = 0;
      if(closeOpen(rate1) < ssmall && closeOpen(rate0) > sbody){
         if(upOrdownCandlestick(rate0)){
             engulfing = 1;
            /*
            if((rate0.open <= rate1.close || rate0.open <= rate1.open) && rate0.low <= rate1.low){
               
            }
             */  
         }
         else{
            if(upOrdownCandlestick(rate0) == false){
                engulfing = -1;
              /*
              if((rate0.open >= rate1.open || rate0.open >= rate1.close) && rate0.high >= rate1.high){
                 
               }
                */  
            }
           }
       }
       return engulfing;
}
bool findMarubozo(MqlRates &rate[], double sbo){
int size = ArraySize(rate);
bool find = false;
for(int i=0;i<size;i++){
   if(closeOpen(rate[i]) > sbo && upOrdownCandlestick(rate[i])){
      find = true;
      break;
     }
  }
  return find;
}
