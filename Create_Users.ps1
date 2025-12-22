$PasswordString = "password@1"
$Password = ConvertTo-SecureString $PasswordString -AsPlainText -Force

$DesktopPath = [Environment]::GetFolderPath("Desktop")
$FirstLast = Get-Content "$DesktopPath\names.txt"

# Create OU for NBA players
New-ADOrganizationalUnit -Name NBA_PLAYERS -ProtectedFromAccidentalDeletion $false

foreach ($n in $FirstLast) { 
    $First = $n.Split(" ")[0].ToLower()
    $Last  = $n.Split(" ")[1].ToLower()

    #Format last name to 5 characters
    $LastString = $Last
    if ($Last.Length -ge 5) {$LastString = $Last.Substring(0,5)}

    #Check for duplicate usernames
    $NameString = "$($First.Substring(0,1))$($LastString)".ToLower()
    $Username = $NameString
    $Counter = 1
    while (Get-ADUser -Filter "SamAccountName -eq '$Username'" -ErrorAction SilentlyContinue) {
        $Username = "$NameString$Counter"
        $Counter++
    }

    #Display and create user accounts 
    Write-Host "Creating user: $($Username)" -BackgroundColor Black -ForegroundColor Green

    New-AdUser -AccountPassword $Password `
            -GivenName $First `
            -Surname $Last `
            -DisplayName $Username `
            -Name $Username `
            -EmployeeID $Username `
            -PasswordNeverExpires $true `
            -Path "ou=NBA_PLAYERS,$(([ADSI]`"").distinguishedName)" `
            -Enabled $true
}