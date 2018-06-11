$LogNames=Get-WinEvent -ListLog * | `
  Where-Object{($_.RecordCount -ne 0) -and ($_.IsEnabled -eq 1)} | `
  ForEach-Object{$_.LogName}
  ForEach ( $LogName in $LogNames)
{
  Get-WinEvent -LogName $LogName | `
  # AddHours(-1)が過去1時間を指定
  Where-Object{($_.TimeCreated -ge (get-date).AddHours(-1)) -and `
  # 「重大」と「エラー」を指定
                (($_.Level -eq 1) -or ($_.Level -eq 2))} | `
  Format-Table LogName, LevelDisplayName, TimeCreated, Id, Message
}