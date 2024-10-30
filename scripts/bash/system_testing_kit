#!/bin/bash

# Function to display the menu
display_menu() {
    echo "-------------------------------------"
    echo "         System Testing Kit         "
    echo "-------------------------------------"
    echo "1. Package Management"
    echo "2. Disk Checks"
    echo "3. System Health"
    echo "4. Cleanup"
    echo "0. Exit"
    echo "-------------------------------------"
}

# Function to display package management options
package_management_menu() {
    echo "----- Package Management -----"
    echo "1. Check for broken packages"
    echo "2. Verify installed packages"
    echo "3. List problematic packages"
    echo "4. Remove problematic packages"
    echo "5. Fix dependencies"
    echo "6. Remove unused packages"
    echo "0. Return to main menu"
}

# Function to display disk checks options
disk_checks_menu() {
    echo "----- Disk Checks -----"
    echo "1. Check disk for errors"
    echo "2. Check disk space"
    echo "3. Check file system usage"
    echo "0. Return to main menu"
}

# Function to display system health options
system_health_menu() {
    echo "----- System Health -----"
    echo "1. Check system logs for errors"
    echo "2. Check running services"
    echo "3. Check CPU and memory usage"
    echo "0. Return to main menu"
}

# Function to display cleanup options
cleanup_menu() {
    echo "----- Cleanup -----"
    echo "1. Remove unnecessary packages"
    echo "2. Clean up package cache"
    echo "0. Return to main menu"
}

# Function to check for broken packages
check_broken_packages() {
    echo "Checking for broken packages..."
    sudo apt install -f
}

# Function to verify installed packages
verify_installed_packages() {
    echo "Verifying installed packages..."
    sudo debsums -s
}

# Function to list problematic packages
list_problematic_packages() {
    echo "Listing problematic packages..."
    dpkg -l | grep -v '^ii'
}

# Function to remove problematic packages
remove_problematic_packages() {
    echo "Removing problematic packages..."
    read -p "Enter the names of the packages to remove (space-separated): " packages
    sudo apt remove --purge $packages
}

# Function to fix dependencies
fix_dependencies() {
    echo "Fixing dependencies..."
    sudo apt install -f
}

# Function to remove unused packages
remove_unused_packages() {
    echo "Removing unused packages..."
    sudo apt autoremove
}

# Function to check disk for errors
check_disk_errors() {
    echo "Checking disk for errors..."
    read -p "Enter the disk partition to check (e.g., /dev/sda1): " partition
    sudo fsck -f $partition
}

# Function to check disk space
check_disk_space() {
    echo "Checking disk space..."
    df -h
}

# Function to check file system usage
check_file_system_usage() {
    echo "Checking file system usage..."
    du -sh /* 2>/dev/null
}

# Function to check system logs for errors
check_system_logs() {
    echo "Checking system logs for errors..."
    journalctl -p err -b
}

# Function to check running services
check_running_services() {
    echo "Checking running services..."
    systemctl list-units --type=service --state=running
}

# Function to check CPU and memory usage
check_cpu_memory_usage() {
    echo "Checking CPU and memory usage..."
    top -b -n 1 | head -n 20
}

# Function to remove unnecessary packages
remove_unnecessary_packages() {
    echo "Removing unnecessary packages..."
    sudo apt autoremove
}

# Function to clean up package cache
clean_package_cache() {
    echo "Cleaning up package cache..."
    sudo apt clean
}

# Main script
while true; do
    display_menu
    read -p "Choose an option: " main_choice

    case $main_choice in
        1)  # Package Management
            while true; do
                package_management_menu
                read -p "Choose an option: " pkg_choice

                case $pkg_choice in
                    1) check_broken_packages ;;
                    2) verify_installed_packages ;;
                    3) list_problematic_packages ;;
                    4) remove_problematic_packages ;;
                    5) fix_dependencies ;;
                    6) remove_unused_packages ;;
                    0) break ;;
                    *) echo "Invalid option. Please try again." ;;
                esac
            done
            ;;
        2)  # Disk Checks
            while true; do
                disk_checks_menu
                read -p "Choose an option: " disk_choice

                case $disk_choice in
                    1) check_disk_errors ;;
                    2) check_disk_space ;;
                    3) check_file_system_usage ;;
                    0) break ;;
                    *) echo "Invalid option. Please try again." ;;
                esac
            done
            ;;
        3)  # System Health
            while true; do
                system_health_menu
                read -p "Choose an option: " health_choice

                case $health_choice in
                    1) check_system_logs ;;
                    2) check_running_services ;;
                    3) check_cpu_memory_usage ;;
                    0) break ;;
                    *) echo "Invalid option. Please try again." ;;
                esac
            done
            ;;
        4)  # Cleanup
            while true; do
                cleanup_menu
                read -p "Choose an option: " cleanup_choice

                case $cleanup_choice in
                    1) remove_unnecessary_packages ;;
                    2) clean_package_cache ;;
                    0) break ;;
                    *) echo "Invalid option. Please try again." ;;
                esac
            done
            ;;
        0) echo "Exiting..."; exit 0 ;;
        *) echo "Invalid option. Please try again." ;;
    esac
done
