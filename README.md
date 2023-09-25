
# Tmux Attacher

Interactive wrapper for tmux to facilitate session attachment
## Description

The `tmux-attacher` script provides an interactive prompt to easily attach to existing Tmux sessions or create new ones. It serves as a user-friendly interface to the `tmux` command, enhancing its default behavior

When invoked without arguments, `tmux-attacher` will present an interactive menu
that allows the user to attach to pre-existing sessions or to create new ones.

In cases where one or more arguments are provided, `tmux-attacher` delegates
those arguments to the `tmux` command, ensuring backward compatibility. This script's implementation follows the [Proxy Design Pattern][proxy], intercepting
invocations of the `tmux(1)` command and extending its functionality.

[proxy]: https://en.wikipedia.org/wiki/Proxy_pattern
## Usage

Invoke `tmux-attacher` without any arguments to get an interactive prompt:

```sh
❯ tmux-attacher
Available Tmux sessions:
joy: 6 windows (created Sat Sep 23 21:30:54 2023) (attached)
work: 4 windows (created Tue Sep 19 11:29:54 2023) (attached)

a -- Attach to an existing session.
n -- Attach to a new session.
q -- Cancel.
What should we do? [a,n,q]: a
Which session should we attach to? joy
```

```sh
Available Tmux sessions:
joy: 6 windows (created Sat Sep 23 21:30:54 2023) (attached)
work: 4 windows (created Tue Sep 19 11:29:54 2023) (attached)

a -- Attach to an existing session.
n -- Attach to a new session.
q -- Cancel.
What should we do? [a,n,q]: n
How should we name the new session? foobar
```

Provide any arguments to delegate them to the underlying `tmux` command:

```sh
tmux-attacher [arguments]
```


## Installation

To install `tmux-attacher`, simply copy the script to somewhere on your `$PATH`. This script only depends on `tmux`.

Since it's backwards-compatible with `tmux`, it is safe to override it with an alias:

```sh
export alias tmux=tmux-attacher
```
## Authors

- [jpcenteno](https://www.github.com/jpcenteno) - [github.com/jpcenteno](https://www.github.com/jpcenteno)
