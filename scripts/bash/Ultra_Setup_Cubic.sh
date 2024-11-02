#!/bin/bash

# Ultra Customization Tool for Ubuntu ISO
# Usage:
#   ./ultra-configure-system.sh --apps "app1 app2" --toolbar "app1 app2" --dns "8.8.8.8 8.8.4.4" --disable-ipv6 --firewall "enable"

LOG_FILE="/var/log/ultra-configure-system.log"
DEB_DIR="/opt/offline_packages"
CUSTOM_SCRIPTS_DIR="/opt/custom_scripts"
WALLPAPER_PATH="/usr/share/backgrounds/custom_wallpaper.jpg"
THEME_DIR="/usr/share/themes/custom_theme"

# Default configurations
APPS=()
TOOLBAR_APPS=()
DNS_SERVERS=()
DISABLE_IPV6=false
FIREWALL_ENABLE=false
USER_NAME="user"  # Customize this if needed

# Helper function to log messages
log() {
    echo "$1" | tee -a "$LOG_FILE"
}

# Argument parsing
parse_arguments() {
    while [[ "$#" -gt 0 ]]; do
        case $1 in
            --apps) APPS=($2); shift ;;
            --toolbar) TOOLBAR_APPS=($2); shift ;;
            --dns) DNS_SERVERS=($2); shift ;;
            --disable-ipv6) DISABLE_IPV6=true ;;
            --firewall) FIREWALL_ENABLE=true ;;
            *) echo "Unknown parameter passed: $1"; exit 1 ;;
        esac
        shift
    done
}

# Install an application using multiple methods
install_application() {
    local app=$1
    log "Attempting to install $app..."

    if apt-cache search "^$app$" &> /dev/null; then
        log "Installing $app via apt..."
        apt install -y "$app" && log "$app installed via apt." && return 0
    fi

    if snap find "$app" &> /dev/null; then
        log "Installing $app via snap..."
        snap install "$app" && log "$app installed via snap." && return 0
    fi

    if flatpak search "$app" &> /dev/null; then
        log "Installing $app via flatpak..."
        flatpak install -y flathub "$app" && log "$app installed via flatpak." && return 0
    fi

    for deb_file in "$DEB_DIR"/*.deb; do
        if [[ "$(basename "$deb_file")" =~ "$app" ]]; then
            log "Installing $app from $deb_file..."
            dpkg -i "$deb_file" && apt install -f -y && log "$app installed from .deb." && return 0
        fi
    done

    log "Failed to install $app."
    return 1
}

# Install all specified applications
install_applications() {
    for app in "${APPS[@]}"; do
        install_application "$app"
    done
}

# Configure GNOME toolbar favorites
configure_gnome_toolbar() {
    if [[ ${#TOOLBAR_APPS[@]} -eq 0 ]]; then
        log "No toolbar apps specified, skipping..."
        return
    fi

    log "Configuring GNOME toolbar..."
    local favorites=()
    for app in "${TOOLBAR_APPS[@]}"; do
        favorites+=("'${app}.desktop'")
    done
    dconf write /org/gnome/shell/favorite-apps "[${favorites[*]}]"
    log "Toolbar configured."
}

# Apply DNS and disable IPv6 settings
configure_network() {
    if [[ ${#DNS_SERVERS[@]} -gt 0 ]]; then
        log "Configuring DNS..."
        printf "nameserver %s\n" "${DNS_SERVERS[@]}" > /etc/resolv.conf
    fi

    if [[ "$DISABLE_IPV6" == true ]]; then
        log "Disabling IPv6..."
        echo -e "net.ipv6.conf.all.disable_ipv6 = 1\nnet.ipv6.conf.default.disable_ipv6 = 1\nnet.ipv6.conf.lo.disable_ipv6 = 1" >> /etc/sysctl.conf
        sysctl -p
    fi
}

# Configure firewall settings
configure_firewall() {
    if [[ "$FIREWALL_ENABLE" == true ]]; then
        log "Configuring firewall..."
        apt install -y ufw
        ufw default deny incoming
        ufw default allow outgoing
        ufw allow ssh
        ufw enable
        log "Firewall enabled with basic settings."
    else
        log "Firewall configuration skipped."
    fi
}

# Set custom wallpaper and theme
configure_wallpaper_and_theme() {
    log "Configuring wallpaper and theme..."

    if [[ -f "$WALLPAPER_PATH" ]]; then
        dconf write /org/gnome/desktop/background/picture-uri "'file://$WALLPAPER_PATH'"
    fi

    if [[ -d "$THEME_DIR" ]]; then
        gsettings set org.gnome.desktop.interface gtk-theme "custom_theme"
    fi
    log "Wallpaper and theme configured."
}

# Create a custom user and configure permissions
configure_user() {
    log "Configuring user: $USER_NAME"
    useradd -m -s /bin/bash "$USER_NAME"
    echo "$USER_NAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/"$USER_NAME"
}

# Manage services to be started on first boot
manage_services_on_boot() {
    log "Setting up services to start on first boot..."

    cat <<EOF >/etc/systemd/system/post_install_services.service
[Unit]
Description=Post Installation Service Setup
After=network.target

[Service]
Type=oneshot
ExecStart=/usr/local/bin/start_services.sh
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
EOF

    cat <<'EOF' >/usr/local/bin/start_services.sh
#!/bin/bash
services=("docker" "mdatp" "forticlient")
for service in "${services[@]}"; do
    systemctl unmask "$service.service"
    systemctl start "$service.service"
    echo "$service started successfully" >> /var/log/post_install.log
done
EOF

    chmod +x /usr/local/bin/start_services.sh
    systemctl enable post_install_services.service
    log "Service startup configuration completed."
}

# Execute custom scripts in specified directory
run_custom_scripts() {
    if [[ -d "$CUSTOM_SCRIPTS_DIR" ]]; then
        log "Running custom scripts from $CUSTOM_SCRIPTS_DIR..."
        for script in "$CUSTOM_SCRIPTS_DIR"/*.sh; do
            if [[ -f "$script" ]]; then
                bash "$script"
                log "Executed $script."
            fi
        done
    else
        log "No custom scripts directory found at $CUSTOM_SCRIPTS_DIR."
    fi
}

# Main Execution
log "Starting ultra customization process..."
parse_arguments "$@"
install_applications
configure_gnome_toolbar
configure_network
configure_firewall
configure_wallpaper_and_theme
configure_user
manage_services_on_boot
run_custom_scripts
log "Ultra customization process completed."
