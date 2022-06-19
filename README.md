# export-docker-dotenv

`export-docker-dotenv` is a shell function to export Docker-compatible dotenv files but not command. `.env` has a lot of dialects and many of them are not compatible with Docker's.

## Motivation



## Limitation

### Supported shell

Currently, this funciton is fully compatible only with Bash because of `eval` implementation. For example, `Dash` will evaluate `\` as escape characters so this function cause an error. You may be able to use this function for other shells like dash with some restrictions.

You can check the compatibility in this repository.

- Supported (tested) shells
  - [./.github/workflows/test.yml](./.github/workflows/test.yml)
- Supported syntax regardless of shell
  - [./compatible.env](./compatible.env)
- Only Bash :right_arrow: [./compatible.bash.env](./compatible.bash.env)

# Docker dotenv Syntax

Docker's dotenv specification is mentioned at https://docs.docker.com/compose/env-file/ but not fully explained.

You can see the expected result of Docker by running `docker run --rm --env-file <env file> -it alpine:3.14 /bin/sh -c 'env | grep DOCKER_DOTENV_COMPATIBLE_ | sort'`

> The results below are produced by `Docker version 20.10.16, build aa7e414`.

```txt
DOCKER_DOTENV_COMPATIBLE_00=Hello world!
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
```

`docker run --rm --env-file compatible.env -it alpine:3.14 /bin/sh -c 'echo $DOCKER_DOTENV_COMPATIBLE_12'`

```txt
Multiple = are found but only the first = is used
```

## Invalid assigments will be ignored

In the document, Docker mentions on comments and empty lines but actually Docker's dotenv ignores invalid variable assigment formats. In fact, comments and empty lines are also invalid for shell.

- Lines start with a sharp `#`
  - It also allows leading spaces
- Empty or blank lines
- Lines without `=`
- Name contains spaces

```txt
# a comment

  # The line above is an empty line. This is also a comment btw.

this is an invalid line.
FOO =spaces are not allowed in names
```

## All are literals

- Do not escape
  - `\` is just a part of each value.
  - This means multi lines in .env files are not avialable
- Do not expand variables
  - `${VAR}` is also a part of each value.

# Other dialects

- [ko1nksm/shdotenv](https://github.com/ko1nksm/shdotenv)
- [bkeepers/dotenv](https://github.com/bkeepers/dotenv)
- [motdotla/dotenv](https://github.com/motdotla/dotenv)

and more

# References

- Docker's dotenv explanations - https://docs.docker.com/compose/env-file/
- https://zenn.dev/red_fat_daruma/articles/7f0ebe9c4d5659 (Japanese article)