import requests
import json
import sys

def lookup(word):
    response = requests.get(f"https://www.dictionaryapi.com/api/v3/references/collegiate/json/{word}?key=<API>")
    result = json.loads(response.content)[0]
    definitions = "\n".join(result["shortdef"])

    print("English-English result:")
    print(f"{word}: {definitions}")

    print("\nChinese result:")
    print("<insert Chinese translation here>")

if __name__ == "__main__":
    lookup(sys.argv[1])
