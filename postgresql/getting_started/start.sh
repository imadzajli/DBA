#!/bin/bash


printx() {
    echo "----------------------------------------------"
    echo "  $1"
    echo "----------------------------------------------"
}

if systemctl is-active --quiet postgresql; then
    printx "PostgreSQL is already running"
else
    printx "PostgreSQL is not running - attempting to start..."
    sudo systemctl start postgresql
    
    
    if systemctl is-active --quiet postgresql; then
        echo "OK: PostgreSQL started successfully"
    else
        echo "ERROR: Failed to start PostgreSQL" >&2
        exit 1
    fi
fi