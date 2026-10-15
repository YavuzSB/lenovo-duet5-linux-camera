@echo off

REM ·························································
REM ·························································

>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if %ERRORLEVEL% EQU 0 (
	if exist "%temp%\getadmin.vbs" del /q "%temp%\getadmin.vbs"
) else (
	if NOT "%~1"=="" set file= ""%~1""
	(echo Set UAC = CreateObject("Shell.Application"^)
	@echo UAC.ShellExecute "cmd.exe", "/c %~s0%file%", "", "runas", 1)> "%temp%\getadmin.vbs"
	"%temp%\getadmin.vbs"
	exit /b 0
	if exist "%temp%\getadmin.vbs" del /q "%temp%\getadmin.vbs"
)
cd /d %~dp0
	
REM ·························································
REM ·························································

pnputil.exe /add-driver *.inf /install /subdirs
