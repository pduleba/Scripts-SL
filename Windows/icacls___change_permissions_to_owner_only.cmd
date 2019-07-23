:: Set Variable ::
set key="C:\path\to\file"

:: Remove Inheritance ::
cmd /c icacls %key% /c /t /inheritance:d

:: Set Ownership to Owner ::
cmd /c icacls %key% /c /t /grant %username%:F

:: Remove All Users, except for Owner ::
cmd /c icacls %key%  /c /t /remove Administrator BUILTIN\Administrators BUILTIN Everyone System Users

:: Verify ::
cmd /c icacls %key%