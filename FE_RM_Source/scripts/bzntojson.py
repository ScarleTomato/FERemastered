import re

def skip(f, n:int):
  for _ in range(n):
    f.readline()

def tabs(line):
  return re.search('\S', line).start()

class BZNObject:
  fields = {}

  def fromStaticLines(lines):
    top = {}
    for v in [ 'objClass', 'seqno', 'team', 'isUser', 'objAddr', 'abandoned'
             , 'curAmmo', 'maxAmmo', 'addAmmo', 'curPilot', 'illumination'
             , 'name', 'saveFlags', 'isVisible', 'EffectsMask', 'isSeen'
             , 'groupNumber', 'priority', 'what', 'who', 'where', 'param'
             , 'aiProcess', 'independence']:
      findVal(lines, v, top)
      findTransform(lines, top)
      findEuler(lines, top)
    obj = BZNObject()
    obj.fields = top
    return obj

  def fromLines(lines):
    top = {}
    parents = [top]
    name = ''
    tab = -1
    for line in lines:
      # get the current parent
      parent = parents[-1]
      # if line like 'key = value'
      if re.match(r'^\w+ = \w+$', line):
        if not parent is top:
          # these lines always describe a top level element
          parent=top
          parents = [top]
        spl = line.split(' = ')
        top[spl[0]] = spl[1][:-1]
      # if line 'key =\r\n'
      if re.match(r'\s*\S+ (\[\d+\] ){0,1}=', line):
        indent = tabs(line)
        # if i've found a key with no indent, i'm back at the top
        if indent == 0:
          parent=top
          parents = [top]
        # if i've found a key with the same indent as the previous parent. i'm done with that parent. move up
        elif indent == parent['indent']:
          parents.pop()
          parent = parents[-1]
        # get the name of this key
        name = re.findall(r'\S+', line)[0]
        # add this key to the current parent
        parent[name] = [{'indent':indent}]
        # and then set this as the new parent
        parents.append(parent[name][0])
        # if less indented, move up one parent
        # if tabs(line) < tab:
        #   parents.pop()
      # if line is 'value'
      if re.match(r'^[\w\.\-\+]+$', line):
        # done with this parent, pop it off
        parents.pop()['_'] =  line[:-1]

      # if re.search('\S', a).start() > tab:

      # if line is like 'name [#] = ', set this as the new parent, check the tab
      # if line is like 'name [#] = ', set this as the new parent
    obj = BZNObject()
    obj.fields = top
    return obj


class BZN:
  header = []
  footer = []
  objectlines = []
  objects= []
  pathlines = []

  def readHeader(self, f):
    line:str = f.readline()
    while not line.startswith('size'):
      self.header.append(line)
      line = f.readline()
    # backup to the beginning of the last line
    f.seek(f.tell() - len(line) - 1)

  def readFooter(self, f):
    line:str = f.readline()
    while line:
      self.footer.append(line)
      line = f.readline()

  def readObjects(self, f):
    skip(f, 2)
    line:str = f.readline()
    while not line.startswith('groupTargets'):
      if line.startswith('[GameObject]'):
        object = []
        self.objectlines.append(object)
      else:
        object.append(line)
      line = f.readline()
    # backup to the beginning of the last line
    f.seek(f.tell() - len(line) - 1)

  def readPaths(self, f):
    skip(f, 7)
    line:str = f.readline()
    while not line.startswith('hasEntered'):
      if line.startswith('name = AiPath'):
        path = []
        self.pathlines.append(path)
      else:
        path.append(line)
      line = f.readline()
    # backup to the beginning of the last line
    f.seek(f.tell() - len(line) - 1)
  
  def parseObjects(self):
    for lines in self.objectlines:
      self.objects.append(BZNObject.fromLines(lines))

  def fromFile(self, fn):
    with open(bzn, 'r') as f:
      self.readHeader(f)
      self.readObjects(f)
      self.groupTargets = f.readline()
      self.dllName = f.readline()
      self.readPaths(f)
      self.readFooter(f)
    self.parseObjects()
    # self.parsePaths()

bzn = r'C:\Users\Mike\Documents\My Games\Battlezone Combat Commander\FE\addon\missions\Multiplayer\test\test.bzn'
BZN().fromFile(bzn)