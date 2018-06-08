# サービスの一覧を取得
$services = Get-Service
foreach($svc in $services)
{
  # サービスが一時停止でかつ現在実行中の場合
  if(($svc.CanPauseAndContinue) -AND ($svc.Status -eq "Running"))
  {
    # サービスを一時停止するかどうかを確認する
    Suspend-Service $svc.Name -Confirm
  }
}
