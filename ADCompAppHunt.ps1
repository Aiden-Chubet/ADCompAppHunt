$Computers = Get-ADComputer -Filter * -SearchScope OneLevel -SearchBase "OU=Laptops,DC=Domain,DC=local"

# Initialize lists to store computer names
$Computers_With_Curl = @()
$Error_Computers = @()
$Computers_Without_Curl = @()

# Loop through each computer
ForEach ($Computer in $Computers) {
    # Construct the UNC path to the C drive on the remote computer
    $Path = "\\$($Computer.Name)\C$"

    Try {
        # Recursively check if curl.exe exists in the C drive
        If (Get-ChildItem -Path $Path -Recurse -Filter "curl.exe" -ErrorAction SilentlyContinue) {
            # Add the computer name to the list
            $Computers_With_Curl += $Computer.Name
        } else {
            # Add the computer name to the list of computers without curl.exe
            $Computers_Without_Curl += $Computer.Name
        }
    } Catch {
        # Handle any errors (e.g., access denied, computer offline)
        $Error_Computers += $Computer.Name
    }
}

# Print the lists
Write-Host "Computers with curl.exe:" $Computers_With_Curl
Write-Host "Computers without curl.exe:" $Computers_Without_Curl
Write-Host "Error accessing the following computers:" $Error_Computers
