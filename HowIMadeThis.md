# How I Made This

This is meant to be instructions for myself for the future,
not for other people to read.

## AutoHotkey

AutoHotkey is a Windows program that can run a sequence of key presses.
I found an R package that would have been easier, but PCSX2 wouldn't accept
it's key presses (e.g., Chrome would).
However, the keyboard presses from R can trigger the AutoHotkey scripts.

The general workflow:

* R figures out the sequences of buttons need to be pressed on the PS2 controller,
it writes these to an .ahk file.

* The command line is used to make this .ahk file active.

* R triggers the .ahk file.

* The .ahk file runs, doing all the key presses. When it is done, it writes a 
file. This whole time, R is in a for loop looking to see if this file has been
created. Once it finds the file, it knows that AHK is done so it continues,
usually repeating back to the first step.

Pitfalls:

* Button presses that are too long or too short will double click or
not click enough.

* R pressing the AHK shortcut would sometimes start a prior .ahk script, not
the most recent that was executed. I added `kill_all_ahk()` to ensure that
there is only one active at any time.

## PCSX2

Map keyboard to buttons:
A = D-pad left
S = D-pad down
D = D-pad right
W = D-pad up
U = Start
J = Square
K = X
L = Circle
I = Triangle

Always run at double speed.

## Nerfing existing players

The default players cannot be deleted. If I just move them to the Free Agent
list, they will stay at the top, and any new players that I create will
appear in this list in some arbitrary place based on talent (they sort by talent
best to worst).  This would make it hard to find the guy my script created.
Even worse, it is limited to only showing 1,000 free agents, so mine may not
appear on the list at all.

The only solution is to "nerf" (meaning to make weaker) these players.
My script goes through and sets most of the key attributes down to their
minimum values. 
This ensures that when I created new players later, they should always show
up as the best player on the list (top of the list).

This process only has to be run once, but it is time consuming.
It takes about a minute per player, so over 50 hours to do them all,
and my program often gets stuck for an unknown reason.

## Creating players

## Getting player attributes
