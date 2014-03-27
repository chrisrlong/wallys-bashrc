wallys-bashrc
=============

wally's custom bashrc.  Profile for bash, with all the things you need.  Plus some.

## What is it?

It's a bash script, suitable for using as a .bashrc (to be pulled in when your shell opens).

## What does it do?

Makes your bash look epic.

No seriously.  It's intended to be both functional and aesthetically pleasing.

### It has a floating status bar ...

#### ... that gives you a clock

Yeah.  Simple things eh?

Auto refreshes, real-time.  Sits at the top left of your terminal.

#### ... that tells you your CPU load

And gives you a little graph.  Sits next to the clock.

#### ... that shows you who's logged on

Next to the CPU graph.

### It remembers when you ran previous commands, and how long they took

Because everyone ends up copying a terminal output, and then forgetting when each command was ran.

### It's colours let you know if something worked, or if it failed

Excel calls it conditional formatting!

### And it knows who you are.  Yes, you.  MrX, escalated to root via sudo via SSH from a remote host.

Yeah.  You.

### And it should work on all *nix.

Coded on OSX.  Tested on Debian, CentOS.

## All this without locking up your shell

By using a subprocess and some signal abuse - it does all this without lagging your shell.  (Well, if you're on a slow connection - it'll lag.  But not, say, over SSH on a half-decent broadband connection.)

## It's here for you to enjoy.

Guys, girls:  please take it, extend it, feel very free to suggest changes and extensions.

