@ECHO OFF
SETLOCAL
SET "PowerShellCoreInstalled="
SET "PowerShellInstalled="

REM Check if PowerShell Core is installed
WHERE pwsh >nul 2>nul
IF %ERRORLEVEL% EQU 0 (
	SET "PowerShellCoreInstalled=Y"
)

REM Check if PowerShell is installed
WHERE PowerShell >nul 2>nul
IF %ERRORLEVEL% EQU 0 (
	SET "PowerShellInstalled=Y"
)

REM If PowerShell Core installed, use that
IF DEFINED PowerShellCoreInstalled (
	ECHO PowerShell Core is installed - using this to execute script.
	pwsh -NoProfile -ExecutionPolicy Bypass -Command "& './Deploy-All.ps1'"
	PAUSE
	GOTO:EOF
)

REM Check if PowerShell is installed
IF NOT DEFINED PowerShellInstalled GOTO PowerShellNotInstalled

ECHO PowerShell is installed. Checking what version is installed.

REM Get the version of PowerShell installed - this doesn't include PowerShell Core
FOR /f %%i IN ('PowerShell -command "[int]([System.String]::Concat((Get-Variable PSVersionTable -ValueOnly).PSVersion.Major, (Get-Variable PSVersionTable -ValueOnly).PSVersion.Minor))"') DO SET PowerShellVersion=%%i

FOR /f %%i IN ('PowerShell -command "[System.String]::Concat((Get-Variable PSVersionTable -ValueOnly).PSVersion.Major, '.', (Get-Variable PSVersionTable -ValueOnly).PSVersion.Minor)"') DO SET PowerShellVersionText=%%i

REM Check the version of PowerShell installed
IF %PowerShellVersion% LEQ 62 GOTO PowerShellOldVersion

REM Use PowerShell to execute script
ECHO PowerShell v6.2+ is installed - using this to execute script.
PowerShell -NoProfile -ExecutionPolicy Bypass -Command "& './Deploy-All.ps1'"
PAUSE
GOTO:EOF

:PowerShellNotInstalled
ECHO Neither PowerShell nor PowerShell Core is installed on this system.
ECHO In order to run this script, you need either PowerShell v6.2+ or PowerShell Core (v7.x+).
PAUSE
GOTO:EOF

:PowerShellOldVersion
ECHO An older version of PowerShell is installed.
ECHO In order to run this script, you need at least PowerShell v6.2+.
ECHO You currently have v%PowerShellVersionText% installed.
PAUSE
GOTO:EOF

