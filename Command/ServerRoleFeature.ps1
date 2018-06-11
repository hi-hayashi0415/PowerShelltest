#あくまでこれはプロンプトで書くものでありスクリプトではないです。

# 1 役割や機能の管理
# 1.1 役割や機能の確認
Get-WindowsFeature

# 1.2 Get-WindowsFeatureで追加済みの役割や機能のみを表示
Get-WindowsFeature | `
    Where-Object {$_.InstallState -eq 'Installed'}

# 1.3 他のコンピューターに対して管理者名とパスワードを設定
Get-WindowsFeature -ComputerName SV01 `
   -Credential ( `
   New-Object System.Management.Automation.PSCredential( `
   'Samp\Administrator', `
   (ConvertTo-SecureString 'Pa$$w0rd' -AsPlainText -Force)))

# 2 役割と機能の追加
# 2.1 Install-WindowsFeatureによる[証明機関]と[証明機関Web登録]の追加 
Install-WindowsFeature ADCS-Cert-Authority, `
                       ADCS-Web-Enrollment `
       -IncludeAllSubFeature `
       -IncludeManagementTools

# 2.2 [証明機関]と[証明機関Web登録]の初期設定の実行
# 証明機関の設定
Install-ADcsCertificationAuthority `
           -CAType EnterpriseRootCA `　# エンタープライズルートCA
           -CACommonName TEST-CA `     # CA名 TEST-CA
           -Force
# 証明機関Web登録の初期設定
Install-AdcsWebEnrollment -Force

# 2.3 Install-WindowsFeatureでインストールメディアを指定して追加
# DVDドライブとしてOドライブ、ソフトウェアコンポーネントのある場所として\test\sampフォルダーを指定
Install-WindowsFeature NET-Framework-Core `
       -Source O:\test\samp

# 2.4 ネットワーク負荷分散の追加
# 2.4.1 TEST001コンピューターにネットワーク負荷分散を追加
Install-WindowsFeature NLB `
       -ComputerName TEST001 `
       -IncludeAllSubFeature # 関連コンポーネントを含める

# 2.4.2 条件に一致する複数のコンピューターにネットワーク負荷分散を追加
# 条件は「TEST」で始まるコンピューター
foreach( $CompName in `
         Get-ADComputer -Filter "Name -like 'TEST*'" | `
         ForEach-Object {$_.Name})
{
    Install-WindowsFeature NLB `
    -ComputerName $CompName -IncludeAllSubFeature
}

# 3 役割と機能の削除
# 3.1 Uninstall-WindowsFeatureによる[証明機関]と[証明機関Web登録の削除]
Uninstall-WindowsFeature ADCS-Web-Enrollment
Uninstall-WindowsFeature ADCS-Cert-Authority `
         -IncludeManagementTools
