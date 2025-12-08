
#!/bin/zsh

# Navigate to your Nix flake directory (replace with your path)
cd ~/nix-dotfiles || exit

# Update Nix flakes
echo "Updating Nix flakes..."
nix flake update

# Check if any changes were made
if [[ $(git status --porcelain) ]]; then
   # Add changes to the staging area
   git add flake.lock

   # Commit changes with a message
   git commit -m "Update Nix flakes"

   echo "Updates have been commited"
else
   echo "No changes to commit."
fi
