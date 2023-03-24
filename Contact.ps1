Import-Module ActiveDirectory
$vCardPath = "C:\Contact\mobile.vcf
#test to see if vcard file already exists
$outputvcard = Test-Path $vCardPath 
If (!$outputvcard){
 #if not then create the file
 $outputvcard = New-Item -Path $vCardPath -ItemType File -Force 
}
#get AD users
$ADUsers = Get-ADGroupMember -Identity "!EDIT_Select_group-attribute!" | Get-ADUser -Properties * | Where-Object {$_.Enabled -like “true”} | Select givenName,SN,Mail,Mobile,OfficePhone,extensionAttribute12,company,title,extensionAttribute11
ForEach ($user in $ADUsers){ 
 Add-Content -Path $vCardPath -Value "BEGIN:VCARD"
 Add-Content -Path $vCardPath -Value "VERSION:3.0"
 Add-Content -Path $vCardPath -Value "N;LANGUAGE=ru;CHARSET=windows-1251:$($user.SN);$($user.givenName)"
 Add-Content -Path $vCardPath -Value "FN;CHARSET=windows-1251:$($user.givenName) $($user.SN)"
 Add-Content -Path $vCardPath -Value "ORG;CHARSET=windows-1251:$($user.extensionAttribute11)"
 Add-Content -Path $vCardPath -Value "TEL;WORK;VOICE:$($user.Mobile)"
 Add-Content -Path $vCardPath -Value "BDAY:Format dd.MM.yyyy:$($user.extensionAttribute12)"
 Add-Content -Path $vCardPath -Value "TITLE;CHARSET=windows-1251:$($user.title)"
 Add-Content -Path $vCardPath -Value "TEL;HOME;VOICE:$($user.OfficePhone)"
 Add-Content -Path $vCardPath -Value "EMAIL;PREF;INTERNET:$($user.Mail)"
 Add-Content -Path $vCardPath -Value "END:VCARD"
}