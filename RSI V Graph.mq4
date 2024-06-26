#property strict // strictは絶対に削除しない事
#property indicator_separate_window // カスタムインジケータをサブウインドウに表示する

// インジケータプロパティ設定
#property  indicator_buffers     2               // カスタムインジケータのバッファ数
#property  indicator_color1      clrMidnightBlue       // インジケータ1の色
#property  indicator_color2      clrDarkOrchid         // インジケータ2の色
#property  indicator_type1       DRAW_HISTOGRAM     // インジケータ1の描画タイプ
#property  indicator_type2       DRAW_LINE     // インジケータ2の描画タイプ
#property  indicator_width1      3
#property  indicator_width2      1


// インジケータ表示用動的配列
double     _IndBuffer1[];                          // インジケータ1表示用動的配列
double     _IndBuffer2[];                          // インジケータ2表示用動的配列
//+------------------------------------------------------------------+
//| OnInit(初期化)イベント
//+------------------------------------------------------------------+
int OnInit()
{
   SetIndexBuffer( 0, _IndBuffer1 );     // インジケータ1表示用動的配列をインジケータ1にバインドする
   SetIndexBuffer( 1, _IndBuffer2 );     // インジケータ2表示用動的配列をインジケータ2にバインドする

   return( INIT_SUCCEEDED );      // 戻り値：初期化成功
}

//+------------------------------------------------------------------+
//| OnCalculate(tick受信)イベント
//| カスタムインジケータ専用のイベント関数
//+------------------------------------------------------------------+
int OnCalculate(const int     rates_total,      // 入力された時系列のバー数
                const int       prev_calculated,  // 計算済み(前回呼び出し時)のバー数
                const datetime &time[],          // 時間
                const double   &open[],          // 始値
                const double   &high[],          // 高値
                const double   &low[],           // 安値
                const double   &close[],         // 終値
                const long     &tick_volume[],   // Tick出来高
                const long     &volume[],        // Real出来高
                const int      &spread[])        // スプレッド
{
/*
    int end_index = Bars - prev_calculated;  // バー数取得(未計算分)
    double buf1 = 0;
    for( int icount = 0 ; icount < end_index ; icount++ ) {

        // テクニカルインジケータ算出
        double result = iRSI(
                               NULL,           // 通貨ペア
                               0,              // 時間軸
                               14,             // 平均期間
                               PRICE_CLOSE,  // 適用価格
                               icount // シフト
                              ); 



       _IndBuffer1[icount] = result;   // インジケータ1に算出結果を設定
       if (icount > 0){
          _IndBuffer2[icount] = (0 + result) * 1;
       } else {
          _IndBuffer2[icount] = (0 + result) * 1;
       }

    }
*/
   int i;
   int limit;
   if (prev_calculated == 0)              // 最初
      limit = rates_total - 1;               // 左端のローソク足から全部
   else                                   // それ以外
      limit = rates_total - prev_calculated; // ローソク足増加時「１」、通常「０」
   
   for (i = limit; i>=0; i--)               // limit本前から現在のローソク足を処理
   {
        // テクニカルインジケータ算出
        double result = iRSI(
                               NULL,           // 通貨ペア
                               0,              // 時間軸
                               7,             // 平均期間
                               PRICE_CLOSE,  // 適用価格
                               i // シフト
                              ); 

      if (i < limit){
         _IndBuffer1[i + 1] = result - _IndBuffer2[i + 1] * -1 - 50;
      }
      _IndBuffer2[i] = result;
   }
       
   return( rates_total ); // 戻り値設定：次回OnCalculate関数が呼ばれた時のprev_calculatedの値に渡される
}
