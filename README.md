# MergekitHelper
Simple batch-Python utility to merge, quantize, and count parameters.

# Usage

1. Follow instructions to [install mergekit here](https://github.com/arcee-ai/mergekit/tree/main?tab=readme-ov-file#installation).
	- Although mergekit supports all package installers, you must be using conda to use MergekitHelper.
2. Download your relevant version of llamacpp from [its releases section](https://github.com/ggerganov/llama.cpp/releases/), then unzip it.
	- Psst... if you're not sure what version to download... here's some helpful info.
    	- Here's a typical llamacpp release name: `llama-b3886-bin-win-cuda-cu11.7.1-x64.zip`
    	- Let's segment it by "-". The `llama` signifies what project the zip's from.
    	- The next part, the `b3886`, is the build ID.
    	- The `bin` signifies a prebuilt binary instead of source code.
    	- The `win` is the operating system.
    	- `cuda` is the backend/library.
        	- If you're on a 40 series NVIDIA card, download CUDA 12. Older NVIDIA cards may need CUDA 11 (use Google).
        	- Anything with `avx` are instructions for CPUs. If your CPU doesn't have any avx support (unlikely), use the `noavx` version. Google if your computer supports `avx2` or `avx512`.
        	- If you're on an AMD GPU, use `vulkan`.
        	- If you know what you're doing, you can use one of the other backends too.
    	- `x64` is the instruction set, of course.
3. Clone llamacpp with `git clone https://github.com/ggerganov/llama.cpp` or an analogue into a folder of your choice.
4. Download and unzip MergekitHelper from the releases section.
5. Set up paths in the `settings.yaml` file in the MergekitHelper folder.
	- condaPath (folder): where your anaconda installation is.
	- condaPath (folder): where your anaconda installation is. **Make sure you have the `transformers` library installed on your base conda environment.** (Not sure? Use the Windows search bar to find a program called "Anaconda Prompt" and type `conda list`. If `transformers` isn't there, type `conda install transformers`.)
	- mergekitConfigPath (path ending in *.yaml): where your mergekit config.yaml file is. This file determines the settings for your merge.
	- outputPath (folder): where you want to output your finished merges.
	- llamacppBinPath (folder): where your llamacpp binaries are (the folder you downloaded from the llamacpp releases section).
6. If you would like to use the included `showavailablemodels.ps1` module, you will have to turn on **powershell script execution**. Here is how to do it:
	- Type `Win + R`.
	- Enter `powershell` and hit `Ctrl + Shift + Enter`. Agree to the administrator permission popup.
	- Copy and paste (or type) `set-executionpolicy remotesigned`.
	- Either enter `Y` or `A`.
	- To run the .ps1 file, right click on it and select "Run with Powershell".

Also included is a batch file to quantize only without the merging  (`quantize.bat`), the python file that counts parameters (`countparameters.py`), and a dev version `countparameters_dev.py` with print statements to use as a standalone program.

# Changelog
**v1.0.0** (Oct 5 2024): Release

**v1.0.1** (Oct 20 2024): Add roadmap and known issues to README + example config

**v1.1.0** (Dec 12 2024): Add `seeavailablemodels.ps1`: will begin moving away from batch in future (the lack of proper regex/find and replace is killing me!!)

**v1.1.1** (Dec 13 2024): Add new `skipF16` option to `quantize.bat` to skip the HF to GGUF conversion step. v1.1.0 accidentally pushed a staging version of merge.bat with experimental support for other package managers, but it seems to still work on my machine so it's staying there. Keep in mind that support for other package managers is still **beta**. Fixed issue with `ParamCount` not correctly updating for `quantize.bat`, fixed ambiguous pauses in `merge.bat`, and added debug statements to help resolve runtime errors all around.

**v1.1.2** (Dec 16 2024): Add new `updatedependencies.bat` file to `git pull` llamacpp and mergekit. Requires you to fill a new setting in `settings.yml`. 

# Known Issues
Sometimes, mergekit won't create the `tokenizer.json` file properly. I have no clue why this happens, but it seems more prominent on Gemma-based models. Just close the `merge.bat` window, download the architecture's appropriate tokenizer (head to the Huggingface page of one of the architecture's models and download it from the file list), put it into your output folder, and use the `quantize.bat` file to quantize instead.

# Roadmap

- Support for pip and poetry (made slightly more difficult because I don't know how poetry works at all)
- Error handler for both mergekithelper and mergekit
- Support for other operating systems (again, made slightly more difficult because I've never used MacOS, Linux, or their ecosystems in my life)

# Credits

Thanks to the amazing [mergekit](https://github.com/arcee-ai/mergekit/) by Arcee, and [llamacpp](https://github.com/ggerganov/llama.cpp) by the incredible llamacpp team.
