#!/bin/bash

export session_username="<no session>"
export session_password="<no session>"
export session_database="<no session>"
export session_port="5432"
export session_server_ip="127.0.0.1"
export session_admin_password = ""


print_start() {
    
    local GREEN='\033[0;32m'
    local BLUE='\033[0;34m'
    local CYAN='\033[0;36m'
    local YELLOW='\033[1;33m'
    local BOLD='\033[1m'
    local NC='\033[0m' 
    
    
    local script_name=$(basename "$0")
    
    echo -e "${CYAN}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║${NC}                                                            ${CYAN}║${NC}"
    echo -e "${CYAN}║${NC}  ${BOLD}${YELLOW}🚀 SCRIPT STARTING${NC}                                     ${CYAN}║${NC}"
    echo -e "${CYAN}║${NC}                                                            ${CYAN}║${NC}"
    echo -e "${CYAN}║${NC}  ${GREEN}Script:${NC} ${BOLD}$script_name${NC}                                    ${CYAN}║${NC}"
    echo -e "${CYAN}║${NC}  ${GREEN}Time:${NC}   $(date '+%Y-%m-%d %H:%M:%S')                        ${CYAN}║${NC}"
    echo -e "${CYAN}║${NC}  ${GREEN}User:${NC}   $USER                                           ${CYAN}║${NC}"
    echo -e "${CYAN}║${NC}                                                            ${CYAN}║${NC}"
    echo -e "${CYAN}╚════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

print_start

print_title() {
    echo "-------------- $1 --------------"
}

print_help() {
    print_title "[ help ]"
    echo "!!! for now all commands work locally only except connect_remote !!!"
    echo "  'help' to display this help text"
    echo "  'create_session' to create a login session (or update existing session)"
    echo "  'check_session' to check current session"
    echo "  'switch' to switch to postgres user (Linux user) exit to out"
    echo "  'update_password' to update postgres password (DB user)"
    echo "  'change_password' to change password for a user"
    echo "  'create_user' to create user (role inside psql)"
    echo "  'create_db' to create db"
    echo "  'run_sql' to run a single sql command"
    echo "  'run_script' to run sql script"
    echo "  'list_users' to check existing roles"
    echo "  'list_tables' to list current tables on session database"
    echo "  'version' to print psql version"
    echo "  'connect_local' to connect to local db"
    echo "  'connect_remote' to connect to remote db"
    echo "  'exit' to exit"
}

print_help

read_input() {
    read -p "Enter your command here, ('help' to display help section): " input
    echo "$input"
}

update_password_fun() {
    echo -e "\nUpdating PostgreSQL password..."
    sudo -u postgres psql <<EOF
\password postgres
\q
EOF
    echo "Password updated successfully"
    
}

create_user_fun() {
    read -p "Enter username (role name): " username
    read -p "Enter password: " password

}

connect_local_fun() {
    read -p "username: " user
    read -p "database: " db
    psql -U $user -d $db -h 127.0.0.1 -W
    
}

connect_remote_fun() {
    read -p "username: " user
    read -p "database: " db
    read -p "port (default 5432): " port
    read -p "server ip: " ip
    if [ -z $port ]; then
        psql -U $user -d $db -h $ip -p 5432 -W    
    else
        psql -U $user -d $db -h $ip -p $port -W
    fi
}
#!/bin/bash

print_messages() {
    local msg1="$1"
    local msg2="$2"
    local msg3="$3"
    local msg4="$4"
    local msg5="$5"
    
    # Colors
    local RED='\033[0;31m'
    local GREEN='\033[0;32m'
    local YELLOW='\033[1;33m'
    local BLUE='\033[0;34m'
    local PURPLE='\033[0;35m'
    local CYAN='\033[0;36m'
    local WHITE='\033[1;37m'
    local BOLD='\033[1m'
    local NC='\033[0m' # No Color
    
    # Get terminal width
    local width=$(tput cols)
    
    # Create decorative lines
    local double_line="$(printf '═%.0s' $(seq 1 $width))"
    local single_line="$(printf '─%.0s' $(seq 1 $width))"
    local star_line="$(printf '*%.0s' $(seq 1 $width))"
    
    # Helper function to center text
    center_text() {
        local text="$1"
        local color="$2"
        local plain_text=$(echo -e "$text" | sed 's/\x1b\[[0-9;]*m//g')  # Strip color codes for length calculation
        local text_length=${#plain_text}
        local padding=$(( (width - text_length) / 2 ))
        printf "%*s${color}%s${NC}%*s\n" $padding "" "$text" $((width - text_length - padding)) ""
    }
    
    echo ""
    echo -e "${CYAN}${double_line}${NC}"
    echo ""
    center_text "📋 CURRENT SESSION" "${BOLD}${WHITE}"
    echo ""
    echo -e "${BLUE}${single_line}${NC}"
    echo ""
    
    # Print the 5 messages with different colors and icons
    if [[ -n "$msg1" ]]; then
        center_text "🔸 $msg1" "${YELLOW}"
        echo ""
    fi
    
    if [[ -n "$msg2" ]]; then
        center_text "🔹 $msg2" "${GREEN}"
        echo ""
    fi
    
    if [[ -n "$msg3" ]]; then
        center_text "🔶 $msg3" "${BLUE}"
        echo ""
    fi
    
    if [[ -n "$msg4" ]]; then
        center_text "🔷 $msg4" "${PURPLE}"
        echo ""
    fi
    
    if [[ -n "$msg5" ]]; then
        center_text "⭐ $msg5" "${RED}"
        echo ""
    fi
    
    echo -e "${BLUE}${single_line}${NC}"
    center_text "$(date '+%Y-%m-%d %H:%M:%S') | User: $USER" "${CYAN}"
    echo -e "${CYAN}${double_line}${NC}"
    echo ""
}

create_session_fun() {
    read -p "Enter session username : " session_username
    read -p "Enter session database : " session_database
    read -p "Enter session password : " session_password
    read -p "Enter session server ip (null if local host) : " session_server_ip
    read -p "Enter session port (null if 5432) : " session_port
    read -p "Enter admin (postgres) password for config tasks : " session_admin_password

    export session_username
    export session_database
    export session_password
    if [ ! -z "$session_port"]; then
        export session_port
    fi
    if [ ! -z "$session_server_ip"]; then
        export session_server_ip
    fi
    
    
}


check_session_fun() {
    print_messages "Current user : $session_username" "Current database : $session_database" "Server ip : $session_server_ip" "Port : $session_port"
}

create_user_fun() {
    if [ -z "$session_admin_password" ]; then
        echo "session_admin_password is not set"
        return 0
    fi
    read -p "Enter username you want to create : " username
    read -p "Enter password : " password
    read -p "Allow login (login quota) y/n : " login
    read -p "Allow create db y/n : " createdb
    PGPASSWORD=$session_admin_password psql -U postgres -c "create role $username with login password '$password'"
    if [ "$login"="y" ];then
        PGPASSWORD=$session_admin_password psql -U postgres -c "alter role $username with login"
    fi
    if [ "$createdb"="y" ];then
        PGPASSWORD=$session_admin_password psql -U postgres -c "alter role $username createdb"
    fi

    echo "user $username has been created!"
      

}

create_db_fun() {
    read -p "Enter db name" db
    read -p "Enter db owners" owner
    PGPASSWORD=$session_admin_password psql -U postgres -c "create database $db owner $owner"
    echo "Db created sucessfully"   
}

list_users_fun() {
    PGPASSWORD=$session_admin_password psql -U postgres -c "\du"
}

list_tables_fun() {
    PGPASSWORD=$session_password psql -U $session_username -d $session_database -c "\d"
}

change_password_fun() {
    echo "Not implemented yet"
}

run_script_fun() {
    echo "Not implemented yet"
}



while true; do
    input=$(read_input)
    case $input in
        help)
            echo
            print_help
            echo
            ;;
        exit)
            echo
            echo "Exiting..."
            echo
            break
            ;;
        version)
            echo
            psql --version
            echo
            ;;
        switch)
            echo
            sudo -i -u postgres
            echo
            ;;
        update_password)
            update_password_fun
            ;;
        create_user)
            create_user_fun
            ;;
        connect_local)
            connect_local_fun
            ;;
        connect_remote)
            connect_remote_fun
            ;;
        create_session)
            create_session_fun
            ;;
        check_session)
            check_session_fun
            ;;
        create_user)
            create_user_fun
            ;;
        create_db)
            create_db_fun
            ;;
        list_users)
            list_users_fun
            ;;
        list_tables)
            list_tables_fun
            ;;
        change_password)
            change_password_fun
            ;;
        run_script)
            run_script_fun
            ;;
        *)
            echo
            echo "Unknown command: $input"
            echo
            ;;
    esac
done

