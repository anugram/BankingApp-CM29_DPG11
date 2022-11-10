###
#Undo Demo Script
###

Import-Module CipherTrustManager -Force

$DebugPreference = 'SilentlyContinue'
#$DebugPreference = 'Continue'

$username = "admin"
$password = "P4ssw0rd!"
$kms = "192.168.136.130"
$counter = "demo1"
$keyname = "dpgKey-$counter"

###Start with docker down etc
####

Write-Output "-----------------------------------------------------------------"
Write-Output "Next few steps will Deleting boilerplate config on your CM instance"
Write-Output "-----------------------------------------------------------------"

#Initialize and authenticate a connection with CipherTrust Manager
Write-Output "Connecting to CipherTrust Manager"
Connect-CipherTrustManager `
    -server $kms `
    -user $username `
    -pass $password
Write-Output "...Done"



###Deleting Users
Write-Output "Deleting Sample Users..."
#ccaccountowner, cccustomersupport, everyoneelse --- password is same for all...KeySecure01!
$userList = Get-CM_ListUsers `
    -email 'everyoneelse@local'
if ($userList.total -eq 1) {
    Get-CM_DeleteUser `
        -user_id $userList.resources[0].user_id
}

$userList = Get-CM_ListUsers `
    -email 'cccustomersupport@local'
if ($userList.total -eq 1) {
    Get-CM_DeleteUser `
        -user_id $userList.resources[0].user_id
}

$userList = Get-CM_ListUsers `
    -email 'ccaccountowner@local'
if ($userList.total -eq 1) {
    Get-CM_DeleteUser `
        -user_id $userList.resources[0].user_id
}
Write-Output "...Done"
###Done Deleting Users


###Deleting Application Profile
Write-Output "Deleting Client Profile..."
$appList = Get-CM_ListClientProfiles `
    -name "CC_profile-$counter"
if ($appList.total -eq 1) {
    Get-CM_DeleteClientProfile `
        -app_id $appList.resources[0].id
}
Write-Output "...Done"
###Done Deleting Application Profile


#Deleting DPG Policies (I think is automatic when app dies)
Write-Output "Deleting DPG Policy..."
$DPG_PolicyList = Get-CM_DPG_ListPolicies `
    -name "cc_policy-$counter"
if ($DPG_PolicyList.total -eq 1) {
    Get-CM_DPG_DeletePolicy `
        -policy_id $DPG_PolicyList.resources[0].id
}
Write-Output "...Done"
###Done Deleting DPG Policy

###Deleting Access Policies
Write-Output "Deleting Access Policy..."
$AccessPolicyList = Get-CM_ListAccessPolicies `
    -name "cc_access_policy-$counter"
if ($AccessPolicyList.total -eq 1) {
    Get-CM_DeleteAccessPolicy `
        -policy_id $AccessPolicyList.resources[0].id
}
Write-Output "...Done"
###Done Deleting Access Policies

#Deleting Masking Policy
Write-Output "Deleting Masking Formats"
$MaskingFormatList = Get-CM_ListMaskingFormats `
    -name "cc_masking_format-$counter"
if ($MaskingFormatList.total -eq 1) {
    Get-CM_DeleteMaskingFormat `
        -mask_id $MaskingFormatList.resources[0].id
}
Write-Output "...Done"
#Done Deleting Masking Policy

#Deleting User Sets
Write-Output "Deleting User Sets"
$userList = Get-CM_ListUserSets `
    -name "enctextuserset-$counter"
if ($userList.total -eq 1) {
    Get-CM_DeleteUserSet `
        -userset_id $userList.resources[0].id
}
$userList = Get-CM_ListUserSets `
    -name "maskedtextuserset-$counter"
if ($userList.total -eq 1) {
    Get-CM_DeleteUserSet `
        -userset_id $userList.resources[0].id
}
$userList = Get-CM_ListUserSets `
    -name "plainttextuserset-$counter"
if ($userList.total -eq 1) {
    Get-CM_DeleteUserSet `
        -userset_id $userList.resources[0].id
}
Write-Output "...Done"
#Done Deleting User Sets

#Deleting Protection Policies
Write-Output "Deleting Protection Policies"
Get-CM_DeleteProtectionPolicy `
    -policy_name "SSN_ProtectionPolicy-$counter"
Get-CM_DeleteProtectionPolicy `
    -policy_name "CC_ProtectionPolicy-$counter"
Get-CM_DeleteProtectionPolicy `
    -policy_name "cvv_ProtectionPolicy-$counter"
Write-Output "...Done"
#Done Deleting Protection Policies

#Deleting Character Set
Write-Output "Deleting Character Sets"
$charsetList = Get-CM_ListCharacterSets `
    -name "DPGAlphaNum-$counter"
if ($charsetList.total -eq 1) {
    Get-CM_DeleteCharacterSet `
        -charset_id $charsetList.resources[0].id
}
Write-Output "...Done"
#Done Deleting Character Set

#Deleting an NAE network interface
Write-Output "Deleting Interfaces"
$interfaceList = Get-CM_ListInterfaces `
    -name "nae_all_9005"
if ($interfaceList.total -eq 1) {
    #    Get-CM_DeleteInterface `
    #        -interface_id $interfaceList.resources[0].id
    #Looks like it wants NAME and not ID ... WHA???
    Get-CM_DeleteInterface `
        -interface_name "nae_all_9005"
}
Write-Output "...Done"
#Done Deleting an NAE network interface

#Deleting a key
Write-Output "Deleting Keys"
$keyList = Get-CM_ListKeys `
    -keyname $keyname
if ($keyList.total -eq 1) {
    Get-CM_DeleteKey `
        -key_id $keyList.resources[0].id
}
else {
    Write-Output "$($keyname) not found"
}
Write-Output "...Done"
#Done Deleting a key

Write-Output "-----------------------------------------------------------------"
Write-Output " Finished deleting boilerplate config on your CM instance"
Write-Output "-----------------------------------------------------------------"