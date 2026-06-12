#!/usr/bin/env python3
from datetime import datetime, timedelta
import argparse

MONDAY, TUESDAY, WEDNESDAY, THURSDAY, FRIDAY, SATURDAY, SUNDAY = range(7)
now = datetime.now()
#debug now
# now = now.replace(
#   day = 13,
#   hour = 23
# )

cur_weekday = now.weekday()

def past_cutoff(cutoff: int=19) -> bool:
    return now.hour >= cutoff
    
def target_weekday():
    if (cur_weekday == SATURDAY and past_cutoff()):
        return TUESDAY
    elif cur_weekday in (WEDNESDAY, THURSDAY, FRIDAY, SATURDAY):
        return SATURDAY
    elif (cur_weekday == TUESDAY and past_cutoff()):
        return SATURDAY
    else: 
        return TUESDAY


days_ahead = (target_weekday() - now.weekday() + 7) % 7
target = now.replace(hour=19, minute=0, second=0, microsecond=0) + \
         timedelta(days=days_ahead)

def seconds_until():
    delta = target - now.replace(microsecond=0)
    return delta.total_seconds()

def opening_time():
    print(target.strftime('%A %B %d, %H:%M')) 


# allow for more manageable numbers
total_minutes = int(seconds_until() // 60 + 1)
days, remainder = divmod(total_minutes, 1440)
hours, minutes = divmod(remainder, 60)

def time_until():
    parts = []
    if days:
        parts.append(f"{days} {'day' if days == 1 else 'days'}")
    if hours:
        parts.append(f"{hours} {'hour' if hours == 1 else 'hours'}")
    if minutes:
        parts.append(f"{minutes} {'minute' if minutes == 1 else 'minutes'}")
    return(print(", ".join(parts), sep='',))
# print(target_weekday())
# print(now)
# print(past_cutoff())
parser = argparse.ArgumentParser()
parser.add_argument("type", type=str, help="time or until")
args = parser.parse_args()

if args.type == "time":
    opening_time()
elif args.type == "until":
    time_until()
