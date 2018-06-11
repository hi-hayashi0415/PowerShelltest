# 全てのイベントログから1時間以内の「エラー」と「重大」を表示する（XML版）スクリプト


# 対象のイベントログに「エラー」と「重大」のイベントエントリがない場合の赤い実行エラーメッセージを表示させない
$ErrorActionPreference='SilentlyContinue'
# 全てのログ名を$LogNames変数に格納
$LogNames=Get-WinEvent -ListLog * | `
# イベントエントリ数が0、かつイベントログが有効でないものを排除
  Where-Object{($_.RecordCount -ne 0) -and ($_.IsEnabled -eq 1)} | `
# ログ名だけ代入
  ForEach-Object{$_.LogName}
# ForEachで$LogNames変数をループ処理
ForEach ( $LogName in $LogNames)
{
# イベントログのイベントエントリを表示
 Get-WinEvent -LogName $LogName -FilterXPath `
# フィルター用のXMLで「Level=1 or Level=2」の記述が「重大」と「エラー」を対象とする。
# 「3600000」の記述はミリ秒単位で1時間を指定
 "*[System[(Level=1 or Level=2) and TimeCreated[timediff(@SystemTime)<=3600000]]]"`
   | Format-Table LogName. LevelDisplayName, TimeCreated, `
                  Id, Message
}
# 赤い実行エラーメッセージを表示するように設定を戻す
$ErrorActionPreference='Continue'