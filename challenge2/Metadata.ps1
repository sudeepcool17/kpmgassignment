Enter-PSSession -ComputerName DemoVM.cloudapp.net -Credential login
#Invoke the Rest method to get information about metadata
$resp=Invoke-RestMethod -Headers @{"Metadata"="true"} -Method GET -Proxy $Null -Uri "http://169.254.169.254/metadata/instance?api-version=2021-01-01"

#Convert variable to Jason format and store it in another variable
$respJSON = $resp | ConvertTo-Json -Depth 6
#Print output in Jason format
Write-Output $respJSON 


#Write selective arguments of the output to a file 
Write-Output "VM name - $($resp.compute.name), RG - $($resp.compute.resourceGroupName), VM size - $($resp.compute.vmSize)" | Out-File -FilePath C:\Temp\Metadata.txt 
