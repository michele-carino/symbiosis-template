import sys
import re

def fix_markdown_links(input_path, output_path):
    with open(input_path, "r", encoding="utf-8") as f:
        content = f.read()

    # Regex per trovare i link markdown locali, escludendo URL esterni, ancore e mail
    pattern = r'(\]\s*\(\s*)(?!http://|https://|mailto:|#)(\.\/)?([^)]+)(\))'

    def replacer(match):
        prefix = match.group(1)
        target = match.group(3)
        suffix = match.group(4)

        # Aggiunge ../ se non è già presente
        if not target.startswith("../"):
            target = "../" + target

        return f"{prefix}{target}{suffix}"

    new_content = re.sub(pattern, replacer, content)

    with open(output_path, "w", encoding="utf-8") as f:
        f.write(new_content)

if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("Uso: python3 fix_links.py <input> <output>")
        sys.exit(1)

    fix_markdown_links(sys.argv[1], sys.argv[2])