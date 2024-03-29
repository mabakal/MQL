

bool upOrdownCandlestick(MqlRates &rate){
/*
Passer un chandelier en paramètre, cette fonction retour son type:
true si le chandelier est montant
false si le chandelier est descendant
et null si le si l'ouverture et la fermeture sont egaux
*/
   bool up = NULL;
      if(rate.close > rate.open)
         up= true;
        else
           if(rate.close < rate.open)
               up = false;
      return up;
}
double hammerBottom(MqlRates &rate){
/*
Passer un chandelier en parmètre, cette fonction renvoie un nombre decémal
correspondant au rapport entre le corps du chandelier et la mèche inférieur
*/
   double mecheInf = 0, body =MathAbs(rate.close - rate.open);
   double bmi = 7;
   if(rate.open!=rate.low && rate.close!=rate.low){
      if(upOrdownCandlestick(rate))
      mecheInf = rate.open - rate.low;
       else
           if(upOrdownCandlestick(rate) == false)
               mecheInf = rate.close - rate.low;
      bmi = body/mecheInf;
     }
    return bmi;
}
double hammerTop(MqlRates &rate){
/*
Passer un chandelier en parmètre, cette fonction renvoie un nombre decémal
correspondant au rapport entre le corps du chandelier et la mèche supérieur
*/
   double mecheSup = 0, body =MathAbs(rate.close - rate.open);
   double bms = 7;
   if(rate.open!=rate.high && rate.close!=rate.high)
     {
      if(upOrdownCandlestick(rate))
      mecheSup = rate.high - rate.close;
     else
        if(upOrdownCandlestick(rate) == false)
           mecheSup = rate.high - rate.open;
      bms = body/mecheSup ;
     }
   return bms;
}
double closeOpen(MqlRates &rate){
/*
Passer un chandelier en paramètre, cette fonction renvoie le rapport entre 
la fermeture et l'ouverture, si l'ouverture et la fermeture sont identique
la fonction retourne 1, et plus ce nombre s'éloigne de 1 le corps est grand'
*/
   double opcl = 1;
   if(upOrdownCandlestick(rate))
     opcl = rate.close/rate.open;
    else
       if(upOrdownCandlestick(rate) == false)
         opcl = rate.open/rate.close;
    return opcl;
}
 bool marubuzo(MqlRates &rate, double stop, double sbottom, double opcl){
 /*
 check if a candelstick is a marubuzo or not
 Parameters:
   rate: le chandelier en question
   s top: the threshold beteween the body and the top wick
   s bottom: the threshold beteween the body and the bottom wick
   opcl : the threshold beteween the open and close price
 return:
   true if it is
   false otherwise
 */
  bool marubuzu = false;
  if(hammerBottom(rate) > sbottom  && hammerTop(rate) > stop && closeOpen(rate) > opcl)
     marubuzu = true;
  return marubuzu;
}
double body(MqlRates &rate){
   return MathAbs(rate.open - rate.close);
}
bool start(MqlRates &rate, double stop,double  sbottom, double ssmall){
   bool start = false;
   if((hammerBottom(rate) < sbottom && hammerTop(rate) < stop) || closeOpen(rate) < ssmall)
       start = true;
   return start;
}

double highLow(MqlRates &rate){
/*
Passer un chandelier en paramètre, cette fonction renvoie le rapport entre 
la fermeture et l'ouverture, si l'ouverture et la fermeture sont identique
la fonction retourne 1, et plus ce nombre s'éloigne de 1 le corps est grand'
*/
   
    return rate.high/rate.low;
}