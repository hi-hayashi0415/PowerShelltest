Function SayNumber()
{
  param($num, $flag) # $numと$flagパラメータを定義
  if ($flag)
  {
   [System.Console]::Beep() # ビープ音を鳴らす
   # $numの後に!記号を付け、黄色で表示
   Write-Host "$num !" -ForegroundColor Yellow
  }
  else
  {
   # それ以外の場合には、白で表示
   Write-Host "$num" -ForegroundColor White
  }
 }

#終了時に実行する関数を定義
Function Finish()
{
   Write-Host ""
   #終了時に「終了」という文字を緑で表示
   Write-Host "終了" -ForegroundColor Green
   Write-Host ""
}

#スクリプトはここから開始
Write-Host "3の倍数と3の付く数字の時は!で区別します。"
[Int32]$maxCount = Read-Host "いくつまで数えますか？"
#指定した値まで1づつ増加を定義
for($count=1; $count -le $maxCount + 1; $count++)
{
  if((($count % 3) -eq 0) -or ($count -match "3"))
  {
  # 3の倍数または3の付く数字
  SayNumber $count $TRUE
  }
  else
  {
  SayNumber $count $FALSE
  }
Start-Sleep 1 #1秒待ち
}

#終了メッセージの表示
Finish
