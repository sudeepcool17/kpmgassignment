Challenge 2
======== 
Problem Statement: We need to write code that will query the meta data of an instance within AWS and provide a json formatted output. The choice of language and implementation is up to you. Bonus Points The code allows for a particular data key to be retrieved individually Hints · 
Aws Documentation (https://docs.aws.amazon.com/) ·
Azure Documentation (https://docs.microsoft.com/en-us/azure/?product=featured) ·
Google Documentation (https://cloud.google.com/docs)

Solution: 
1. Login to the Pssession by logging into your azure account
2. Create the below script on admin powershell ISE 
3. Run it on the desired VM you want the data from Metadata.ps1

https://user-images.githubusercontent.com/68887254/138212743-fdfb28b7-a963-4e34-8aef-d4c60ee15372.png

#Linux :Use the following comand in script for Linux workloads
curl -H Metadata:true --noproxy "*" "http://169.254.169.254/metadata/instance?api-version=2020-09-01" | jq
 


