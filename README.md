# export-docker-dotenv

`export-docker-dotenv` is a shell function to export Docker-compatible dotenv files but not command. 

**Important Notice*: This function uses `export` and `eval`. These commands may cause unpredictable side-effects. You must not use this function for unknown and/or invalid .env files.

## Motivation

We often use `.env` files to setup Docker containers for DRY or any other purpose. And also, sometimes wrapper commands of Docker operations require loading `.env` files in advance. 

Many awesome dotenv libraries are available, however, `.env` has a lot of dialects and most of them are not compatible with Docker's. Moreover, Docker dialect is not shell-friendly by design. 

**Why poor hacks are dangerous?**

Poor hacks like the below will cause syntax failures and/or unexpected side effects. It's kinda vulnerability.

- Load .env by `export` direcly or use `allexport`
    - `export $(cat .env)`
    - `set -o allexport; export .env; set +o allexport`
- Use awk and other commands to wrap each line by quotation marks
    - `export $(awk -F= '$0=$1 "=\"" $2 "\""' .env)`
    - `export $(awk -F= "$0=$1 \"='\" $2 \"'\"" .env)`

```
# These tokens are recognized as dependant arguments by the shell
INCLUDING_SPACES=value_is_only_this here_is_variable_name_without_assignment variable_name=is_an_assignment

# The shell launches a background process
LAUNCH_BACKGROUND=Launch & 

# The shell recognizes the below as pipes
PIPE=hello | world

# The shell creats *world* file.
REDIERCT=hello > world

# The shell won't load the characters after a semicolon
BREAK_LINE=this_would_be_availble_but; echo 'This command will be executed'
```

## Usage

This is not a command but just a snippet so copy-and-paste or download the proper file.

> If you would like to download it by using curl else, we strongly recommend specifying commit-sha1.

- [./export-docker-dotenv](./export-docker-dotenv)
  - For Bash, Zsh, Ksh users.
  - Never persists data on your filesystem.
- [./export-docker-dotenv-without-proc-subst](./export-docker-dotenv-without-proc-subst)
  - For shells that do not support the process substitution.
  - Instead of that, this implementation uses a temporary file to iterate lines in the target env file.
    - `.env` often contains sensitive data so we do not use this way as the default.

```
# Download export-docker-dotenv to the current working directory

source ./export-docker-dotenv

# export variables from .env
export_docker_dotenv .env

# export variables that are currently undefined from .env
export_docker_dotenv .env --no-overwrite
```

## Supported shells

See the test cases. [./.github/workflows/test.yml](./.github/workflows/test.yml)

# Docker dotenv Syntax

Docker's dotenv specification is mentioned at https://docs.docker.com/compose/env-file/ but not fully explained. This section shows the inferred specification by its behaviour.

You can see the expected result of Docker by running `docker run --rm --env-file <env file> -it alpine:3.14 /bin/sh -c 'env | grep DOCKER_DOTENV_COMPATIBLE_ | sort'`

<destils>
    <summary>Outputs of env/compatible.env and env/compatible.overload.env produced by `Docker version 20.10.16, build aa7e414`.</summary>

```txtDOCKER_DOTENV_COMPATIBLE_00=Hello world!
DOCKER_DOTENV_COMPATIBLE_01=Not buggy. I overloaded the old value.
DOCKER_DOTENV_COMPATIBLE_02=Docker allows overloading by another file
DOCKER_DOTENV_COMPATIBLE_03=HELLO # WORLD. This is not a comment so i should be visible.
DOCKER_DOTENV_COMPATIBLE_04="double quotation is also a part of this value"
DOCKER_DOTENV_COMPATIBLE_05=background process? no &
DOCKER_DOTENV_COMPATIBLE_06=pipe | does | not | work |
DOCKER_DOTENV_COMPATIBLE_07=redirection > never < work <(process)
DOCKER_DOTENV_COMPATIBLE_08=semicolon ; semicolon!
DOCKER_DOTENV_COMPATIBLE_09=Don't use the value of DOCKER_DOTENV_COMPATIBLE_03 anyway. $DOCKER_DOTENV_COMPATIBLE_03 ${DOCKER_DOTENV_COMPATIBLE_03}
DOCKER_DOTENV_COMPATIBLE_10=A backslash \ is a part of this value
DOCKER_DOTENV_COMPATIBLE_11=A backslash at the end of this line is also a part of this value \
DOCKER_DOTENV_COMPATIBLE_11_1=yes, I'm also a value yay
DOCKER_DOTENV_COMPATIBLE_12=Multiple = are found but only the first = is used
DOCKER_DOTENV_COMPATIBLE_13= leading space value
DOCKER_DOTENV_COMPATIBLE_14=Line return \n is just a part of this value
DOCKER_DOTENV_COMPATIBLE_15=A backslash is not a escape char \\n. You can see two backslashes.
```

`docker run --rm --env-file compatible.env -it alpine:3.14 /bin/sh -c 'echo $DOCKER_DOTENV_COMPATIBLE_12'`

```txt
Multiple = are found but only the first = is used
```
    
</details>

## Non-assigments will be ignored

The format of assigment is `VAR=VAL`. In the document, Docker mentions on comments and empty lines but actually Docker's dotenv ignores invalid variable assigment formats. 

- Lines start with a sharp `#`
  - It also allows leading spaces
- Empty or blank lines
- Lines without `=`

```txt
# a comment

  # The line above is an empty line. This is also a comment btw.

this is an invalid line.
```

## Invalid assigments cause errors

It seems `VAR` must follow the assigment format of POSIX shell.

```
FOOBARBAZ =spaces are not allowed in VAR
```

## All are literals

- Do not escape
  - `\` is just a part of each value.
  - This means multi lines in .env files are not avialable
- Do not expand variables
  - `${VAR}` is also a part of each value.

## Allow overloading

Many dialects do not allow overloading variables but Docker does without any warning.

# References

- Docker's dotenv explanations - https://docs.docker.com/compose/env-file/
- https://zenn.dev/red_fat_daruma/articles/7f0ebe9c4d5659 (Japanese article)

# Other dialects

- [ko1nksm/shdotenv](https://github.com/ko1nksm/shdotenv)
- [bkeepers/dotenv](https://github.com/bkeepers/dotenv)
- [motdotla/dotenv](https://github.com/motdotla/dotenv)

and more

# License

Under [MIT License](./LICENSE). The license notation is already included by the function files.

> We assume no responsibility whatsoever for any damages resulting from the use of this function.
