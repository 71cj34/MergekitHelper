@echo off

set YAML_FILE=settings.yaml

for /f "tokens=2 delims== " %%a in ('yq e ".condaPath" %YAML_FILE%') do set CONDA_PATH=%%a
for /f "tokens=2 delims== " %%a in ('yq e ".mergekitConfigPath" %YAML_FILE%') do set CONFIG_PATH=%%a
for /f "tokens=2 delims== " %%a in ('yq e ".outputPath" %YAML_FILE%') do set OUTPUT_PATH=%%a
for /f "tokens=2 delims== " %%a in ('yq e ".llamacppBinPath" %YAML_FILE%') do set LLAMA_BINPATH=%%a
for /f "tokens=2 delims== " %%a in ('yq e ".llamacppPath" %YAML_FILE%') do set LLAMA_PATH=%%a
for /f "tokens=2 delims== " %%a in ('yq e ".useCUDA" %YAML_FILE%') do set CUDA=%%a

set /p SimpleMode=Do you want to run in Simple Mode (only create Q4_K_M)? (y/n): 

cd %LLAMA_PATH%

py %LLAMA_PATH%\convert_hf_to_gguf.py %OUTPUT_PATH%

for /R "%OUTPUT_PATH%" %%F in (*F16*) do (
    set "A=%%F"
    goto :found
)

:found

if not defined A (
    echo No file with "F16" in its name was found.
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

echo Script completed successfully.
pause