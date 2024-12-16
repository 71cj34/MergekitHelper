@echo off

set YAML_FILE=settings.yaml

for /f "tokens=2 delims== " %%a in ('yq e ".condaPath" %YAML_FILE%') do set CONDA_PATH=%%a
for /f "tokens=2 delims== " %%a in ('yq e ".mergekitConfigPath" %YAML_FILE%') do set CONFIG_PATH=%%a
for /f "tokens=2 delims== " %%a in ('yq e ".outputPath" %YAML_FILE%') do set OUTPUT_PATH=%%a
for /f "tokens=2 delims== " %%a in ('yq e ".llamacppBinPath" %YAML_FILE%') do set LLAMA_BINPATH=%%a
for /f "tokens=2 delims== " %%a in ('yq e ".llamacppPath" %YAML_FILE%') do set LLAMA_PATH=%%a
for /f "tokens=2 delims== " %%a in ('yq e ".useCUDA" %YAML_FILE%') do set CUDA=%%a
for /f "tokens=2 delims== " %%a in ('yq e ".mergekitPath" %YAML_FILE%') do set MERGEKIT_PATH=%%a


echo Attempting to update mergekit...

cd MERGEKIT_PATH
git pull

echo:
echo Mergekit pull completed. Check your console for any errors now.
echo:
pause

cd LLAMA_PATH
git pull

echo:
echo Llama.cpp pull completed. Both dependency pulls completed. Check your console for any errors now.
echo:
pause