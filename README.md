# pre-commit example

## Version

1.0.1

## What is pre-commit?

Pre-commit may refer to

1. Pre-commit: one stage among git hooks
2. Pre-commit: git hooks framework written in Python

## What is git hook?

Git hooks is a git's built-in synergy. Whenever a particular git event occurs, a script may be called.

## Example 1

For instance, to install a basic pre-commit script.

```bash
# Install a script
echo '#!/bin/bash
echo "Greeting from pre-commit script!"' > .git/hooks/pre-commit
# Make this script executable
chmod 755 .git/hooks/pre-commit
```

Whenever you commit your code, `.git/hooks/pre-commit` is called and print `Greeting from pre-commit script!`.

## Example 2

`git commit` will failed if pre-commit hook return none-zero value.

For instance:

```bash
# Install a script
echo '#!/bin/bash
echo "Pre-commit failed. You cannot commit anymore, Haha!"
return 1' > .git/hooks/pre-commit
# Make this script executable
chmod 755 .git/hooks/pre-commit
```

Because the script always return 1, pre-commit always failed, and thus you cannot commit anymore.

## What can git hook do?

If we install some scripts to check/format the code, and return zero only if all check passed, we can make sure the remote code is always clean and formatted.

## What is pre-commit framework?

As shown above, git hooks can be installed manually. However, scripts can be hard to develop and maintain.

Fortunately, there are serveral frameworks that allows you to install/manage git hooks.

[Pre-commit](https://pre-commit.com/) is one of those frameworks. It is written in `Python` and git hooks are defined in `Yaml`.

## How to install

```bash
# install packages
pip install pre-commit
# this repo run pytest at pre-push stage
pip install pytest

# Install hooks
pre-commit install
```

## Why use pre-commit?

Pre-commit is python-friendly because:

1. It is pip installable
2. It has serveral python lint/check hooks provided by community. e.g. `autopep8`, `flake8`, `isort` and `black/yapf`.

There is also other frameworks. For instance, [Husky](https://github.com/typicode/husky) is a well-known git hook framework in Javascript eco-system.
