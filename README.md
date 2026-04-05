
# MVP Baseball 2025 (PS2)

<!-- badges: start -->
<!-- badges: end -->

This GitHub repo provides memory cards that have updated rosters
for MVP Baseball 2005 on PS2.

This will only work for the PS2 version of MVP Baseball 2005, not for other
platforms or games.

## Instructions (advanced)

Download the latest memory card from [Releases page](https://github.com/CollinErickson/MVP2005/releases/).
The memory card is a ".ps2" file that contains a roster file that you should load.

## Instructions (beginner)

### Using PCSX2 emulator for Windows/Linux:

1. Download and install PCSX2.

2. Legally acquire the PS2 BIOS and a copy of MVP Baseball 2005 for PS2.
Put these both in the proper folders. If you need help, Google it or post
in the PCSX2 forums.

3. Download the latest memory card file from the [Releases page](https://github.com/CollinErickson/MVP2005/releases/).
Look at the most recent release, and download the ".ps2" file, which is the 
memory card.
Put this file in the memory card folder for PCSX2. In PCSX2, open the memory
card settings, and put the memory card in one of the two slots.

4. Start the game in PCSX2. Navigate to the Rosters option and then Load Rosters.

### Using PS2

I haven't tried this. If you get this to work, let me know what steps you
did and I'll put it here.

Reddit user u/FettryZepin
[shared the steps they used to get this working on PS2](https://www.reddit.com/r/baseball/comments/1k7orbn/comment/n228jcf/):

> 1. Download your roster save then download mymc, a PS2 Memory Card Image Utility
>
> 2. Open the tool and open the custom roster within it, you should see the MVP save icon in the window
>
> 3. Export the save as a .psu (it will already be set to this)
>
> 4. Put it on a flash drive and plug that into your PS2 console
>
> 5. Open up ULaunchELF and copy the .psu file from the /mass window
>
> 6. Go onto your desired memory card on ULaunchELF and do a psuPaste
>
> 7. Load up MVP 2005 and go onto the roster page, then load the roster up. Then save it anew under whatever name you like. Then load that new roster in

## FAQs

### I'm confused. What am I supposed to do?

See the Instructions (Beginner) above. You don't need all the files in this
repo, you only download a single memory card file from the 
[Releases page](https://github.com/CollinErickson/MVP2005/releases/).

### How can I contribute?

If you see any issues, report it on the
[Issues tab](https://github.com/CollinErickson/MVP2005/issues)
above.

If you are enjoying it, let me know by starring this repo or sending me an 
email at collinberickson (at) gmail (dot) com.
Also please share with your friends!

Some help could be used to make better attributes, but it's not straightforward.
If you want to help, you can email me.

Join the Discord to contribute to the discussion and feedback:
https://discord.gg/qajkE965AD

### Will there be future updates?

I can easily rerun the code to remake the updated rosters, but I will likely
only do so if there is demand since it takes about 50 hours of computer time.
Email me or watch this repo so that I know
you are interested.

### How can I be notified about future updates?

On this page, click on "Watch", then "Custom", then check "Releases" and 
click apply. You should receive an email when there is a new release.
(I have never actually tried this, correct me if I'm wrong.)

I created a Discord that I will also post in when there are future updates:
https://discord.gg/qajkE965AD. Please join for updates and discussion.

### Why are the players from 2005 on the minor league teams with horrible stats?

The old players can't be deleted. The best option is to make them horrible
so that they fill up the AA/A. Only 25 players can be created, and there are a
limited number of players that can be edited, so I could only create about 66
players per org, which requires some of the old players to fill out the rosters.
I wanted to do 100 players per org, but it's not possible without somehow
modding the game file.

## Known issues

* Pitchers are a little too good relative to position players. It's better
than it used to be.

* Player heights and weights don't match reality. This is because you cannot
edit these for any players, only the 25 players that can be created. I could
change the creation order to try to match heights/weights, but that is more
work than it's worth.

* My data source doesn't have 2-seamers, only sinkers, so I randomly converted
half of them to be 2-seam FB (need a better data source)

* Many pitchers are missing pitches

* No rare pitches (a few pitchers should have knuckleball, screwball, forkball)

* Better calibration of the attributes. E.g., maybe there are too many/few
hitters with contact v LHP over 90. (Need help identifying these.)

* Better attribute values (a lot seem weird). Some players are too good/bad.

* Players at the wrong level (MLB on AAA, etc). The game optimized the roster
for each team, I'm not going to manually fix any of these.

## Screenshots

### Best and worst teams

The Phillies are the best rated team, the White Sox are the worst rated team.
Neither are surprising. The Phillies probably shouldn't be the best team since
the game overvalues speed and fielding, but they're still really good.

![](images/demo/20260317/best_and_worst_teams.png)

### Top players in the dynasty fantasy draft

The top players look pretty reasonable.
Pitchers may be a bit too high relative to position players, with 8 of the top
9 being pitchers.
I will look at lowering pitcher ratings a bit for the next update.

![](images/demo/20260317/fantasy_draft_top_players.png)

### First round in a dynasty fantasy draft

Chapman at 4 and Ballesteros at 8 are crazy.

![](images/demo/20260317/fantasy_draft_review.png)

![](images/demo/20260317/fantasy_draft_review_11_20.png)

![](images/demo/20260317/fantasy_draft_review_21_30.png)

### Dodgers batting order

Once again I have included two versions of Ohtani:
Shohei Ohtani the SP, and Ohtani Shohei the RF.
Two way players don't really work in this game, so this seems like the best
solution.
The downside now that both Ohtanis can be on the field at the same time.
DH is not an option for the primary position.
Maybe I should make Ohtani Shohei horrible at defense so he'll only be played at
DH?

![](images/demo/20260317/dodgers_batting_order.png)

### Mariners rotation

The Mariners rotation is very good.

![](images/demo/20260317/mariners_rotation.png)

### Cubs defense in game

Pete CrowArms is the best name resulting from the character limit.

![](images/demo/20260317/cubs_defense_before_game.png)

### Braves lineup in game

This lineup is loaded.

![](images/demo/20260317/braves_lineup_before_game.png)
