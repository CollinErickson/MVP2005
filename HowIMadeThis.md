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

## Steps for redoing rosters in the future

1. Get rosters csv from OOTP.

1. Update the stat map csv.

1. Update the stat override csv.

1. Run `./r/ootp.R` to update MVPdf. Make sure it runs the last section
of code that saves the csv.

1. Start MVP Baseball 2005 in PCSX2.
Press tab so that it runs at double speed.
Make sure the default team is set to Boston Red Sox (this is true
with no profile, or the favorite team can be set to this).
Maybe turn off all songs in the jukebox so that it doesn't keep saying
the song name in the bottom right corner.
Load the Zero2 roster file.
(Or Zero roster file, then move all editable players on MLB rosters to
free agents.) 
If using a computer other than my HP Pavilion, you will likely need to edit the
R functions that take screenshots to see what PCSX2 is showing.

1. Make sure that created_players.csv and
create_rosters_from_zero_progress.csv have been deleted.


1. Run the code at the bottom of `./r/make_rosters_from_zero.R`. This takes
about 50 hours. Use ctrl+shift+2 to interrupt occasionally to save to roster
file. 
Remaining bugs:
(1) It gave a bunch of Windows errors that it wasn't able
to access a file. Probably either when it updates created_players.csv or
create_rosters_from_zero_progress.csv. It didn't seem to be an actual issue.
The error only started showing up for the last handful of orgs.
My best guess is that created_players.csv took too long to save as it got 
longer. Maybe I should add a sleep option when it's longer than 1,300 players.
(2) I gave each team 27 pitchers and 39 hitters. This was too many, as later
teams ended up with maybe a pitcher or two less than, and only ~29 hitters.

1. Look through for players that were made incorrectly.
I don't know why, but three batters on the Yankees were made incorrectly,
the stats were clearly wrong.
Also look for players that are clearly too good. Brett Phillips was one of the
best players on the Yankees, but he had stats as a batter, but now he switched
to be a pitcher. I just deleted him.

