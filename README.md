# LeetCode to GitHub Push Script

A bash script that automates the process of organizing and pushing your LeetCode solutions to a GitHub repository with proper structure and documentation.

## Features

- 🗂️ **Organized Structure**: Creates numbered directories (e.g., `0001/`, `0042/`) for each problem
- 📝 **Auto-generated Documentation**: Creates README files for each problem with metadata
- 📋 **Main Index**: Maintains a master table of all solved problems
- 🔧 **Multi-language Support**: Detects programming language from file extensions
- 🚀 **Git Integration**: Handles git add, commit, and optional push operations
- ✨ **Clean Naming**: Sanitizes filenames and creates consistent structure

## Installation

1. **Download the script**:
   ```bash
   wget https://raw.githubusercontent.com/yourusername/your-repo/main/leetcode_push.sh
   # or copy the script content to a new file
   ```

2. **Make it executable**:
   ```bash
   chmod +x leetcode_push.sh
   ```

3. **Configure the script**:
   Edit the `GITHUB_REPO_PATH` variable in the script to point to your local GitHub repository:
   ```bash
   GITHUB_REPO_PATH="$HOME/leetcode-solutions"  # Change this path
   ```

## Setup Your Repository

1. **Create a new GitHub repository** (or use an existing one):
   ```bash
   # On GitHub, create a new repository named "leetcode-solutions"
   ```

2. **Clone the repository locally**:
   ```bash
   git clone https://github.com/yourusername/leetcode-solutions.git
   cd leetcode-solutions
   ```

3. **Update the script configuration** to match your local path.

## Usage

```bash
./leetcode_push.sh <problem_number> <problem_name> <solution_file>
```

### Parameters

- `problem_number`: LeetCode problem number (e.g., 1, 42, 1337)
- `problem_name`: Problem name in quotes (e.g., "Two Sum", "Valid Parentheses")
- `solution_file`: Path to your solution file

### Examples

```bash
# Python solution
./leetcode_push.sh 1 "Two Sum" ./two_sum.py

# C++ solution
./leetcode_push.sh 42 "Trapping Rain Water" ./trapping_rain_water.cpp

# Java solution
./leetcode_push.sh 206 "Reverse Linked List" ./reverse_list.java

# JavaScript solution
./leetcode_push.sh 20 "Valid Parentheses" ./valid_parentheses.js
```

## What It Does

1. **Creates organized directory structure**:
   ```
   leetcode-solutions/
   ├── README.md
   ├── 0001/
   │   ├── README.md
   │   └── two_sum.py
   ├── 0042/
   │   ├── README.md
   │   └── trapping_rain_water.cpp
   └── 0206/
       ├── README.md
       └── reverse_linked_list.java
   ```

2. **Generates README for each problem** with:
   - Problem title and number
   - Link to LeetCode problem
   - Language detection
   - Placeholders for time/space complexity
   - Solution date

3. **Updates main README** with a table containing:
   - Problem number
   - Problem name (linked to LeetCode)
   - Programming language
   - Link to solution directory

4. **Git operations**:
   - Adds all changes to git
   - Creates descriptive commit message
   - Optionally pushes to GitHub

## Supported Languages

The script automatically detects the programming language from file extensions:

| Extension | Language |
|-----------|----------|
| `.py` | Python |
| `.cpp`, `.cc`, `.cxx` | C++ |
| `.c` | C |
| `.java` | Java |
| `.js` | JavaScript |
| `.ts` | TypeScript |
| `.go` | Go |
| `.rs` | Rust |
| `.rb` | Ruby |
| `.php` | PHP |
| `.cs` | C# |
| `.swift` | Swift |
| `.kt` | Kotlin |
| `.scala` | Scala |

## Sample Output

After running the script, your main README.md will look like this:

```markdown
# LeetCode Solutions

This repository contains my solutions to LeetCode problems.

## Problems Solved

| # | Problem | Language | Solution |
|---|---------|----------|----------|
| 1 | [Two Sum](https://leetcode.com/problems/two-sum/) | Python | [Solution](./0001/) |
| 20 | [Valid Parentheses](https://leetcode.com/problems/valid-parentheses/) | JavaScript | [Solution](./0020/) |
| 42 | [Trapping Rain Water](https://leetcode.com/problems/trapping-rain-water/) | C++ | [Solution](./0042/) |
```

## Customization

You can customize the script by modifying these variables at the top:

```bash
GITHUB_REPO_PATH="$HOME/leetcode-solutions"  # Your repo path
COMMIT_PREFIX="Add"                          # Commit message prefix
```

## Workflow Example

Here's a typical workflow:

1. **Solve a LeetCode problem** and save your solution locally
2. **Run the script**:
   ```bash
   ./leetcode_push.sh 1 "Two Sum" ./my_solution.py
   ```
3. **Review the generated structure** and documentation
4. **Choose whether to push** to GitHub when prompted
5. **Continue solving** more problems!

## Error Handling

The script includes comprehensive error checking for:
- Invalid problem numbers
- Missing solution files
- Git repository issues
- File system permissions

---

<div align="center">
  September 2025
  
  Albert Gohar
</div>