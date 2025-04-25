@setlocal
@echo off

set PASSWORD=%~1

IF /I NOT "%PASSWORD%" == "" goto :ValidPassword
  REM === Display usage message
  echo Usage: %~nx0 ^<password^>
  exit /B 1

:ValidPassword

REM === Add the user with the specified password
call net user ansible "%PASSWORD%" /add /expires:never /Y

REM === Add the ansible user to the Administrators group
call net localgroup Administrators ansible /add

endlocal