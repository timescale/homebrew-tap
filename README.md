# Brew formulas for TimescaleDB

The repository that hosts the [brew][1] formulas to install TimescaleDB on
macOs.

## Installing from the formula

If you're looking for only installing the TimescaleDB on a macOs, check how to
install from our [official guide][2].

## Development

If you want to edit the actual formula locally try:

```bash
brew edit timescaledb
```

## Testing

If you want to test a Pull Request in progress in this repository, use the
following steps:

Navigate to the Timescale tap directory:

```bash
cd $(brew --prefix)/Homebrew/Library/Taps/timescale/homebrew-tap/
```

The folder is a git repository, so you can fetch the branches and check out the target branch and test it.

```bash
git fetch
```

It will fetch all the branches from the remote repository. You can use `git
branch` to list them and then `git checkout` to start testing it.

```bash
git checkout <branch-in-progress>
```

Now, you can run the formula, and it will run it from the actual branch:

```bash
brew install --build-from-source timescaledb
```

You can see all brew options for running the formula [here][3].

After you finish your testing/development, don't forget to switch back to the main branch:

```bash
git checkout -
```

[1]: https://brew.sh
[2]: https://docs.timescale.com/install/latest/self-hosted/installation-macos/#install-self-hosted-timescaledb-using-homebrew
[3]: https://docs.brew.sh/Formula-Cookbook#install-the-formula
