import argparse
import re
import os
import zipfile
import time


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--path",
        type=str,
        help="xxx",
    )
    parser.add_argument(
        "--version",
        type=str,
        help="xxx",
    )
    args, _ = parser.parse_known_args()
    if args.path:
        release_path = args.path
    else:
        if os.path.exists("./build/windows/x64/runner/Release/oasx.exe"):
            release_path = "./build/windows/x64/runner/Release"
        elif os.path.exists("./build/windows/runner/Release/oasx.exe"):
            release_path = "./build/windows/runner/Release"
        else:
            raise FileNotFoundError("No release path found.")
    match = re.search(r'build.*Release', release_path)
    if match:
        release_path = match.group(0)
        release_path = release_path.replace('\\', '/')
        print(f"Matched string: {release_path}")
    else:
        print("No match found.")

    if args.version:
        release_version = args.tag
    else:
        with open('./CHANGELOG.md', 'r', encoding='utf-8') as file:
            log = file.read()
            log = re.search(r'v\d+\.\d+\.\d+', log).group(0)
            log = log.replace('\n', '').replace('\r', '').replace(' ', '')
            release_version = log


    # 压缩
    zip_filename = f'oasx_{release_version}_windows.zip'
    with zipfile.ZipFile(zip_filename, 'w') as zip_file:
        # 遍历文件夹中的文件
        for foldername, subfolders, filenames in os.walk(release_path):
            for filename in filenames:
                # 构建文件的完整路径
                file_path = os.path.join(foldername, filename)

                # 将文件添加到 Zip 文件中
                zip_file.write(file_path, os.path.relpath(file_path, release_path))

    time.sleep(10)
