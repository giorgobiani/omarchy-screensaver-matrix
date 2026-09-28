# omarchy-screensaver-fx

Choose which effect the Omarchy screensaver shows, from the Omarchy menu or
the command line. Defaults to the Matrix digital rain.

Omarchy's screensaver plays a random [ttfx](https://github.com/ChrisBuilds/terminaltexteffects)
effect over your branding text (`~/.config/omarchy/branding/screensaver.txt`).
This narrows that pick to the effects you choose.

## Install

```bash
./install.sh            # matrix
./install.sh fireworks  # or start with another effect
```

## Use

**Menu:** Style → Screensaver → Effect (the current choice has a ✓), and
Style → Screensaver → Preview.

**CLI:**

```bash
screensaver-fx list                    # all effects
screensaver-fx set matrix              # only matrix
screensaver-fx set matrix rain beams   # random pick from these
screensaver-fx random                  # Omarchy default
screensaver-fx show
screensaver-fx preview
```

The choice lives in `~/.config/omarchy/screensaver-fx.conf` and applies on the
next screensaver cycle.

## Uninstall

```bash
./uninstall.sh
```

## What it installs

| File | Purpose |
|------|---------|
| `/usr/local/bin/ttfx` | Wrapper that adds `--include-effects` to the screensaver's ttfx call only |
| `~/.local/bin/screensaver-fx` | CLI for picking effects |
| `~/.config/omarchy/screensaver-fx.conf` | Your chosen effects |
| `~/.config/omarchy/extensions/omarchy-menu.jsonc` | Menu entries, between `>>> screensaver-fx` / `<<< screensaver-fx` markers |
| `~/.config/omarchy/hooks/post-update.d/screensaver-fx-check` | Warns after `omarchy update` if the screensaver changed in a way that breaks this |

Nothing under `/usr/share/omarchy/` is touched, so `omarchy update` never undoes it.

## How it works

Omarchy has no screensaver plugin hook: the idle service always runs
`omarchy-launch-screensaver`, which runs `omarchy-screensaver` from
`/usr/share/omarchy/bin` (that directory is first on the screensaver's PATH,
so the script itself can't be overridden). The script calls `ttfx
--random-effect`, and `ttfx` is looked up further down the PATH, where
`/usr/local/bin` comes before `/usr/bin`. The wrapper there adds
`--include-effects <yours>` to the screensaver's call and passes every other
`ttfx` call through unchanged.

If a future Omarchy release changes that call, the wrapper stops matching and
you simply get random effects again; the post-update hook tells you when that
happens.

## License

[MIT](LICENSE)
