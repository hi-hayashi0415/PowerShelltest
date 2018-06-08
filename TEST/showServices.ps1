# 関数の定義
# 引数としてサービスを受け取り
# 停止状態のサービスは赤で表示する関数
# 呼び出す関数は先に定義しておく必要がある
function showStatus
{
  if($args[0].Status -eq "Running")
  {
   # サービス名を表示し、パディングする
   Write-Host ($args[0].ServiceName.PadRight(30) +
   $args[0].Status) -ForegroundColor Yellow
  }
  else
  {
   Write-Host ($args[0].ServiceName.PadRight(30) +
   $args[0].Status) -ForegroundColor Red
  }
  return
}

# スクリプトはここから開始
# サービスのリストを変数に格納
$services = Get-Service

# 各サービスの状態を表示
foreach($svc in $services)
{
  showStatus $svc
}




