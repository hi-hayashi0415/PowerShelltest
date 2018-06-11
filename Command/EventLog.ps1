#あくまでこれはプロンプトで書くものでありスクリプトではないです。

# 1.システムログのイベントエントリの表示
Get-WinEvent -Logname System | `
Format-Table LevelDisplayName, TimeCreated, `
             id, TaskDisplayName, Message

# LevelDisPlay列は、イベントビューアー(GUI)の[レベル]列
# TimeCreated列は、イベントビューアーの[日付と時刻]列
# Id列は、イベントビューアーの[イベントID]列
# TaskDisplayName列は、イベントビューアーの[タスクのカテゴリ]列
# Message列は、イベントビューアー下段に表示されるメッセージ

# 2.セキュリティログのKeywordsDisplayNamesプロパティの表示
Get-WinEvent -LogName Security | `
    Format-Table KeywordsDisplayNames, TimeCreated, `
                 id, TaskDisplayName, Message

# KeywordsDisplayNames列は、イベントビューアー（GUI）の[キーワード]列です。

# 3.リモートコンピューターのシステムログの表示（仮想サーバーの方の資格情報に変更したところ上手くとることができた）
Get-WinEvent -LogName system `
# SV01.samp.localというリモートコンピューター
             -ComputerName SV01.samp.local `
             -Credential ( `
# 管理者名をSamp\Administratorとし
             New-Object System.Management.Automation.PSCredential ( `
                  'Samp\Administrator' , `
# パスワードはPa$$w0rdとして実行
# -AsPlainTextを使って平文化しないと暗号化されたパスワードを認識して上手くとることができない？（間違っていたらご指摘お願いします）
             (ConvertTo-SecureString 'Pa$$w0rd' -AsPlainText -Force))) | `
             Format-Table LevelDisplayName, TimeCreated, id, `
                          TaskDisplayName, Message


# 4.-FilterXmlでシステムログの[エラー]のイベントエントリのみを表示
Get-WinEvent -FilterXml `
"<QueryList>
  <Query Id='0' Path='System'>
   <Select Path='System'>*[System[(Level=2)]]</Select>
  </Query>
</QueryList>"


# 5.-FilterXPathでシステムログの[エラー]のイベントエントリのみを表示
Get-WinEvent -LogName System -FilterXPath `
# Level2がエラーを指定している
"*[System[(Level=2)]]"

# 6.1.New-EventLogによるイベントログの作成Get-WinEventによる確認
# 作成
New-EventLog -LogName SampLog -Source SampSource
# 確認
Get-WinEvent -ListLog Samp*

# 6.2.システムログのへのソースの登録
# 登録
New-EventLog -LogName System -Source TestSource
# 登録されているか確認
(Get-WinEvent -ListLog System).ProviderNames

# 6.3システムログからソース登録の解除
Remove-EventLog -Source TestSource
# 解除されているか確認
(Get-WinEvent -ListLog System).ProviderNames

# 6-4.作成したイベントログの削除
# 削除
Remove-EventLog -Logname SampLog

# 7.イベントエントリの書き込み
# 7.1.イベントエントリへの書き込み（SampLogへ）イベントビューアーで確認できる
Write-EventLog -LogName SampLog -Source SampSource `
     -EventId 9999 -EntryType Information -Category 100 `
     -Message "Samp Message"

# 7.2.既存のシステムログへのイベントエントリの書き込み
Write-EventLog -LogName System -Source EventLog -EventID 0 `
               -EntryType Warning -Message "Test Message" -Category 100

# 8.システムログのサイズや保持期間の設定（Limit-EventLogでは詳細ログは設定できない）
Limit-EventLog System -MaximumSize 30MB `
     -OverflowAction OverwriteOlder -Retention 7

# 9.システムログのイベントエントリを削除
Clear-EventLog System



