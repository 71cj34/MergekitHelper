from safetensors import safe_open
import os
import yaml

with open('settings.yaml', 'r') as f:
    data = yaml.load(f, Loader=yaml.SafeLoader)
llamaPath = data['outputPath']

total_params = 0
rounded_params = 0

def count_parameters_in_safetensors(file_path: str) -> int:
    total_params = 0
    with safe_open(file_path, framework="pt") as f:
        for key in f.keys():
            tensor = f.get_tensor(key)
            total_params += tensor.numel()
    return total_params

def find_all(path):
    result = []
    for root, dirs, files in os.walk(path):
        for file in files:
            if file.endswith(".safetensors"):
                result.append(root + "/" + file)
    return result

paths = find_all(llamaPath)

for i in range(len(paths)):
    midcount = count_parameters_in_safetensors(paths[i])
    total_params += midcount
    i += 1

total_params = total_params / 1000000000
inter_params = str(total_params)
list_params = list(inter_params)

if list_params[0] in ["3", "7", "8", "9"]:
    del list_params[1:]
elif list_params[0:2] in ["12", "13", "14", "20", "33", "34", "70"]:
    del list_params[2:]
elif list_params[0:3] in ["101", "120"]:
    del list_params[3:]
else:
    rounded_params = round(total_params, 2)

if(rounded_params == 0):
    concatenated_string = ''.join(map(str, list_params))
    total_params = float(concatenated_string)
    print(str(total_params) + "b\n")
else:
    print(str(rounded_params) + "b\n")