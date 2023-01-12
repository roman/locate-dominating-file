### SUMMARY
 [![tests](https://github.com/roman/locate-dominating-file/actions/workflows/tests.yml/badge.svg)](https://github.com/roman/locate-dominating-file/actions/workflows/tests.yml)

```
locate-dominating-file file|dir [options]
```


Outputs the closest parent directory containing the given file or directory
name. If it doesn't find file that matches the name, the program exits with
status code 1.

### OPTIONS

  * `--print-dir`  print directory name without file
  * `--no-print`   do not print any message
  * `--help`       prints this message

### EXAMPLE

```
  $ ls -lah /home/roman/my-project
  > .rw-r--r--    96 roman 12 Jan 13:24  .envrc
  > drwxr-xr-x     - roman 12 Jan 14:57  src

  $ cd /home/roman/my-project/src/internal/lib
  $ locate-dominating-file .env.sh
  > /home/roman/my-project/.env.sh
```

