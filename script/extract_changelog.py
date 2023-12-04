import os
from pathlib import Path


os.chdir(os.path.join(os.path.dirname(__file__), '../'))
print(os.getcwd())


if __name__ == '__main__':
    change_latest: str = ''
    with open('./CHANGELOG.md', 'r', encoding='utf-8') as file:
        log = file.read()
        start_index = log.find('# v')
        end_index = log.find('# v', start_index+1)
        change_latest = log[start_index: end_index]

    print(change_latest)
    with open('CHANGELATEST.md', 'w', encoding='utf-8') as file:
        file.write(change_latest)
    
