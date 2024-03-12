//+------------------------------------------------------------------+
//|                                                    Renversal.mqh |
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
#include </Candelstick/Patterns/LocalPatterns.mqh>
#include <TimeserieOperation/TimeSerieOperations.mqh>
#include </Candelstick/Patterns/LocalPatterns.mqh>

void cross(
      double &mamin[], // minimuim moving average array
      double &mamax[], // maximuim moving average array
      int &cross_up[], // array for up cross array
      int &cross_down[], // array of down cross
      int &count_up, // the number of up cross
      int &count_down, // the number of down cross
      int count // the size of moving average arrays
      ){
      
      int down = crossDown(mamin,mamax,count,cross_down, count_down); // fill down cross data
      int up = crossUp(mamin, mamax,count, cross_up, count_up); // fill up cross data
      }

int doubleTop(
      double &mamin[],
      double &mamax[],
      int &cross_up[],
      int &cross_down[],
      int &count_up,
      int &count_down,
      int count,
      double smin,
      double smax
      ){
      double array1[200], array2[200], array3[200];
      double min = 0, max1 = 0, max2 = 0;
      int res = -1;
      cross(mamin,mamax,cross_up,cross_down,count_up,count_down,count); // call the cross fonction
      
      if(count_down == 2 && count_up == 2)
        {
         if(cross_down[0] < cross_up[0] && cross_down[1] < cross_up[1])
           {
            Print("True");
            copyarrayfrom(mamin, array1, 0, cross_up[0]);
            copyarrayfrom(mamin, array2, cross_up[0], cross_down[1]);
            copyarrayfrom(mamin, array3, cross_down[1], cross_up[1]);
            min = ArrayMinimum(array2);
            max1 = ArrayMaximum(array1);
            max2 = ArrayMaximum(array3);
            
            if(min < max1 && min < max2 && mamax[cross_up[1]] > mamax[cross_up[1] + 30])
              {
               if(max1 < max2)
                 {
                  if(max2/max1 < smax && max1/min > smin)
                    {
                     res = 0;
                    }
                 }
                 else
                   {
                    if(max1/max2 < smax && max2/min > smin)
                    {
                     res = 0;
                    }
                   }
               
              }
           }
        }
      return res;
  }
  
 void copyarrayfrom(double &src[], double &des[], int start, int end){
 int j = 0;
 for(int i=start;i<end;i++)
   {
    des[j] = src[i];
    j = j+1;
   }
 }