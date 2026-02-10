# Devobackup :D

## What it is
- A (modular) backup tool written in POSIX shell.

## How it works
- It runs each backup scripts (called modules) inside `modules/` and basically just let the scripts manages themselves.
- It checks for executability so you can enable/disable any modules.
- There's two modes for each modules for backing up and restoring.
- Each module is responsible for backing up its own data
- The main script then run a pipeline that process it however you want (eg. with tar, compression, etc).

## How to use
- Edit `config.sh` to match your system's config path.

To backup:
```
$ main.sh backup "/path/to/backup/filename_with_no_extension"
```

- To disable a module:
```
$ chmod -x ./modules/script.sh/{backup.sh, restore.sh, *}
```

- To enable a module:
```
$ chmod +x ./modules/script.sh/{backup.sh, restore.sh, *}
```

## How to make a module
- Make a new directory inside `modules/` or `pipeline/` called whatever you want (eg. PostgreSQL)
```
$ mkdir modules/postgresql
```
- Or for pipeline, you name it with a number prefix at the front to organize whichever process is first.
```
$ mkdir pipeline/40-encrypt
```
- Inside that directory, create either:
    - `backup.sh` for backing up.
    - `restore.sh` for restoring a backup.

- Script accordingly, you can use these set variables:
    - `$TARGET`: the backup's directory
    - `$ARTIFACT`: the backup's filename after a pipeline process.

- If your pipeline modules modify the backup's filename, make sure to print that new filename out at the end of the script.
```
printf '%s\n' "newfilename"
```
:::info
Make sure all your loggings are output to `stderr` as `stdout` is taken by `$ARTIFACT`. eg. `printf "Your log here.\n" >&2`
:::
- You can view the pre-existing modules to learn more.

## Note
- Please don't use this on anything important. Consider using `restic`.
