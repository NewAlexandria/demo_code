file input with lines
file input can contain blank lines and other detritus
session time at the end of each line
session time can be "lightning"
session name is the rest of the line (no numbers present)

event has a time
event has a type in range [session, lightning talk, networking event, lunchtime]

an array of Event objects

a schedule starts at 9am 
a scheudle has a networking event starting at 4pm to 5pm
a schedule has a lunchtime starting at 12pm
schedule is returned as an array of tracks (hashes)
