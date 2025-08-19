# Redis Commands

### 1- Where to do configuartion stuff

You can find the configuration file in /etc/redis , just run the following command to edit it

```bash
sudo nano /etc/redis/redis.conf
```

### 2- Check how much RAM is used

info memory give all information about memory used by redis

```bash
redis-cli info memory | grep used_memory_human
```


### 3- Check keys related info

```bash
redis-cli info keyspace
```

### 4- modify max RAM memory redis can use

to check max memory redis can use (you can also see it in info memory command):

```bash
redis-cli CONFIG GET maxmemory
```
"0" : mean he can use up to os available memory.

to modify it use the following command (temporarily)

```bash
redis-cli CONFIG SET maxmemory 512mb
```

or you can modify the config file using the following command (permanently)

```bash
echo "maxmemory 1gb" | sudo tee -a /etc/redis/redis.conf
```

!! note that you need to restart the redis-server

```bash
sudo systemctl restart redis-server
```

### 5- What if redis hits the maxmemory

You can configure what happen when redis hits the max memory allowed

there is 6 different policies:

=> noeviction (default) : redis will refuse new writes, but you can read normally

=> allkeys-lru : redis deletes the least recently used key

=> volatile-lru : redis deletes the least recently used keys, but only those with a TTL (with experation date)

=> allkeys-random : redis deletes a random key (less CPU charge policy)

=> volatile-random : redis deletes a random key, but only those with a TTL

=> volatile-ttl : redis deletes the key with the nearest experation time

you can update the policy on both config file and using redis-cli (temporarily), before that let's check the current policy used.

```bash
redis-cli info memory | grep maxmemory_policy
```

to modify policy:

```bash
redis-cli CONFIG SET maxmemory-policy [policy-name]
```
And from the config file

```bash
echo [policy-name] | sudo tee -a /etc/redis/redis.conf
```

### 6- What happen to data when you restart your machine or redis crashes

there is a way to save data even if redis crashes, when starting redis next time you should be able to see your data from last session, thanks to the persistence methods.

Generally there is 2 main persistence methods:

#### RDB (Redis DataBase Backup, snapshots)

Used mainly for backups, its fast to re load since it is 1 file.

Syntax:

```bash
save n1 n2
```

where n1 and n2 are 2 numbers, n1 is the time interval and n2 is the number of keys changed, as example let's say we have "save 60 5" that mean take a snapshot (which is a full copy of database) if only there is min 5 key changes in 60 seconds.

[!] you can check if this type of persistence is enbaled on the config file or using the redis-cli

```bash
redis-cli config get save
```

the snapshot is saved on a file (in disk), you can check the file on this path

```bash
sudo file /var/lib/redis/dump.rdb
```

#### AOF (append-only file)

this logs every write to a file appendonly.aof

you can enable this by changing the "appendonly no" (since redis default is set to no) to "appendonly yes" on your redis.conf file,

add also this "appendfsync [everysec | always | no]"

=> everysec : redis flashes AOF once per sec

=> always : redis flashes every write to disk immediately

=> no : redis lets the OS decide when to flush the file to disk


[!!!] You can use both methods in the same time, in opposite you can disable both of them (when the data is not that important)

To disable both of them : 

```bash
save ""
appendonly no
```

### 7- Performance tuning


#### Number of Databases

by default redis comes with 16 different db

```bash
redis-cli config get databases
```

to check current client using which db use :

```bash
redis-cli client list | grep  db
```
to switch db use:

```bash
redis-cli select [db_number]
```

#### Housekeeping frequency

#### Client Connection Settings

#### Network & IO

#### Eviction and Key Expiration

#### Logging & Monitoring

### 8- Security 

#### Set password for clients

```bash
echo "requirepass [your_password_here]" | sudo tee -a /etc/redis/redis.conf
```

restart your redis and try to login using the password

```bash
redis-cli -a "your_pass"
```
