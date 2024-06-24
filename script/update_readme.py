import requests
import os
from pathlib import Path

os.chdir(os.path.join(os.path.dirname(__file__), '../'))
print(os.getcwd())


bagde_html = '''
<br>

<div>
    <img alt="python" src="https://img.shields.io/badge/python-3.10-%233776AB?logo=python">
</div>
<div>
    <img alt="platform" src="https://img.shields.io/badge/platform-Windows-blueviolet">
</div>
<div>
    <img alt="license" src="https://img.shields.io/github/license/runhey/OnmyojiAutoScript">
    <img alt="GitHub repo size" src="https://img.shields.io/github/repo-size/runhey/OnmyojiAutoScript">
    <img alt="GitHub all releases" src="https://img.shields.io/github/downloads/runhey/OnmyojiAutoScript/total">
    <img alt="stars" src="https://img.shields.io/github/stars/runhey/OnmyojiAutoScript?style=social">
</div>
<br>
'''

badge_markdown = '''
'''





def get_github_readme(owner, repo):
    url = f"https://api.github.com/repos/{owner}/{repo}/readme"
    headers = {"Accept": "application/vnd.github.v3+json"}

    response = requests.get(url, headers=headers)
    if response.status_code == 200:
        data = response.json()
        readme_content = data["content"]
        # 解码Base64编码的内容
        import base64
        readme_text = base64.b64decode(readme_content).decode("utf-8")
        return readme_text
    else:
        return None
    
def process_readme(readme_text: str):
    readme_text = readme_text.replace(bagde_html, badge_markdown).replace("<br>", "\n").replace("</div>", "\n").replace('<div align="center">', '')
    readme_text = '# \n' + readme_text
    readme_text = f"""const String githubReadme = \"\"\"
{readme_text}
\"\"\";"""
    return readme_text



if __name__ == "__main__":
    owner = "runhey"
    repo = "OnmyojiAutoScript"
    readme = get_github_readme(owner, repo)
    if not readme:
        print("无法获取README文件。")
        raise
    
    readme = process_readme(readme)
    with open("lib/config/github_readme.dart", "w", encoding="utf-8") as f:
        f.write(readme)