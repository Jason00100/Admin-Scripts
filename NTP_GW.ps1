$DefaultGateway = (Get-wmiObject Win32_networkAdapterConfiguration | ?{$_.IPEnabled}).DefaultIPGateway
w32tm /config /manualpeerlist:"$DefaultGateway,0x8" /update
w32tm /config /syncfromflags:manual /update
W32tm /resync
