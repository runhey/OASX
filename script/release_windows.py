import subprocess
import os
import re

# Ensure running in Alas root folder
os.chdir(os.path.join(os.path.dirname(__file__), '../'))
root_path = os.getcwd()
print(root_path)

result = subprocess.run('flutter build windows', shell=True, capture_output=True, text=True)
print(result.stdout)

match = re.search(r"build\\(\w+Release)", result.stdout)
if match:
    matched_string = match.group(1)
    print(matched_string)

