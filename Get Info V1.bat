@echo off
title EDECS

REM set variables
set manufacturer=
set model=
set serialnumber=
set totalMem=
set availableMem=
set ethrmac=
set wifimac=


echo HIIII ..%computername% 

REM Get Computer Manufacturer
FOR /F "tokens=2 delims='='" %%A in ('wmic ComputerSystem Get Manufacturer /value') do SET manufacturer=%%A

REM Get Computer Model
FOR /F "tokens=2 delims='='" %%A in ('wmic ComputerSystem Get Model /value') do SET model=%%A

REM Get Computer Serial Number
FOR /F "tokens=2 delims='='" %%A in ('wmic Bios Get SerialNumber /value') do SET serialnumber=%%A

REM Get Memory
FOR /F "tokens=4" %%a in ('systeminfo ^| findstr Physical') do if defined totalMem (set availableMem=%%a) else (set totalMem=%%a)
set totalMem=%totalMem:,=%
set availableMem=%availableMem:,=%
set /a usedMem=totalMem-availableMem

REM Get Memory
FOR /F "tokens=2 delims='='" %%A in ('wmic cpu get name /value') do SET core=%%A

REM Get Ethernet MacAddress but by powershell command
For /F "usebackq delims=" %%i in (`powershell -command "Get-NetAdapter -Name "*Ethernet*"| Select MacAddress"`) do SET ethrmac=%%i

REM Get Wi-Fi MacAddress but by powershell command
For /F "usebackq delims=" %%i in (`powershell -command "Get-NetAdapter -Name "*Wi-Fi*"| Select MacAddress"`) do SET wifimac=%%i

REM Lets List the data
REM For powershell Command we dont create variable wa just add command Her 

echo --------------------------------------------
echo Manufacturer: %manufacturer%
echo Model: %model%
echo Serial Number: %serialnumber%
echo Processor : %core%
echo Total Memory: %totalMem%
echo Used  Memory: %usedMem%                          
echo Ethernet MacAddress: %ethrmac%
echo Wi-Fi MacAddress: %wifimac%
echo:
echo                  ############################
powershell -command "Get-NetAdapter -Name "*Ethernet*","*Wi-Fi*"| Select Name,MacAddress"
echo:
REM set variable and ask user  for HR ID and print it
set /p hrid="Enter Employee ID (HR ID) :  "
echo:
REM set variable and ask user  for Device Code and print it
set /p dcode="Enter Device Code  :  "
echo --------------------------------------------

REM Generate the txt file
REM For powershell Command we dont create variable wa just add command Her 
REM %~dp0%variable-name%
SET file="%~dp0%dcode%.txt"
echo -------------------------------------------- >> %file%
echo Details For: %computername% >> %file%
echo Manufacturer: %manufacturer% >> %file%
echo Model: %model% >> %file%
echo Serial Number: %serialnumber% >> %file%
echo Processor : %core% >> %file%
echo Total Memory: %totalMem% >> %file%
echo Used  Memory: %usedMem% >> %file%
echo Ethernet MacAddress: %ethrmac% >> %file%
echo Wi-Fi MacAddress: %wifimac% >> %file%
echo: >> %file%
echo Employee ID (HR ID) : %hrid% >> %file%
echo Device Code : %dcode% >> %file%
echo -------------------------------------------- >> %file%
start notepad %file%
goto END

:NOCON
echo Error...Invalid Operating System...
echo Error...No actions were made...
goto END

:END 


REM request user to push any key to continue
Pause