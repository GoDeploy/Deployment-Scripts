$azAdUserId = $env:AzAdUserId;
$azUsername = $env:AzUsername;
$azPassword = $env:AzPassword;
$azResourceGroupName = $env:AzResourceGroupName;

apt-get update
apt-get -y install git
curl -sL https://aka.ms/InstallAzureCLIDeb | bash

git clone https://github.com/godeploy/microsoft-data-engineering-ilt-deploy.git asa
cd asa
git checkout godeploy
cd setup/01/automation

az login -u $azUsername -p $azPassword

$azSecurePassword = $azPassword | ConvertTo-SecureString -AsPlainText -Force
$azCredential = new-object -typename System.Management.Automation.PSCredential -argumentlist $azUsername, $azSecurePassword
Connect-AzAccount -Credential $azCredential

./environment-setup.ps1 -resourceGroupName $azResourceGroupName

./lab-02-setup.ps1 -resourceGroupName $azResourceGroupName

