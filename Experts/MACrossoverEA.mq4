//+------------------------------------------------------------------+
//|                                                MACrossoverEA.mq4 |
//|                                                     douglas wong |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "douglas wong"
#property link      "https://github.com/douglaswzs"
#property version   "1.00"
#property strict
#include <mycustomfunction.mqh>
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
input int STOP_LOSS_PIPS = 20;
input int TAKE_PROFIT_PIPS = 40;
input double LOT_SIZE = 0.1;
input int MA_SLOW_PERIOD = 12;
input int MA_FAST_PERIOD = 6;
input bool ENABLE_SMA200 = true;

//+------------------------------------------------------------------+
//| Global Variables                                  |
//+------------------------------------------------------------------+   
double stopLossPrice;
double takeProfitPrice;
string signalBuySell;

int OnInit()
{
    //---

    //---
    return (INIT_SUCCEEDED);
}
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
    {
        //---

    }
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
{

}
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
{
    //---

    RunProgram();
}
//+------------------------------------------------------------------+


void RunProgram()
{
    CheckDecision();
    processOrder();
}

void processOrder()
{
    bool processResult;
    double entryPrice;
    if (signalBuySell == "buy" && OrdersTotal() == 0) {
        entryPrice = Ask;
        stopLossPrice = CalculateStopLoss(true, entryPrice, STOP_LOSS_PIPS);
        takeProfitPrice = CalculateTakeProfit(true, entryPrice, TAKE_PROFIT_PIPS);

        processResult = OrderSend(_Symbol, OP_BUY, LOT_SIZE, entryPrice, 3, stopLossPrice, takeProfitPrice, "buy comments", 0, 0, Green);
        OutputProcessResult(processResult, entryPrice);
    }
    if (signalBuySell == "sell" && OrdersTotal() == 0) {
        entryPrice = Bid;
        stopLossPrice = CalculateStopLoss(false, entryPrice, STOP_LOSS_PIPS);
        takeProfitPrice = CalculateTakeProfit(false, entryPrice, TAKE_PROFIT_PIPS);

        processResult = OrderSend(_Symbol, OP_SELL, LOT_SIZE, entryPrice, 3, stopLossPrice, takeProfitPrice, "sell comments", 0, 0, Red);
        OutputProcessResult(processResult, entryPrice);
    }
}

void OutputProcessResult(bool processResult, double entryPrice)
{
    if (processResult) {
        Comment("The current signal is:", signalBuySell);
        if (signalBuySell == "buy") {
            //setChartColorBackGround(clrGreen);
            Alert("Price is above signalPrice, Sending buy order");
        };
        if (signalBuySell == "sell") {
            //setChartColorBackGround(clrRed);
            Alert("Price is above signalPrice, Sending short order");
        };
        Alert("Entry Price =" + DoubleToStr(entryPrice, 5));
        Alert("Stop Loss price =" + DoubleToStr(stopLossPrice, 5));
        Alert("Take profit price =" + DoubleToStr(takeProfitPrice, 5));
    }
    else {
        Alert(signalBuySell + " Failed");
    }
}

//Technical analysis of the indicators
void CheckDecision(){
    signalBuySell = "";
    CheckMACross();
    checkSMA200();
}

void CheckMACross(){
    double MASlowCurr = iMA(Symbol(), 0, MA_SLOW_PERIOD, 0, MODE_SMA, PRICE_CLOSE, 1);
    double MASlowPrev = iMA(Symbol(), 0, MA_SLOW_PERIOD, 0, MODE_SMA, PRICE_CLOSE, 2);
    double MAFastCurr = iMA(Symbol(), 0, MA_FAST_PERIOD, 0, MODE_SMA, PRICE_CLOSE, 1);
    double MAFastPrev = iMA(Symbol(), 0, MA_FAST_PERIOD, 0, MODE_SMA, PRICE_CLOSE, 2);
    
    if (MASlowPrev > MAFastPrev && MAFastCurr > MASlowCurr) {
        signalBuySell = "buy";
    }
    if (MASlowPrev < MAFastPrev && MAFastCurr < MASlowCurr) {
        signalBuySell = "sell";
    }
}

void checkSMA200(){
    if (ENABLE_SMA200){
       double SMA200 = iMA(Symbol(), 0, 200, 0, MODE_SMA, PRICE_CLOSE, 1);
       double SMA50 = iMA(Symbol(), 0, 50, 0, MODE_SMA, PRICE_CLOSE, 1);
       
       if (signalBuySell == "buy"){
         signalBuySell = (Ask > SMA200) ? "buy" : "";
       }
       if (signalBuySell == "sell"){
         signalBuySell = (Bid < SMA200) ? "sell" : "";
       }
    }
}