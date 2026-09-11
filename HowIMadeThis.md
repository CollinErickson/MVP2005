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

1. Update the stat map csv (in Drive and download to data folder).

1. Update the stat override csv (in Drive and download to data folder).

1. Update the top prospects list by updating `./r/MLBprospects.R`.

1. Update the 40 man lists by updating `./r/bbref_40manrosters.R`
and `./r/MLB_40manrosters`.

1. Update the people csv by updating `./r/get_people_files.R`.

1. Update the affiliate teams for each org if needed.
To check if needed, you can run the next step (`./r/ootp.R`),
it should give an error
if it needs to be fixed.
To fix team not having a matching org you need to update
  `./data/ootp_team_to_org_map.csv`:
    - Run ```ootpdf |> filter(team_id != 0) |> transmute(team_id, `Team Name`, new_org='') |> unique() |> readr::write_csv("./data/ootp_team_to_org_map.csv")```
    - Open that csv in a spreadsheet editor.
    - Go through the list of teams. Every time the team is for a new org, put a 1 in the last column.
        - The first row should be a 1.
        - Most are obvious, but many aren't. You probably need to look up minor league teams to check their parent org.

    To fix a team not having a level, you need to update
    `./data/ootp_league_to_level_map.csv`. (Add more details here if that happens.)

1. Run `./r/ootp.R` to update MVPdf. First you have to change the input OOTP
data file name at the top. Make sure it runs the last section
of code that saves the csv. Check for errors: make sure that recently traded
players are on correct team, make sure that best players look right, check for
best players that won't get created (e.g., Roki Sasaki wouldn't have been
created).

1. Change the csv file to read in in `./r/readcsv.R`.

1. Make sure that created_players.csv and
create_rosters_from_zero_progress.csv have been deleted.

1. Copy memcards/misc/MVP05Rosters-Zero.ps2, replace "Zero" with "YYYYMMDD"
using the date of the csv file. Move this to the PCSX2/memcards folder.
In PCSX2 unload all memcards, load the new memcard into the first slot.

1. Start MVP Baseball 2005 in PCSX2.
The window should be fully expanded, but not full screen.
Press tab so that it runs at double speed.
PCSX2 should be at 2x resolution in graphics settings.
Make sure red shift app (f.lux) won't make screen too red, turn temp to 2600k?
Make sure the default team is set to Boston Red Sox (this is true
with no profile, or the favorite team can be set to this).
Maybe turn off all songs in the jukebox so that it doesn't keep saying
the song name in the bottom right corner.
Load the Zero2 roster file.
If using a computer other than my HP Pavilion, you will likely need to edit the
R functions that take screenshots to see what PCSX2 is showing!


1. Save a new roster file named YYYYMMDD. Run the code at the bottom of `./r/make_rosters_from_zero.R`. This takes
about 50 hours. Use ctrl+shift+2 to interrupt occasionally to save to roster
file. 
It automatically saves before starting each org and puts the two csv progress
files and ps2 file in data/progress_backups.
If it does crash and unable to continue, (1) find the latest progress_backups,
(2) copy created_players.csv and create_rosters_from_zero_progress.csv 
and put them into data/,
(3) copy the ps2 file back to the PCSX2 folder (you actually don't need to
if it is the most recent backup) and load that roster file,
and (4) continue as before.
Remaining bugs:
    1. It gave a bunch of Windows errors that it wasn't able
to access a file. Probably either when it updates created_players.csv or
create_rosters_from_zero_progress.csv. It didn't seem to be an actual issue.
The error only started showing up for the last handful of orgs.
My best guess is that created_players.csv took too long to save as it got 
longer. Maybe I should add a sleep option when it's longer than 1,300 players.
    1. I gave each team 27 pitchers and 39 hitters. This was too many, as later
teams ended up with maybe a pitcher or two less than, and only ~29 hitters.
    1. Hitting miss rate is backwards. You can tell since pitchers are 99/99 on
fastball, then 0/0 for curveball and slider. I already fixed
this in the statmap file, so it should be good for next with no additional work.
    1. Pitchers are a bit better than hitters (8/29/2025). I don't have a good
    idea of what should be adjusted.

1. Look through for players that were made incorrectly.
I don't know why, but three batters on the Yankees were made incorrectly,
the stats were clearly wrong.
Also look for players that are clearly too good. Brett Phillips was one of the
best players on the Yankees, but he had stats as a batter, but now he switched
to be a pitcher. I just deleted him.

1. Save rosters to memory card. Delete any other files on the memory card.
Save memory card to `./memcards/release`.
Update the screenshots and text in the README.md file
(including last update date), then build the HTML file.
Commit and push.

1. Tag the release on GitHub with the new memory card file. Make sure the .ps2
file is added to the release.

1. Share online (Reddit and Discord).
