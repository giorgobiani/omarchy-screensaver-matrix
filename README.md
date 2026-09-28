# omarchy-screensaver-matrix

Choose which effect the Omarchy screensaver shows, from the Omarchy menu or
the command line. Defaults to **endless Matrix digital rain**.

Omarchy's screensaver plays a random [ttfx](https://github.com/ChrisBuilds/terminaltexteffects)
effect over your branding text (`~/.config/omarchy/branding/screensaver.txt`).
This narrows that pick to the effects you choose.

### Endless Matrix

ttfx's matrix effect is a one-shot: the rain fills the screen, then resolves
into the branding text, and the screensaver starts it over. With Matrix as your
only effect, this runs its own rain instead (`matrix-rain`), which never
stops. The density drifts on a random schedule:

- it builds up until the screen is **completely filled**, holds for a while,
  then **thins out** to a sparse drizzle, and back again
- how long each build-up, thin-out and pause lasts is random (roughly 15 to
  50 seconds each way, with pauses of a few to 25 seconds)
- peaks and lows vary: most build-ups fill the screen, some stop halfway
- characters in the trails keep changing, like in the film

So it never looks like a looped video. The look and pace match the classic
effect: ttfx's symbols, its muted green colours and white-green heads, its fall
speed and how often characters change. It uses about a tenth of one CPU core.

Prefer the original, ending on your branding text? Pick **Matrix (classic)**.

Requires [Omarchy](https://omarchy.org/). The installer asks for `sudo` once,
to place the ttfx wrapper in `/usr/local/bin`.

## Install

```bash
git clone https://github.com/giorgobiani/omarchy-screensaver-matrix.git
cd omarchy-screensaver-matrix
./install.sh            # matrix
./install.sh fireworks  # or start with another effect
```

## Use

**Menu:** Style → Screensaver → Effect (the current choice has a ✓), and
Style → Screensaver → Preview. **Matrix** is the endless rain, **Matrix
(classic)** is ttfx's effect.

**CLI:**

```bash
screensaver-fx list                    # all effects
screensaver-fx matrix endless          # only matrix, endless rain (default)
screensaver-fx matrix classic          # only matrix, ttfx's effect ending on the branding text
screensaver-fx set matrix rain beams   # random pick from these (matrix is the classic one here)
screensaver-fx random                  # Omarchy default
screensaver-fx show
screensaver-fx preview
```

The choice lives in `~/.config/omarchy/screensaver-fx.conf` and applies the
next time the screensaver starts.

Endless mode only applies when Matrix is the *only* effect: with several
effects, each one has to end so the next can play.

You can also run the rain on its own in any terminal, `Ctrl+C` to stop:

```bash
matrix-rain                 # --fps N to change the frame rate (default 30)
```

## Uninstall

```bash
./uninstall.sh
```

## What it installs

| File | Purpose |
|------|---------|
| `/usr/local/bin/ttfx` | Wrapper that adds `--include-effects` to the screensaver's ttfx call only |
| `~/.local/bin/screensaver-fx` | CLI for picking effects |
| `~/.local/bin/matrix-rain` | The endless Matrix rain (Python, no extra packages) |
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

For endless Matrix, the wrapper runs `matrix-rain` instead of ttfx.
`omarchy-screensaver` waits while a process named `ttfx` runs on its terminal,
and on a key press or focus change it runs `pkill -x ttfx`. `matrix-rain`
therefore renames itself to `ttfx` (`prctl(PR_SET_NAME)`), so the screensaver's
loop and exit keep working unchanged. It only draws to the terminal and never
reads from it, so the screensaver still sees your key presses.

If a future Omarchy release changes that call, the wrapper stops matching and
you simply get random effects again; the post-update hook tells you when that
happens.

## License

[MIT](LICENSE)
