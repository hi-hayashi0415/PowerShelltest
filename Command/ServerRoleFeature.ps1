#�����܂ł���̓v�����v�g�ŏ������̂ł���X�N���v�g�ł͂Ȃ��ł��B

# 1 ������@�\�̊Ǘ�
# 1.1 ������@�\�̊m�F
Get-WindowsFeature

# 1.2 Get-WindowsFeature�Œǉ��ς݂̖�����@�\�݂̂�\��
Get-WindowsFeature | `
    Where-Object {$_.InstallState -eq 'Installed'}

# 1.3 ���̃R���s���[�^�[�ɑ΂��ĊǗ��Җ��ƃp�X���[�h��ݒ�
Get-WindowsFeature -ComputerName SV01 `
   -Credential ( `
   New-Object System.Management.Automation.PSCredential( `
   'Samp\Administrator', `
   (ConvertTo-SecureString 'Pa$$w0rd' -AsPlainText -Force)))

# 2 �����Ƌ@�\�̒ǉ�
# 2.1 Install-WindowsFeature�ɂ��[�ؖ��@��]��[�ؖ��@��Web�o�^]�̒ǉ� 
Install-WindowsFeature ADCS-Cert-Authority, `
                       ADCS-Web-Enrollment `
       -IncludeAllSubFeature `
       -IncludeManagementTools

# 2.2 [�ؖ��@��]��[�ؖ��@��Web�o�^]�̏����ݒ�̎��s
# �ؖ��@�ւ̐ݒ�
Install-ADcsCertificationAuthority `
           -CAType EnterpriseRootCA `�@# �G���^�[�v���C�Y���[�gCA
           -CACommonName TEST-CA `     # CA�� TEST-CA
           -Force
# �ؖ��@��Web�o�^�̏����ݒ�
Install-AdcsWebEnrollment -Force

# 2.3 Install-WindowsFeature�ŃC���X�g�[�����f�B�A���w�肵�Ēǉ�
# DVD�h���C�u�Ƃ���O�h���C�u�A�\�t�g�E�F�A�R���|�[�l���g�̂���ꏊ�Ƃ���\test\samp�t�H���_�[���w��
Install-WindowsFeature NET-Framework-Core `
       -Source O:\test\samp

# 2.4 �l�b�g���[�N���ו��U�̒ǉ�
# 2.4.1 TEST001�R���s���[�^�[�Ƀl�b�g���[�N���ו��U��ǉ�
Install-WindowsFeature NLB `
       -ComputerName TEST001 `
       -IncludeAllSubFeature # �֘A�R���|�[�l���g���܂߂�

# 2.4.2 �����Ɉ�v���镡���̃R���s���[�^�[�Ƀl�b�g���[�N���ו��U��ǉ�
# �����́uTEST�v�Ŏn�܂�R���s���[�^�[
foreach( $CompName in `
         Get-ADComputer -Filter "Name -like 'TEST*'" | `
         ForEach-Object {$_.Name})
{
    Install-WindowsFeature NLB `
    -ComputerName $CompName -IncludeAllSubFeature
}

# 3 �����Ƌ@�\�̍폜
# 3.1 Uninstall-WindowsFeature�ɂ��[�ؖ��@��]��[�ؖ��@��Web�o�^�̍폜]
Uninstall-WindowsFeature ADCS-Web-Enrollment
Uninstall-WindowsFeature ADCS-Cert-Authority `
         -IncludeManagementTools
