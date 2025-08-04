import argparse
import os
import subprocess


def get_config_path():
    ldir = os.listdir("/etc/postgresql")
    path = f"/etc/postgresql/{ldir[0]}/main/"
    return path

def change_auth(auth_type):
    l = ["peer","md5"]
        
    
    path = get_config_path()
    pg_hba_path = path + "pg_hba.conf"
    with open(pg_hba_path,"r") as f:
        lines = f.readlines()
    index = None
    index2 = None
    for line in lines:
        if "Database administrative login by Unix domain socket" in line:
            index = lines.index(line)+1
        if '"local" is for Unix domain socket connections only' in line:
            index2 = lines.index(line)+1
    
    if auth_type in lines[index] and auth_type in lines[index2]:
        print(f"authentication method is already : {auth_type}")
        print(f"waiting for postgresql to restart ...")
        subprocess.run(["systemctl", "restart", "postgresql"],stdout=subprocess.PIPE,stderr=subprocess.PIPE,text=True)
        return 0
    if auth_type == l[0]:
        
        s = lines[index]
        s = s.replace(l[1],l[0])
        lines[index] = s

        s2 = lines[index2]
        s2 = s2.replace(l[1],l[0])
        lines[index2] = s2
    else:
        s = lines[index]
        s = s.replace(l[0],l[1])

        lines[index] = s

        s2 = lines[index2]
        
        s2 = s2.replace(l[0],l[1])
        
        lines[index2] = s2
    with open(pg_hba_path,"w") as ff:
        ff.writelines(lines)
        
    
    print(f"authentication method changed from {l[(l.index(auth_type)+1)%2]} to {auth_type}")
    print(f"waiting for postgresql to restart ...")
    subprocess.run(["systemctl", "restart", "postgresql"],stdout=subprocess.PIPE,stderr=subprocess.PIPE,text=True)
    return 1
    

def allow_remote():
    print("allow ...")

def ban_remote():
    print("ban ...")

def main():
    parser = argparse.ArgumentParser(description='Configuration script for Postgresql')
    
    parser.add_argument('command', help='The main command to process: "authentication" to change auth type, "allow remote" to allow remote connections, "ban remote" to remove remote connections')

    

    
    args = parser.parse_args()
    
    cmd = args.command

    match cmd:
        case "authentication":
            l = ["peer","md5"]
            user_input = ""
            while user_input not in l:
                user_input = input("Authentication type to change to it (md5,peer): ")
            try:
                change_auth(user_input)
            except PermissionError:
                print("please run the script as sudo")
        case "allow remote":
            allow_remote()
        case "ban remote":
            ban_remote()
        case _:
            print(f"invalid command : {cmd}")


    

    
    



if __name__ == "__main__":
    main()