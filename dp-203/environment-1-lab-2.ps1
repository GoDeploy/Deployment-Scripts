$azAdUserId = $env:AzAdUserId;
$azUsername = $env:AzUsername;
$azPassword = $env:AzPassword;
$azResourceGroupName = $env:AzResourceGroupName;

Install-Module -Force SqlServer
Import-Module -Force SqlServer

curl -sL https://aka.ms/InstallAzureCLIDeb | bash

if (Test-Path "./asa") {
    Get-Item "./asa" | Remove-Item -Force -Recurse
}

bash -c 'curl -L https://github.com/godeploy/microsoft-data-engineering-ilt-deploy/archive/godeploy.tar.gz | tar xzf -'
mv ./microsoft-data-engineering-ilt-deploy-godeploy/ asa
cd asa/setup/01/automation

az login -u $azUsername -p $azPassword

$azSecurePassword = $azPassword | ConvertTo-SecureString -AsPlainText -Force
$azCredential = new-object -typename System.Management.Automation.PSCredential -argumentlist $azUsername, $azSecurePassword
Connect-AzAccount -Credential $azCredential

Write-Host "--- Setting up environment in $azResourceGroupName"
./environment-setup.ps1 -resourceGroupName $azResourceGroupName

Write-Host "--- Setting up lab 2 in $azResourceGroupName"
./lab-02-setup.ps1 -resourceGroupName $azResourceGroupName

