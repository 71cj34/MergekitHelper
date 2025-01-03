from huggingface_hub import create_repo, create_branch, upload_file, Repository
import os

if(len(os.system("huggingface-cli whoami").split) != 1):
    raise KeyboardInterrupt("You are not signed in to huggingface-cli or it is not installed. Use a terminal to sign in.")

sizes = [float(i) for i in input("Enter names of branches to create (space seperated): ").split()]
username = input("HF username: ")
name = input("Name of repo: ")
base_out_path = input("Enter your base output path (Expects a dir with subfolders matching the names of the branches): ")

repo_name = f"{username}/{name}-EXL2"
create_repo(repo_name)

for size in sizes:
    create_branch(repo_name, branch=f"{size}bpw")

repo = Repository(local_dir="/hub", clone_from=repo_name)

_, folders, _ = next(os.walk(os.path.join(base_out_path, name)))

for folder in folders:
    folder_path = os.path.join(base_out_path, name, folder)
    _, _, files = next(os.walk(folder_path))

    branch_name = f"{sizes[folders.index(folder)]}bpw"
    repo.git_checkout(branch_name)

    for file in files:
        file_path = os.path.join(folder_path, file)
        upload_file(
            path_or_fileobj=file_path,
            path_in_repo=file,
            repo_id=repo_name,
            branch=branch_name
        )
