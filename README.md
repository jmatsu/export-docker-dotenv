# export-docker-dotenv

`export-docker-dotenv` is Docker's dotenv compatible *Bash* exporter function but not a command. `.env` has a lot of dialects and many of them are not compatible with Docker's.

## Limitation

### Supported shell

Currently, this funciton is fully compatible only with Bash because of `eval` implementation.

For example, `Dash` will evaluate `\` as escape characters so this function cause an error.

You can check the compatibility in this repository

- Supported (tested) shells :right_arrow: [./.github/workflows/test.yml](./.github/workflows/test.yml)
- Supported syntax regardless of shell :right_arrow: [./compatible.env](./compatible.env)
- Only Bash :right_arrow: [./compatible.bash.env](./compatible.bash.env)

# Docker dotenv Syntax

Docker's dotenv specification is mentioned at https://docs.docker.com/compose/env-file/ but not fully explained.

You can see the expected result of Docker by running `docker run --rm --env-file <env file> -it alpine:3.14 /bin/sh -c 'env | grep DOCKER_DOTENV_COMPATIBLE_ | sort'`

> The results below are produced by `Docker version 20.10.16, build aa7e414`.

```.env
DOCKER_DOTENV_COMPATIBLE_01=not foo. I overloaded the old value.
DOCKER_DOTENV_COMPATIBLE_02=bar
DOCKER_DOTENV_COMPATIBLE_03=HELLO # WORLD. This is not a comment so i should be visible.
DOCKER_DOTENV_COMPATIBLE_04="double quotation is also a part of this value"
DOCKER_DOTENV_COMPATIBLE_05=background process? no &
DOCKER_DOTENV_COMPATIBLE_06=pipe | does | not | work |
DOCKER_DOTENV_COMPATIBLE_07=redirection > never < work <(process)
DOCKER_DOTENV_COMPATIBLE_08=semicolon ; semicolon!
DOCKER_DOTENV_COMPATIBLE_09=Don't use the value of DOCKER_DOTENV_COMPATIBLE_03 anyway :right-hand: $DOCKER_DOTENV_COMPATIBLE_03 ${DOCKER_DOTENV_COMPATIBLE_03}
DOCKER_DOTENV_COMPATIBLE_10=A backslash \ is a part of this value
DOCKER_DOTENV_COMPATIBLE_11=A backslash at the end of this line is also a part of this value \
DOCKER_DOTENV_COMPATIBLE_11_1=yes, I'm also a value yay
DOCKER_DOTENV_COMPATIBLE_12=Multiple = are found but only the first = is used
DOCKER_DOTENV_COMPATIBLE_BASH_01=Line return \n is just a part of this value
DOCKER_DOTENV_COMPATIBLE_BASH_02=A backslash is not a escape char \\n. You can see two backslashes.
```

`docker run --rm --env-file compatible.env -it alpine:3.14 /bin/sh -c 'echo $DOCKER_DOTENV_COMPATIBLE_12'`

```
Multiple = are found but only the first = is used
```

## Invalid assigments will be ignored

In the document, Docker mentions on comments and empty lines but actually Docker's dotenv ignores invalid variable assigment formats. In fact, comments and empty lines are also invalid for shell.

- Lines start with a sharp `#`
  - It also allows leading spaces
- Empty or blank lines
- Lines without `=`

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