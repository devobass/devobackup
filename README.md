# Devobackup :D

## What it is
- A (modular) backup tool written in POSIX shell.

## How it works
- It runs each backup script (called modules) inside `modules/` and basically just let the scripts manages themselves.
- It checks for executability so you can enable/disable any modules.
- Each module is responsible for backing up its own data
- The main script then turns the backup into a `tar` archive, compress with `zstd`, then verify with `b3sum`.

## How to use
- Edit `config.sh` to match your system's config path.

```
$ main.sh "/path/to/desire/backup/directory"
```

- To disable a module:
```
$ chmod -x ./modules/script.sh
```

- To enable a module:
```
$ chmod +x ./modules/script.sh
```
