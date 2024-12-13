@echo off
setlocal enabledelayedexpansion

:: Define the path variable
set "path=%UserProfile%\.cache\huggingface\hub"
set num=0

echo Assuming HuggingFaceHub directory is %path%...

:: Loop through all directories in the specified path
for /d %%D in ("%path%\*") do (
    :: Get the folder name
    set "folderName=%%~nxD"
    set "modifiedName=!folderName:~8!"
    echo:!modifiedName!

    if "!folderName:~8!" neq "" (
        set /a num += 1
    )
)

echo: & echo %num% models found. & echo:

endlocal
pause
