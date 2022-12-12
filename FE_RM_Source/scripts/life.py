from math import *
import curses, time, os, re

def statusnum(line:str):
  if 'already have' in line or 'Trying to find pool' in line or 'Could not find scrap' in line or 'Proceeding...Found' in line:
    return 3
  elif 'Halting' in line:
    return 1
  else:
    return 0

def regetOrNone(pattern, s):
  try:
    return re.search(pattern, s).group()
  except Exception as e:
    return None
    # raise Exception(f'Could not find {pattern} in [{s}]', e)

def main(win, fn):
  global stdscr
  stdscr = win

  my_bg = curses.COLOR_BLACK

  stdscr.nodelay(1)
  stdscr.timeout(0)

  if curses.has_colors():
    curses.init_pair(1, curses.COLOR_RED, my_bg)
    curses.init_pair(2, curses.COLOR_MAGENTA, my_bg)
    curses.init_pair(3, curses.COLOR_GREEN, my_bg)
  
  plans = {}
  logfile = open(fn,"r")
  logfile.seek(0, os.SEEK_END)
  while True:
    stdscr.addstr(1, 0, fn)
    # read last line of file
    line = logfile.readline()

    while not line.endswith('\n'):
      line += logfile.readline()

    # sleep if file hasn't been updated
    if not line:
        time.sleep(0.1)
        continue
    
    # get path
    if 'Plan' in line:
      match = re.search('-Plan\\d+-', line)
      if match:
        match = match.group()[5:-1]
        if match.isdigit():
          plan = int(match)
          plans[plan] = str(statusnum(line)) + '|' + line
    # print the paths
    stdscr.attrset(curses.color_pair(0))
    step = 0.0
    for k, v in plans.items():
      linestep = float(regetOrNone('\\d+\\.00', v) or '0.0')
      step = linestep if linestep > step else step
      if(k < curses.LINES - 1):
        if curses.has_colors():
          stdscr.attrset(curses.color_pair(2 if linestep < step else int(v[0])))
        stdscr.addstr(k + 1, 0, v[2:])
        if curses.has_colors():
          stdscr.attrset(curses.color_pair(0))
    stdscr.refresh()

if __name__ == '__main__':
  logdir = 'C:/Users/Mike/Documents/My Games/Battlezone Combat Commander/FE/logs/'
  lastlog = [x for x in os.listdir(logdir) if x.startswith('AIPLog_team_6')][-1]
  print(f'scanning {lastlog}')
  time.sleep(2)
  curses.wrapper(main, logdir + lastlog)
