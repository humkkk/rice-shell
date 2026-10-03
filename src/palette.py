import sys
import json
from pathlib import Path

def load_palette(path: Path) -> dict:
    with open(path) as f:
        data = json.load(f)
    return data

def main():
    path = Path(sys.argv[1])
    palette = load_palette(path)
    print(f"{palette['name']} ({palette['mode']})")

if __name__ == "__main__":
    main()
