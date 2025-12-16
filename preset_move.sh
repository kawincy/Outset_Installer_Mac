#!/bin/bash

# Find the current logged-in user (works with or without sudo)
CURRENT_USER=$(scutil <<< "show State:/Users/ConsoleUser" | awk '/Name :/ && ! /loginwindow/ { print $3 }')
[ -z "$CURRENT_USER" ] && CURRENT_USER=$(whoami)

# Get the user’s home directory
USER_HOME=$(dscl . -read "/Users/$CURRENT_USER" NFSHomeDirectory | awk '{print $2}')
[ -z "$USER_HOME" ] && { echo "ERROR: Could not determine home directory"; exit 1; }

# Where Packages temporarily placed the folder (because you put it at /)
TEMP_PAYLOAD="/Library/Retrofuturistic HW"

# Final destination
TARGET="$USER_HOME/Documents/Retrofuturistic HW"

# Copy the entire folder to Documents
mkdir -p "$USER_HOME/Documents"
cp -R "$TEMP_PAYLOAD" "$USER_HOME/Documents/"

# Fix ownership (critical!)
chown -R "$CURRENT_USER":staff "$TARGET"

# Clean up the copy that Packages left at the root
rm -rf "$TEMP_PAYLOAD"

echo "Lantertronics successfully installed to ~/Documents/Retrofuturistic HW"
exit 0



# #!/bin/bash

# # Find current logged-in user
# CURRENT_USER=$(scutil <<< "show State:/Users/ConsoleUser" | awk '/Name :/ && ! /loginwindow/ { print $3 }')
# [ -z "$CURRENT_USER" ] && CURRENT_USER=$(whoami)

# # Get home directory
# USER_HOME=$(dscl . -read "/Users/$CURRENT_USER" NFSHomeDirectory | awk '{print $2}')
# [ -z "$USER_HOME" ] && { echo "ERROR: Could not determine home directory"; exit 1; }

# # This is the correct absolute path when the folder is placed at root in Packages
# SRC="/Retrofuturistic HW"                    # ← absolute path, starts with /
# DST="$USER_HOME/Documents/Retrofuturistic HW"

# # Remove any previous install (optional but clean)
# rm -rf "$DST"

# # Copy everything recursively and preserve attributes (the trailing / is important!)
# cp -a "$SRC/" "$USER_HOME/Documents/"

# # Fix ownership
# chown -R "$CURRENT_USER":staff "$DST"

# # Clean up the root copy
# rm -rf "$SRC"

# echo "Retrofuturistic HW successfully installed to $DST"
# exit 0