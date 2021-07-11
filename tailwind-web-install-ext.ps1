
Param (
    [string]$SqlConnectionString,
    [string]$MongoConnectionString,
    [string]$ProductImagesUrl
)


# Open firewall
netsh advfirewall firewall add rule name="http" dir=in action=allow protocol=TCP localport=80

# Install IIS
Install-WindowsFeature web-server -IncludeManagementTools

New-Item -ItemType Directory c:\temp

# Download and Install Visual C++ redistributables
Invoke-WebRequest https://github.com/sameeraman/tailwindappvm/blob/main/installs/VC_redist.x64.exe?raw=true -outfile c:\temp\vc_redistx64.exe
Start-Process c:\temp\vc_redistx64.exe -ArgumentList '/quiet' -Wait

# Download and install the dotnet core 2.1 hosting
Invoke-WebRequest https://github.com/sameeraman/tailwindappvm/blob/main/installs/dotnet-hosting-2.1.28-win.exe?raw=true -outfile c:\temp\dotnet-hosting-2.1.28-win.exe
Start-Process c:\temp\dotnet-hosting-2.1.28-win.exe -ArgumentList '/quiet' -Wait


# Download and extract the application code
Invoke-WebRequest  https://github.com/sameeraman/tailwindappvm/blob/main/installs/TailwindWeb-Compiled.zip?raw=true -OutFile c:\temp\TailwindWeb-Compiled.zip
Remove-Item -Path C:\inetpub\wwwroot -Recurse
Expand-Archive C:\temp\TailwindWeb-Compiled.zip C:\inetpub\wwwroot



# Set Environment variables on the Local Machine
[Environment]::SetEnvironmentVariable("apiUrl", "/api/v1",[EnvironmentVariableTarget]::Machine)
[Environment]::SetEnvironmentVariable("ApiUrlShoppingCart", "/api/v1",[EnvironmentVariableTarget]::Machine)
[Environment]::SetEnvironmentVariable("SqlConnectionString", $SqlConnectionString ,[EnvironmentVariableTarget]::Machine)
[Environment]::SetEnvironmentVariable("MongoConnectionString", $MongoConnectionString ,[EnvironmentVariableTarget]::Machine)
[Environment]::SetEnvironmentVariable("ProductImagesUrl", $ProductImagesUrl ,[EnvironmentVariableTarget]::Machine)

iisreset








