# 全てのイベントログからイベントエントリを削除するスクリプト

$LogNames=Get-WinEvent -ListLog * | `
  Where-Object{ ($_.RecordCount -ne 0) -and ($_.IsEnabled -eq 1)} | `
  ForEach-Object{$_.LogName}
  ForEach( $LogName in $LogNames)
  {
# WevtUtilでイベントログを削除する。
    WevtUtil Clear-Log $LogName
# 削除した旨を表示
    Write-host $LogName "ログからイベントエントリを削除しました"
　}
# システムログには9行目でイベントエントリを削除した旨が新たなイベントエントリとして書き込まれるためそれを削除
WevtUtil Clear-Log System

