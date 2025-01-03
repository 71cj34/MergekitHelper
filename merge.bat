@echo off

set YAML_FILE=settings.yaml

for /f "tokens=2 delims== " %%a in ('yq e ".condaPath" %YAML_FILE%') do set CONDA_PATH=%%a
for /f "tokens=2 delims== " %%a in ('yq e ".mergekitConfigPath" %YAML_FILE%') do set CONFIG_PATH=%%a
for /f "tokens=2 delims== " %%a in ('yq e ".outputPath" %YAML_FILE%') do set OUTPUT_PATH=%%a
for /f "tokens=2 delims== " %%a in ('yq e ".llamacppBinPath" %YAML_FILE%') do set LLAMA_BINPATH=%%a
for /f "tokens=2 delims== " %%a in ('yq e ".llamacppPath" %YAML_FILE%') do set LLAMA_PATH=%%a
for /f "tokens=2 delims== " %%a in ('yq e ".useCUDA" %YAML_FILE%') do set CUDA=%%a

set /p SimpleMode=Do you want to run in Simple Mode (only create Q4_K_M)? (y/n): 

set /p Crime=Allow crimes? (y/n) 

set /p ModelName=Enter the name for your model: 

set /p ParamCount=Enter the Number of Expected Parameters (blank for auto): 

set /p PackageManager=Select package manager (conda, pip, poetry, or other): 

if "%Crime%"=="y" set "allowcrime=--allow-crimes"
if "%CUDA%"=="true" set "cuda=--cuda"

mergekit-yaml %CONFIG_PATH% %OUTPUT_PATH%\F16 %cuda% --write-model-card %allowcrime%

if "%ParamCount%"=="" (
   echo Activating %PackageManager%...
   if "%PackageManager%"=="conda" (
      call "%CONDA_PATH%\Scripts\activate.bat" "%CONDA_PATH%"
      echo Package manager CONDA detected.
      conda list | findstr /i "transformers"
    if %errorlevel% == 0 (
    echo Transformers package found.
    ) else (
    echo Transformers package not found! Make sure it is installed.
    pause
    )
   ) else if "%PackageManager%"=="pip" (
      echo Package manager PIP detected.
      :: pip doesn't need activation
      call pip list | findstr /i "transformers"
    if %errorlevel% == 0 (
    echo Transformers package found.
    ) else (
    echo Transformers package not found! Make sure it is installed.
    pause
    )
   ) else if "%PackageManager%"=="poetry" (
      echo Package manager POETRY detected.
      call poetry shell
      call poetry show | findstr /i "transformers"
    if %errorlevel% == 0 (
    echo Transformers package found.
    ) else (
    echo Transformers package not found! Make sure it is installed.
    pause
    )
   ) else (
      echo Unsupported package manager: %PackageManager%
      pause
      exit /b 1
   )

   python countparameters.py

   for /f "delims=" %%i in ('python countparameters.py') do set ParamCount=%%i

   if "%PackageManager%"=="conda" (
      call conda deactivate
   ) else if "%PackageManager%"=="poetry" (
      @REM may need to be poetry exit instead
      call exit 
   )
)

echo Estimated paramcount is: %ParamCount%
echo It is recommended to check if there are any errors in the console now before continuing.
pause

cd %LLAMA_PATH%

py %LLAMA_PATH%\convert_hf_to_gguf.py %OUTPUT_PATH%

for /R "%OUTPUT_PATH%" %%F in (*F16*) do (
    set "A=%%F"
    goto :found
)

:found

if not defined A (
    echo No file with "F16" in its name was found. Check your output path, %OUTPUT_PATH%, for an F16 file.
    echo Otherwise, check above for any errors from the conversion process.
    pause
    exit /b 1
)

if /I "%SimpleMode%"=="y" (
    %LLAMA_BINPATH%\llama-quantize.exe "%A%" %OUTPUT_PATH%\%ModelName%-%ParamCount%.Q4_K_M.gguf Q4_K_M
) else (
    %LLAMA_BINPATH%\llama-quantize.exe "%A%" %OUTPUT_PATH%\%ModelName%-%ParamCount%.Q2_K.gguf Q2_K
    %LLAMA_BINPATH%\llama-quantize.exe "%A%" %OUTPUT_PATH%\%ModelName%-%ParamCount%.Q3_K_S.gguf Q3_K_S
    %LLAMA_BINPATH%\llama-quantize.exe "%A%" %OUTPUT_PATH%\%ModelName%-%ParamCount%.Q3_K_M.gguf Q3_K_M
    %LLAMA_BINPATH%\llama-quantize.exe "%A%" %OUTPUT_PATH%\%ModelName%-%ParamCount%.Q3_K_L.gguf Q3_K_L
    %LLAMA_BINPATH%\llama-quantize.exe "%A%" %OUTPUT_PATH%\%ModelName%-%ParamCount%.Q4_K_S.gguf Q4_K_S
    %LLAMA_BINPATH%\llama-quantize.exe "%A%" %OUTPUT_PATH%\%ModelName%-%ParamCount%.Q4_K_M.gguf Q4_K_M
    %LLAMA_BINPATH%\llama-quantize.exe "%A%" %OUTPUT_PATH%\%ModelName%-%ParamCount%.Q5_K_S.gguf Q5_K_S
    %LLAMA_BINPATH%\llama-quantize.exe "%A%" %OUTPUT_PATH%\%ModelName%-%ParamCount%.Q5_K_M.gguf Q5_K_M
    %LLAMA_BINPATH%\llama-quantize.exe "%A%" %OUTPUT_PATH%\%ModelName%-%ParamCount%.Q6_K.gguf Q6_K
    %LLAMA_BINPATH%\llama-quantize.exe "%A%" %OUTPUT_PATH%\%ModelName%-%ParamCount%.Q8_0.gguf Q8_0
)

echo Script completed successfully. Quantized models available at %OUTPUT_PATH%.
pause