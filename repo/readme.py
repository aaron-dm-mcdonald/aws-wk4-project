# tree.py
#------------------------------------------------------------------

import os

#------------------------------------------------------------------


def load_gitignore():
    # Load the .gitignore file and return a set of patterns to ignore.
    ignore_patterns = set()
    if os.path.exists('.gitignore'):
        with open('.gitignore', 'r') as f:
            for line in f:
                stripped_line = line.strip()
                if stripped_line and not stripped_line.startswith('#'):
                    ignore_patterns.add(stripped_line)
    return ignore_patterns

def should_ignore(path, ignore_patterns):
    """Check if a path should be ignored based on the ignore patterns."""
    for pattern in ignore_patterns:
        if pattern in path:
            return True
    return False

def list_files(startpath, ignore_patterns):
    markdown_output = []

    for root, dirs, files in os.walk(startpath):
        # Skip the .git directory
        if '.git' in root:
            continue
        
        # Filter out ignored files
        files = [f for f in files if not should_ignore(f, ignore_patterns)]

        level = root.replace(startpath, '').count(os.sep)
        indent = ' ' * 4 * level
        markdown_output.append(f"{indent}- {os.path.basename(root)}/")

        subindent = ' ' * 4 * (level + 1)
        for f in files:
            markdown_output.append(f"{subindent}- {f}")

    return "\n".join(markdown_output)

def write_to_file(output, append_to_readme=False):
    if append_to_readme:
        readme_file = 'README.md'
        if os.path.exists(readme_file):
            with open(readme_file, 'a') as f:
                f.write("\n# Project Structure\n\n")
                f.write(output)
            print("File structure appended to README.md")
        else:
            print("README.md not found. Please create it first or choose to create a separate file.")
    else:
        with open('FILE_STRUCTURE.md', 'w') as f:
            f.write("# Project Structure\n\n")  # Add a header
            f.write(output)
        print("File structure written to FILE_STRUCTURE.md")

if __name__ == "__main__":
    ignore_patterns = load_gitignore()
    output = list_files('.', ignore_patterns)

    choice = input("Would you like to (1) create a separate .md file or (2) append to README.md? (Enter 1 or 2): ")
    if choice == '1':
        write_to_file(output, append_to_readme=False)
    elif choice == '2':
        write_to_file(output, append_to_readme=True)
    else:
        print("Invalid choice. Please enter 1 or 2.")