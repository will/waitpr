# waitpr

[![CI](https://github.com/will/waitpr/actions/workflows/ci.yml/badge.svg)](https://github.com/will/waitpr/actions/workflows/ci.yml)

See the status of github pr checks from the command line for only the current
pr. `waitpr` will spin showing you the up-to-date status until all checks are
finished, then exit.

A notification will pop up if the checks take longer than one minute. Only on
macOS right now, but patches welcome for linux.

I've lost a lot of time getting distracted waiting for checks to finish. Then
by the time I remember I'm supposed to merge a patch, someone else has already
pushed to the main branch. So then I need to rebase and wait for the checks
again, with a high probability of getting distracted again.

![demo-screencap](https://user-images.githubusercontent.com/1973/117383861-91d64c00-ae96-11eb-980f-e9004e9f0b55.gif)

## Installation

First make sure you have the [`gh` tool](https://github.com/cli/cli) installed
and in your path. `waitpr` uses that for auth and to make the api calls.

Then run `shards build --release` and put the binary generated in `bin`
somewhere in your path. Eventually I hope to do some sort of homebrew thing
maybe but I haven't yet.

## Usage

```
$ waitpr -h
Usage: waitpr [arguments]
    --version                        Show the version
    -x, --no-notify                  Disable notifications
    -n SECONDS, --notify=SECONDS     Notify when finished if jobs take longer than n seconds (default 60)
    -h, --help                       Show this help

Global config can optionally be placed in ~/.config/waitpr/waitpr
Project-local config can optionally be placed in .waitpr and will supersede global config
Direct command arguments supersede both project-local and global
```

## Contributing

1. Fork it (<https://github.com/will/waitpr/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

