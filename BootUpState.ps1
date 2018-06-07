# Win32_ComputerSystemオブジェクトを取得して変数に格納
$cs = Get-WmiObject -Class Win32_ComputerSystem

#起動状態を表すBootUpStateプロパティを変数に格納
$BootUpState = $cs.BootUpState

#BootUpStateプロパティにNormalという文字列が含まれているかどうかを判別し
#含まれている場合と含まれていない場合で処理を振り分ける
if($BootUpState -match "Normal")
{
  #コンピューターが通常の起動状態の場合に実行するコマンドを記述
}
else
{
  #コンピューターが通常の起動状態の場合に実行するコマンドを記述
}
