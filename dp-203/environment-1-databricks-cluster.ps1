$azAdUserId = $env:AzAdUserId;
$azUsername = $env:AzUsername;
$azPassword = $env:AzPassword;
$databricksWorkspaceUri = $env:AzDatabricksWorkspaceUri

$azSecurePassword = $azPassword | ConvertTo-SecureString -AsPlainText -Force
$azCredential = new-object -typename System.Management.Automation.PSCredential -argumentlist $azUsername, $azSecurePassword
Connect-AzAccount -Credential $azCredential

$accesstoken = Get-AzAccessToken -ResourceUrl 2ff814a6-3304-4ab8-85cb-cd0e6f879c1d
$clusterDefinition = @{
  cluster_name="Test Cluster";
  spark_version="8.2.x-scala2.12";
  node_type_id="Standard_DS3_v2";
  autoscale=@{
    min_workers=2;
    max_workers=8;
  }
}

$clusterDefinitionJson = $clusterDefinition | ConvertTo-Json -Compress
$uri = "https://$($databricksWorkspaceUri)/api/2.0/clusters/create"
Invoke-RestMethod -Uri $uri -Method POST -Body $clusterDefinitionJson -Headers @{authorization="Bearer $($accesstoken.Token)"} -ContentType "application/json"

