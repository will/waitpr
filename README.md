# waitpr

See the status of github pr checks from the command line for only the current
pr. `waitpr` will spin showing you the up-to-date status until all checks are
finished, then exit.

## Install

First make sure you have the [`gh` tool](https://github.com/cli/cli) installed
and in your path. `waitpr` uses that for auth and to make the api calls.

Then run `shards build --release` and put the binary generated in `bin`
somewhere in your path. Eventually I hope to do some sort of homebrew thing
maybe but I haven't yet.

## Usage

```
$ waitpr
done! 00:01:35.920273513
      lint	✅
     specs	❌	https://github.com/will/waitpr/runs/12345
ci (proj1)	✅
ci (proj2)	✅
```

## Contributing

1. Fork it (<https://github.com/will/waitpr/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

