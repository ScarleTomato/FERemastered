import re, os


def reget(pattern, s):
  try:
    return re.search(pattern, s).group()
  except Exception as e:
    raise Exception(f'Could not find [{pattern}] in [{s}]')

def regetOrNone(pattern, s):
  try:
    return re.search(pattern, s).group()
  except Exception as e:
    # print(f'Could not find [{pattern}] in [{s}]')
    return None

class Tracer():
  currentStep = 0
  counts = {}

  def parseBuild(self, line):
    if 'Proceeding...Using spot' in line:
      plan = reget(r'Plan\d+', line)
      path = reget(r'Using spot \S+\(', line)
      print(f'{self.currentStep}: {plan} building at {path[11:-1]}')

  def parseAttacker(self, line):
    if 'Proceeding...Sending' in line:
      plan = reget(r'Plan\d+', line)
      self.counts[plan] = (self.counts.get(plan) or 0) + 1
      print(f'{self.currentStep}: {plan} beginning attack {self.counts[plan]}')

  def parseEvent(self, line):
    step = regetOrNone(r'^\d+\.\d+', line)
    if step:
      self.currentStep = step
    if '-Attacker' in line:
      self.parseAttacker(line)
    if '-BaseBuildMinimums' in line:
      self.parseBuild(line)

  def main(self, fn, follow = False):
    logfile = open(fn,"r")

    reading = True
    while follow or reading:
      line = logfile.readline()

      reading = line is not None

      if follow:
        while not line.endswith('\n'):
          line += logfile.readline()
      else:
        reading = line.endswith('\n')
      
      self.parseEvent(line)

if __name__ == '__main__':
  logdir = 'C:/Users/Mike/Documents/My Games/Battlezone Combat Commander/FE/logs/'
  lastlog = [x for x in os.listdir(logdir) if x.startswith('AIPLog_team_6')][-1]
  Tracer().main(logdir + lastlog)