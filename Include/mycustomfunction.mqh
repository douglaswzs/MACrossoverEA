//+------------------------------------------------------------------+
//|                                             mycustomfunction.mq4 |
//|                                                     douglas wong |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "douglas wong"
#property link      "https://github.com/douglaswzs"
#property version   "1.00"
#property strict
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
enum signalEnum
  {
   buy,
   sell
  };
  
double GetPipValue(){
    if (_Digits >= 4) {
        return 0.0001;
    }
    else {
        return 0.01;
    }

}

//
double CalculateTakeProfit(bool isLong, double entryPrice, int pips){
    double returnTakeProfit;
    if (isLong) {
        returnTakeProfit = entryPrice + (pips * GetPipValue());
    }
    else {
        returnTakeProfit = entryPrice - (pips * GetPipValue());
    }
    return returnTakeProfit;
}

double CalculateStopLoss(bool isLong, double entryPrice, int pips)
{
    double returnStopLoss;
    if (isLong) {
        returnStopLoss = entryPrice - (pips * GetPipValue());
    }
    else {
        returnStopLoss = entryPrice + (pips * GetPipValue());
    }
    return returnStopLoss;

}
 void setChartColorBackGround(color BackgroundColor)
 {
 ChartSetInteger(_Symbol,CHART_COLOR_BACKGROUND,BackgroundColor); 
 }



//remove
double GetStopLossPrice(bool bIsLongPosition, double entryPrice, int maxLossInPips)
{
    double returnStopLossPrice;
    double pipValue = 0.0001;
    if (bIsLongPosition) //if I am in long position
    {
        returnStopLossPrice = entryPrice - (maxLossInPips * pipValue);
    }
    else {
        returnStopLossPrice = entryPrice + (maxLossInPips * pipValue);
    }
    return returnStopLossPrice;
}

//remove
double pipGenerated(double entryPrice, double exitPrice){
    double pipValue = 0.0001;
    return MathRound((exitPrice - entryPrice) / pipValue);
}



void myAlert(string type, string message)
  {
  bool Send_Email = true;
bool Audible_Alerts = true;
bool Push_Notifications = true;


   int handle;
   if(type == "print")
      Print(message);
   else if(type == "error")
     {
      Print(type+" | test @ "+Symbol()+","+IntegerToString(Period())+" | "+message);
     }
   else if(type == "order")
     {
     }
   else if(type == "modify")
     {
     }
   else if(type == "indicator")
     {
      Print(type+" | test @ "+Symbol()+","+IntegerToString(Period())+" | "+message);
      if(Audible_Alerts) Alert(type+" | test @ "+Symbol()+","+IntegerToString(Period())+" | "+message);
      if(Send_Email) SendMail("test", type+" | test @ "+Symbol()+","+IntegerToString(Period())+" | "+message);
      handle = FileOpen("test.txt", FILE_TXT|FILE_READ|FILE_WRITE|FILE_SHARE_READ|FILE_SHARE_WRITE, ';');
      if(handle != INVALID_HANDLE)
        {
         FileSeek(handle, 0, SEEK_END);
         FileWrite(handle, type+" | test @ "+Symbol()+","+IntegerToString(Period())+" | "+message);
         FileClose(handle);
        }
      if(Push_Notifications) SendNotification(type+" | test @ "+Symbol()+","+IntegerToString(Period())+" | "+message);
     }
  }