//+------------------------------------------------------------------+
//|                                          TimeSerieOperations.mqh |
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

void minIndex(double &array[], double &min, int &minindex, int start, int end){
   /*
      this function return the minimuim of an array with its index
      parameters:
         array the array where the minimuim will be find
         min the referencial variale where the minimuim will be stocked
         minindex a referencial variable where the index of the minimuim will be stocked
         start the start position of the array
         end the end position of the array
   */
   int size = ArraySize(array);
   min = array[start];
   minindex = start;
   for(int i=start+1;i<end;i++){
      if(min > array[i]) {
         min = array[i];
         minindex = i;
        }
     }
}


void maxIndex(double &array[], double &max, int &maxindex, int start, int end){
   /*
      this function return the maximuim of an array with its index
      parameters:
         array the array where the maximuim will be find
         max the referencial variale where the maximuim will be stocked
         maxindex a referencial variable where the index of the maximuim will be stocked
         start the start position of the array
         end the end position of the array
   */
   int size = ArraySize(array);
   max = array[start];
   maxindex = start;
   for(int i=start+1;i<end;i++){
      if(max < array[i]){
         max = array[i];
         maxindex = i;
        }
     }
}


bool minimumLocal(double &lows[], double &mimimum, int &minindex, int jump, int start, int end, int tolerance, bool perfect)
   {
      /*
         Find an extremuim(minimum) of the range of an array

         parameters:
            lows : the array
            minimum : it will contain the local minimuim it there is
            index : it will contain the index of the local minimuim
            start : the start index of the array
            end : the end index of the array
         return:
            true if thère is a local minimuim
            false otherwhise

      */
      bool find = false;
      minIndex(lows,mimimum,minindex,start,end);
      int difaf = end - minindex;
      int difbe = minindex - start, tolnumber = jump - tolerance;
      bool after = difaf > tolnumber && difaf < jump, befor =  difbe > tolnumber && difbe < jump;
      if(perfect){
         if(after&&befor)
            find = true;
        }
        else{
           if(after)
              find = true;
          }
      return find;
   }

   bool  maximumLocal(double &highs[], double &maximum, int &maxindex, int jump, int start, int end,int tolerance, bool perfect)
   {
      /*
         Find an extremuim(maximum) of the range of an array

         parameters:
            lows : the array
            minimum : it will contain the local maximuim it there is
            index : it will contain the index of the local maximuim
            start : the start index of the array
            end : the end index of the array
         return:
            true if thère is a local maximuim
            false otherwhise

      */
      bool find = false;
      maxIndex(highs,maximum,maxindex,start,end);
      int difaf = end - maxindex;
      int difbe = maxindex - start, tolnumber = jump - tolerance;
      bool after = difaf > tolnumber && difaf <jump , befor = difbe > tolnumber && difbe <jump;
      if(perfect){
         if(after&&befor)
            find = true;
        }
        else{
           if(after)
              find = true;
          }
      return find;
   }

   bool  findMinimuim(double &lows[], double &minimuim[], int &indexmini[], int first, int jump, int nmin, int tolerance)
   {
      /*
      this function return n local minimuim with thiere index
      parameters:
          lows : array where n local minimuim are caculated
          minimuim : array where all find minimuim are stocked
          indexmini : array of the index of the finded local minimuim
          first : the size of the first array
          jump : the jump use to find the local minimuim
          nmin : the numbers of the local minimum to be find
      returns:
          true if the n minimuim are find
          false otherwhise
      */
      double min = 0;
      bool find = NULL, findmin = false, perfect = false;
      int minindex = 0, start = 0, end = first, count = 0;
      for(int i = 0; i < nmin; i++) {
         if(i!=0)
            perfect = true;
         find = minimumLocal(lows, min, minindex, jump, start, end,tolerance,perfect);
         if(find) {
            minimuim[count] = min;
            indexmini[count] = minindex;
            count = count + 1;
         }
         start = end;
         end = start + 2 * jump - 1;
      }
      if(count == nmin)
         findmin = true;
      return findmin;
   }


   bool  findMaximuim(double &highs[], double &maximuim[], int &indexmaxi[], int first, int jump, int nmaxi, int tolerance){
      /*
      this function return n local maximuim with thiere index
      parameters:
          highs : array where n local maximuim are caculated
          maximuim : array where all find maximuim are stocked
          indexmaxi : array of the index of the finded local maximuim
          first : the size of the first array
          jump : the jump use to find the local maximuim
          nmaxi : the numbers of the local maximuim to be find
      returns:
          true if the n maximuim are find
          false otherwhise
      */
      double max = 0;
      bool find = NULL, findmaxi = false, perfect = false;
      int maxindex = 0, start = 0, end = first, count = 0;
      for(int i = 0; i < nmaxi; i++) {
         if(i!=0)
            perfect = true;
         find = maximumLocal(highs, max, maxindex, jump, start, end,tolerance, perfect);
         if(find){
            maximuim[count] = max;
            indexmaxi[count] = maxindex;
            count = count + 1;
         }
         start = end;
         end = start + 2 * jump - 1;
      }
      if(count == nmaxi)
         findmaxi = true;
      return findmaxi;
   }
   
bool nMA(int shift,int period, int n,  double &ma[]){
   int handelma = iMA(_Symbol,PERIOD_CURRENT, period, shift,MODE_EMA, PRICE_CLOSE);
   bool res_ = false;
   CopyBuffer(handelma, 0, 0, n, ma);
   ArraySetAsSeries(ma, true);
   if(handelma!=INVALID_HANDLE){
      res_ = true;
     }
   return res_;
}



bool nForceIndex(int period,int n, double &force_[]){
   int handelforce = iForce(Symbol(),PERIOD_CURRENT, period,MODE_EMA,VOLUME_TICK);
   bool res_ = false;
   CopyBuffer(handelforce, 0, 0, n, force_);
   ArraySetAsSeries(force_, true);
   if(handelforce!=INVALID_HANDLE){
      res_ = true;
     }
   return res_;
}

bool nSdev(int shift,int period,int n, double &stdev[]){
   int handelstdev = iStdDev(_Symbol,PERIOD_CURRENT, period, shift, MODE_SMMA,PRICE_CLOSE);
   bool res_ = false;
   CopyBuffer(handelstdev, 0, 0, n, stdev);
   ArraySetAsSeries(stdev, true);
   if(handelstdev!=INVALID_HANDLE){
      res_ = true;
     }
   return res_;
}

int crossDown(double &mamin[], double &mamax[], int count, int &indice[], int &ind){
int sel = 0;
ind = 0;
ArrayInitialize(indice, -1);
for(int i=1;i<count;i++)
  {
  if(mamin[i+1] > mamax[i+1] && mamin[i] < mamax[i])
    {
     sel = sel + 1;
     indice[ind] = i;
     ind = ind + 1;
    }
  }
  return sel;
}

int crossUp(double &mamin[], double &mamax[], int count, int &indice[], int &ind){
int buy = 0;
ind = 0;
ArrayInitialize(indice, -1);
for(int i=1;i<count;i++)
  {
  if(mamin[i+1] < mamax[i+1] && mamin[i] > mamax[i])
    {
     buy = buy +1;
     indice[ind] = i;
     ind = ind + 1;
    }
  }
  return buy;
}

double top(MqlRates &rate){
   double top = -1;
   if(upOrdownCandlestick(rate))
     {
      top = rate.close;
     }
     else
       {
            top = rate.open;
       }
   
    return top;
}