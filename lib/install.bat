@echo off
setlocal

REM Set the directory where the .exe and .msi files are located
set "target_dir=.\lib\Temp"

REM Change to the target directory
pushd "%target_dir%"

REM Loop through all .exe files and run them, waiting for each to close before proceeding
for %%f in (*.exe) do (
    echo Running %%f...
    "%%f"
)

REM Loop through all .msi files and run them, waiting for each to close before proceeding
for %%f in (*.msi) do (
    echo Installing %%f...
    msiexec /i "%%f" /quiet /norestart
)

REM Return to the original directory
popd

echo All .exe and .msi files have been processed.
pause
endlocal