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
	- mergekitConfigPath (path ending in *.yaml): where your mergekit config.yaml file is. This file determines the settings for your merge.
	- outputPath (folder): where you want to output your finished merges.
	- llamacppBinPath (folder): where your llamacpp binaries are (the folder you downloaded from the llamacpp releases section).
	- llamacppPath (folder): where your llamacpp clone is (the folder you cloned).
	- useCUDA (bool): use CUDA or not. Accepts `true` or `false`.
	        - This appears to just be a switch to do intermediate calculations on GPU, so it may not be NVIDIA-specific. I’m not sure.
6. Run `merge.bat` and answer a few more prompts in the command window that appears.
7. Kick back and enjoy!

Also included is a batch file to quantize only without the merging  (`quantize.bat`), the python file that counts parameters (`countparameters.py`), and a dev version `countparameters_dev.py` with print statements to use as a standalone program.

# Credits

Thanks to the amazing [mergekit](https://github.com/arcee-ai/mergekit/) by Arcee, and [llamacpp](https://github.com/ggerganov/llama.cpp) by the incredible llamacpp team.

# Extra Information

[mergekit's examples](https://github.com/arcee-ai/mergekit/tree/main/examples)

Jason Cheng, last updated 2024
