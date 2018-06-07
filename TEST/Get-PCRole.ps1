#Win32_ComputerSystemオブジェクトを取得して変数に格納
$cs = Get-WmiObject -Class Win32_ComputerSystem

#コンピューターの役割を表すDomainRoleプロパティを変数に格納
$DomainRole = $cs.DomainRole

#DomainRoleプロパティの値に応じて処理を振り分ける
Switch -regex ($DomainRole)
{
  [0-1]{"このコンピューターは、ワークステーションです。"}
  [2-3]{"このコンピューターはサーバーですが、ドメインコントローラーではありません"}
  [4-5]{"このコンピューターは、ドメインコントローラーです。"}
  default{"不明な値です"}
}