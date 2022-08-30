# Contributing to `dbt-flink`

1. [About this document](#about-this-document)
3. [Getting the code](#getting-the-code)
5. [Running `dbt-flink` in development](#running-dbt-flink-in-development)
6. [Testing](#testing)
7. [Updating Docs](#updating-docs)
7. [Submitting a Pull Request](#submitting-a-pull-request)

## About this document

This document is a guide for anyone interested in contributing to the `dbt-flink`
repository. It outlines how to create issues and submit pull requests (PRs).

This is not intended as a guide for using `dbt-flink` in a project. For configuring and
using this adapter, see [Flink
Profile](https://docs.getdbt.com/reference/warehouse-profiles/flink-profile), and [Flink
Configs](https://docs.getdbt.com/reference/resource-configs/flink-configs).

We assume users have a Linux or MacOS system. You should have familiarity with:

- Python `virturalenv`s
- Python modules
- `pip`
- common command line utilities like `git`.

In addition to this guide, we highly encourage you to read the
[dbt-core](https://github.com/tritas/dbt-core/blob/main/CONTRIBUTING.md). Almost all
information there is applicable here!

## Getting the code

 `git` is needed in order to download and modify the `dbt-flink` code. There are several
 ways to install Git. For MacOS, we suggest installing
 [Xcode](https://developer.apple.com/support/xcode/) or [Xcode Command Line
 Tools](https://mac.install.guide/commandlinetools/index.html).

### External contributors

If you are not a member of the `tritas` GitHub organization, you can contribute to
`dbt-flink` by forking the `dbt-flink` repository. For more on forking, check out the
[GitHub docs on forking](https://help.github.com/en/articles/fork-a-repo). In short, you
will need to:

1. fork the `dbt-flink` repository
2. clone your fork locally
3. check out a new branch for your proposed changes
4. push changes to your fork
5. open a pull request of your forked repository against `tritas/dbt-flink`

## Running `dbt-flink` in development

### Installation

1. Ensure you have the latest version of `pip` installed by running `pip install
   --upgrade pip` in terminal.

2. Configure and activate a `virtualenv` as described in [Setting up an
   environment](https://github.com/tritas/dbt-core/blob/HEAD/CONTRIBUTING.md#setting-up-an-environment).

3. Install `dbt-core` in the active `virtualenv`. To confirm you installed dbt correctly,
   run `dbt --version` and `which dbt`.

4. Install `dbt-flink` and development dependencies in the active `virtualenv`. Run `pip
   install -e . -r requirements-dev.txt`.

When `dbt-flink` is installed this way, any changes you make to the `dbt-flink` source
code will be reflected immediately (i.e. in your next local dbt invocation against a
Flink target).

To create a ``virtualenv`` with the dependencies installed, run ``make venv``.

## Testing

### Initial setup

`dbt-flink` contains [unit](https://github.com/tritas/dbt-flink/tree/main/tests/unit) and
[integration](https://github.com/tritas/dbt-flink/tree/main/tests/integration) tests.
Integration tests require an actual Flink warehouse to test against. There are two
primary ways to do this:

- This repo has CI/CD GitHub Actions set up. Both unit and integration tests will run
  against an already configured Flink warehouse during PR checks.

- You can also run integration tests "locally" by configuring a `test.env` file with
  appropriate `ENV` variables.

```
cp test.env.example test.env
$EDITOR test.env
```

WARNING: The parameters in your `test.env` file must link to a valid Flink account. The
`test.env` file you create is git-ignored, but please be _extra_ careful to never check
in credentials or other sensitive information when developing.


### "Local" test commands

There are a few methods for running tests locally.

#### `tox`

`tox` automatically runs unit tests against several Python versions using its own
virtualenvs. Run `tox -p` to run unit tests for Python 3.7, Python 3.8, Python 3.9,
Python 3.10, and `flake8` in parallel. Run `tox -e py37` to invoke tests on Python
version 3.7 only (use py37, py38, py39, or py310). Tox recipes are found in `tox.ini`.

#### `pytest`

You may run a specific test or group of tests using `pytest` directly. Activate a Python
virtualenv active with dev dependencies installed. Then, run tests like so:

```sh
# Note: replace $strings with valid names

# run all flink integration tests in a directory
python -m pytest -m profile_flink tests/integration/$test_directory
# run all flink integration tests in a module
python -m pytest -m profile_flink tests/integration/$test_dir_and_filename.py
# run all flink integration tests in a class
python -m pytest -m profile_flink tests/integration/$test_dir_and_filename.py::$test_class_name
# run a specific flink integration test
python -m pytest -m profile_flink tests/integration/$test_dir_and_filename.py::$test_class_name::$test__method_name

# run all unit tests in a module
python -m pytest tests/unit/$test_file_name.py
# run a specific unit test
python -m pytest tests/unit/$test_file_name.py::$test_class_name::$test_method_name
```

## Updating documentation

Many changes will require an update to `dbt-flink` documentation. Here are some relevant
links.

- Docs are [here](https://docs.getdbt.com/).
- The docs repo for making changes is located
  [here](https://github.com/tritas/docs.getdbt.com).
- The changes made are likely to impact one or both of [Flink
  Profile](https://docs.getdbt.com/reference/warehouse-profiles/flink-profile), or [Flink
  Configs](https://docs.getdbt.com/reference/resource-configs/flink-configs).
- We ask every community member who makes a user-facing change to open an issue or PR
  regarding doc changes.

## Adding CHANGELOG Entry

We use [changie](https://changie.dev) to generate `CHANGELOG` entries. **Note:** Do not
edit the `CHANGELOG.md` directly. Your modifications will be lost.

Follow the steps to [install `changie`](https://changie.dev/guide/installation/) for your
system.

Once changie is installed and your PR is created, simply run `changie new` and changie
will walk you through the process of creating a changelog entry. Commit the file that's
created and your changelog entry is complete!

You don't need to worry about which `dbt-flink` version your change will go into. Just
create the changelog entry with `changie`, and open your PR against the `main` branch.
All merged changes will be included in the next minor version of `dbt-flink`. The Core
maintainers _may_ choose to "backport" specific changes in order to patch older minor
versions. In that case, a maintainer will take care of that backport after merging your
PR, before releasing the new version of `dbt-flink`.

## Submitting a Pull Request

A `dbt-flink` maintainer will review your PR and will determine if it has passed
regression tests. They may suggest code revisions for style and clarity, or they may
request that you add unit or integration tests. These are good things! We believe that,
with a little bit of help, anyone can contribute high-quality code.

Once all tests are passing and your PR has been approved, a `dbt-flink` maintainer will
merge your changes into the active development branch. And that's it! Happy developing
:tada:
