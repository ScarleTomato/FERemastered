import time
import os, re

def follow(thefile):
    '''generator function that yields new lines in a file
    '''
    # seek the end of the file
    thefile.seek(0, os.SEEK_END)
    
    # start infinite loop
    while True:
        # read last line of file
        line = thefile.readline()        # sleep if file hasn't been updated
        if not line:
            time.sleep(0.1)
            continue

        yield line

def main(fn):
    logfile = open(fn,"r")
    loglines = follow(logfile)    # iterate over the generator
    laststepplan = ''
    laststep = 0
    lastaction = '-Plan0-'
    for line in loglines:
      # grab the first 4 characters of the line
      step = line[0:4]
      # check if it's one of the step descriptions
      if step.isdigit():
        # parse the step
        step = int(step)
        # if starting a new step
        if step > laststep:
          # save this as the last step
          laststep = step
          # find out which plan we decided on
          try:
            stepplan = re.search('-Plan\\d+-', lastaction).group()
          except:
            print(f'Couldn\'t find \'Plan\' in line {lastaction}')
            stepplan = laststepplan
          # if this plan is different from the decision in the last step, print
          if(stepplan != laststepplan):
            print(lastaction)
          # save this Plan as the new previous decision
          laststepplan = stepplan
        # save this action as the last found action
        lastaction = line

if __name__ == '__main__':
  logdir = 'C:/Users/Mike/Documents/My Games/Battlezone Combat Commander/FE/logs/'
  lastlog = [x for x in os.listdir(logdir) if x.startswith('AIPLog_team_6')][-1]
  print(f'scanning {lastlog}')
  main(logdir + lastlog)