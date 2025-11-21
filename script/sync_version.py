import ruamel.yaml
import argparse
import re
import pathlib

# pip install ruamel.yaml 

def sync_version(new_version: str = None):
    """
    输入不带 v 三个数字的版本号，例如 1.0.0
    """

    file_name = './pubspec.yaml'
    with open(file_name, 'r', encoding='utf-8') as file:
        yaml = ruamel.yaml.YAML()
        yaml.preserve_quotes = True
        pubspec = yaml.load(file)
        current_version = pubspec['version']
        match = re.match(r'(.+?)\+(.+)', current_version)  
        if match:
            current_version = match.group(1)
            current_build_number = int(match.group(2))
        else:
            raise ValueError(f"Invalid version format: {current_version}")
        
        # 
        if new_version is not None:
            write_version: str = f"{new_version}+{current_build_number + 1}"
            msix_version: str = f'{new_version}.0'
        else:
            write_version: str = f'{current_version}+{current_build_number + 1}'
            msix_version: str = f'{current_version}.0'

        # 写入到 msix 的版本号
        pubspec['msix_config']['msix_version'] = msix_version
        pubspec['version'] = write_version

    with open(file_name, 'w', encoding='utf-8') as file:
        yaml.dump(pubspec, file)



if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--newversion",
        type=str,
        default=None,
        help="New version to sync. Default to version in CHANGELOG.md",
    )
    args, _ = parser.parse_known_args()
    sync_version(args.newversion)
