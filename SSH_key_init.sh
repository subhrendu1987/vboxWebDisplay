#!/bin/bash

# Define the directory for SSH keys as per the docker-compose.yml
SSH_DIR="./ssh"

# Check if the directory exists
if [ ! -d "$SSH_DIR" ]; then
    mkdir "$SSH_DIR"
fi

# Generate the SSH key pair
if [ ! -f "$SSH_DIR/id_rsa" ]; then
    ssh-keygen -t rsa -f "$SSH_DIR/id_rsa" -N ""
    echo "SSH key pair created successfully."
else
    echo "SSH key pair already exists. Skipping generation."
fi

# Set the correct permissions for the SSH directory and files
chmod 700 "$SSH_DIR"
chmod 600 "$SSH_DIR/id_rsa"
chmod 644 "$SSH_DIR/id_rsa.pub"

# Print the public key for user to copy
echo "Here's your public key:"
cat "$SSH_DIR/id_rsa.pub"
echo "You should add this public key to the authorized_keys of the target server."
