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
cd asa/setup/04/artifacts/environment-setup/automation

az login -u $azUsername -p $azPassword

$azSecurePassword = $azPassword | ConvertTo-SecureString -AsPlainText -Force
$azCredential = new-object -typename System.Management.Automation.PSCredential -argumentlist $azUsername, $azSecurePassword
Connect-AzAccount -Credential $azCredential

Write-Host "--- Setting up environment in $azResourceGroupName"
./01-environment-setup.ps1 -gdResourceGroupName $azResourceGroupName

#$env:AzUsername = 'Test_StudentF0ZYA@gdcs0.com';$env:AzPassword = 'tA95$aK1?gA75BN';$env:AzAdUserId = '4e80059e-ca99-411c-a3b2-6a16a0833c87';