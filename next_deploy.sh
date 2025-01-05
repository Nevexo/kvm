# Exit immediately if a command exits with a non-zero status
set -e

# Function to display help message
show_help() {
    echo "Usage: $0 [options] -r <remote_ip>"
    echo
    echo "Required:"
    echo "  -r, --remote <remote_ip>   Remote host IP address"
    echo
    echo "Optional:"
    echo "  -u, --user <remote_user>   Remote username (default: root)"
    echo "      --help                 Display this help message"
    echo
    echo "Example:"
    echo "  $0 -r 192.168.0.17"
    echo "  $0 -r 192.168.0.17 -u admin"
    exit 0
}

# Default values
REMOTE_USER="root"
REMOTE_PATH="/userdata/jetkvm/bin"

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -r|--remote)
            REMOTE_HOST="$2"
            shift 2
            ;;
        -u|--user)
            REMOTE_USER="$2"
            shift 2
            ;;
        --help)
            show_help
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            show_help
            exit 1
            ;;
    esac
done

# Verify required parameters
if [ -z "$REMOTE_HOST" ]; then
    echo "Error: Remote IP is a required parameter"
    show_help
fi

# Check if the binary has been built at ./bin/next/jetkvm_app
if [ ! -f bin/jetkvm_app ]; then
    echo "Error: Binary not found at ./bin/jetkvm_app, run make build_next."
    exit 1
fi

# Change directory to the binary output directory
cd bin/next

# Copy the binary to the remote host
cat jetkvm_app | ssh "${REMOTE_USER}@${REMOTE_HOST}" "cat > $REMOTE_PATH/jetkvm_app_next"

# Deploy and run the application on the remote host
ssh "${REMOTE_USER}@${REMOTE_HOST}" ash <<EOF
set -e

# Set the library path to include the directory where librockit.so is located
export LD_LIBRARY_PATH=/oem/usr/lib:\$LD_LIBRARY_PATH

# Navigate to the directory where the binary will be stored
cd "$REMOTE_PATH"

# Make the new binary executable
chmod +x jetkvm_app_next

EOF

echo "Deployment complete."
