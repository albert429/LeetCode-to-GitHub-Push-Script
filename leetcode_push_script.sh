#!/bin/bash

# LeetCode to GitHub Push Script
# Usage: ./leetcode_push.sh <problem_number> <problem_name> <solution_file>

set -e  # Exit on any error

# Configuration - Modify these variables
GITHUB_REPO_PATH="$HOME/Problem-Solving"  # Local path to your GitHub repo
COMMIT_PREFIX="Add"  # Prefix for commit messages

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to show usage
show_usage() {
    echo "Usage: $0 <problem_number> <problem_name> <solution_file>"
    echo ""
    echo "Arguments:"
    echo "  problem_number  : LeetCode problem number (e.g., 1, 42, 1337)"
    echo "  problem_name    : Problem name (e.g., 'Two Sum', 'Valid Parentheses')"
    echo "  solution_file   : Path to your solution file"
    echo ""
    echo "Examples:"
    echo "  $0 1 'Two Sum' ./two_sum.py"
    echo "  $0 42 'Trapping Rain Water' ./trapping_rain_water.cpp"
}

# Function to sanitize filename
sanitize_filename() {
    echo "$1" | sed 's/[^a-zA-Z0-9]/_/g' | sed 's/__*/_/g' | sed 's/^_\|_$//g' | tr '[:upper:]' '[:lower:]'
}

# Function to get file extension
get_extension() {
    echo "${1##*.}"
}

# Function to create directory structure
create_directory_structure() {
    local problem_number="$1"
    
    # Create main directory structure
    if [ ! -d "$GITHUB_REPO_PATH" ]; then
        print_error "GitHub repo path does not exist: $GITHUB_REPO_PATH"
        exit 1
    fi
    
    cd "$GITHUB_REPO_PATH"
    
    # Create problem directory with padded number
    problem_dir="$(printf "%04d" "$problem_number")"
    
    mkdir -p "$problem_dir"
    echo "$problem_dir"
}

# Function to create README for the problem
create_readme() {
    local problem_dir="$1"
    local problem_number="$2"
    local problem_name="$3"
    local solution_file="$4"
    
    local readme_path="$GITHUB_REPO_PATH/$problem_dir/README.md"
    
    cat > "$readme_path" << EOF
# $problem_number. $problem_name

## Problem Description

**LeetCode Link:** [Problem $problem_number](https://leetcode.com/problems/$(echo "$problem_name" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g' | sed 's/--*/-/g' | sed 's/^-\|-$//g')/)

## Solution

### Implementation

- **Language:** $(get_language_from_extension "$(get_extension "$solution_file")")
- **Time Complexity:** TODO
- **Space Complexity:** TODO

### Approach

TODO: Add your approach description here.

## Files

- \`$(basename "$solution_file")\` - Solution implementation

---

*Solved on: $(date '+%Y-%m-%d')*
EOF
    
    print_success "Created README.md"
}

# Function to get language from file extension
get_language_from_extension() {
    case "$1" in
        py) echo "Python" ;;
        cpp|cc|cxx) echo "C++" ;;
        c) echo "C" ;;
        java) echo "Java" ;;
        js) echo "JavaScript" ;;
        ts) echo "TypeScript" ;;
        go) echo "Go" ;;
        rs) echo "Rust" ;;
        rb) echo "Ruby" ;;
        php) echo "PHP" ;;
        cs) echo "C#" ;;
        swift) echo "Swift" ;;
        kt) echo "Kotlin" ;;
        scala) echo "Scala" ;;
        *) echo "Unknown" ;;
    esac
}

# Function to update main README if it exists
update_main_readme() {
    local problem_number="$1"
    local problem_name="$2"
    local solution_file="$3"
    
    local main_readme="$GITHUB_REPO_PATH/README.md"
    
    if [ ! -f "$main_readme" ]; then
        # Create main README if it doesn't exist
        cat > "$main_readme" << EOF
# LeetCode Solutions

This repository contains my solutions to LeetCode problems.

## Problems Solved

| # | Problem | Language | Solution |
|---|---------|----------|----------|
EOF
    fi
    
    # Add entry to the table (insert after header)
    local language=$(get_language_from_extension "$(get_extension "$solution_file")")
    local problem_link="[${problem_name}](https://leetcode.com/problems/$(echo "$problem_name" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g' | sed 's/--*/-/g' | sed 's/^-\|-$//g')/)"
    local solution_path="$(printf "%04d" "$problem_number")"
    
    local new_entry="| $problem_number | $problem_link | $language | [Solution](./$solution_path/) |"
    
    # Insert the new entry after the table header
    sed -i '' "/^|---|/a\\
$new_entry" "$main_readme"
    
    print_success "Updated main README.md"
}

# Main script logic
main() {
    # Check arguments
    if [ $# -lt 3 ]; then
        print_error "Insufficient arguments provided"
        show_usage
        exit 1
    fi
    
    local problem_number="$1"
    local problem_name="$2"
    local solution_file="$3"
    
    # Validate problem number
    if ! [[ "$problem_number" =~ ^[0-9]+$ ]]; then
        print_error "Problem number must be a positive integer"
        exit 1
    fi
    
    # Check if solution file exists
    if [ ! -f "$solution_file" ]; then
        print_error "Solution file does not exist: $solution_file"
        exit 1
    fi
    
    print_status "Processing LeetCode problem $problem_number: $problem_name"
    
    # Create directory structure
    problem_dir=$(create_directory_structure "$problem_number")
    print_success "Created directory structure: $problem_dir"
    
    # Copy solution file
    local sanitized_name=$(sanitize_filename "$problem_name")
    local extension=$(get_extension "$solution_file")
    local new_filename="${sanitized_name}.${extension}"
    
    cp "$solution_file" "$GITHUB_REPO_PATH/$problem_dir/$new_filename"
    print_success "Copied solution file to: $problem_dir/$new_filename"
    
    # Create README for the problem
    create_readme "$problem_dir" "$problem_number" "$problem_name" "$new_filename"
    
    # Update main README
    update_main_readme "$problem_number" "$problem_name" "$solution_file"
    
    # Git operations
    cd "$GITHUB_REPO_PATH"
    
    print_status "Adding files to git..."
    git add .
    
    print_status "Creating commit..."
    local commit_message="$COMMIT_PREFIX LeetCode $problem_number: $problem_name"
    
    git commit -m "$commit_message"
    print_success "Created commit: $commit_message"
    
    # Ask user if they want to push
    echo ""
    read -p "Do you want to push to GitHub? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        print_status "Pushing to GitHub..."
        git push
        print_success "Successfully pushed to GitHub!"
    else
        print_warning "Changes committed locally but not pushed to GitHub"
        print_status "You can push later with: cd $GITHUB_REPO_PATH && git push"
    fi
    
    print_success "LeetCode problem $problem_number processed successfully!"
}

# Run main function with all arguments
main "$@"