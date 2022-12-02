import re, json

def skip(f, n:int):
  for _ in range(n):
    f.readline()

def tabs(line):
  return re.search('\S', line).start()

class BZNDecoder(json.JSONEncoder):
  def default(self, obj):
    print('def')
    if isinstance(obj, list) and len(obj) == 1:
      d = obj[0]
      if isinstance(d, dict):
        return d['_']
    return json.JSONEncoder.default(self, obj)

def flatten(obj):
  if isinstance(obj, list):
    if len(obj) == 1 and isinstance(obj[0], dict) and len(obj[0]) <= 2:
      return obj[0].get('_')
    else:
      ret = []
      for sub in obj:
        ret.append(flatten(sub))
      return ret
  if isinstance(obj, dict):
    ret = {}
    for k, v in obj.items():
      if not k == 'indent':
        ret[k] = flatten(v)
    return ret
  return obj

class BZNObject(list):

  def fromLines(self, lines):
    top = self
    # everything with a [#] is a list of dictionaries
    # if the dictionary has a single unnamed value, name it '_'
    # for ease, [GameObject] is also a list of one dictionary
    top.append({})
    # Keep track of which element we're adding to
    listndx = 0
    # the parent is the list that i'm adding into
    parents = [top]
    name = ''
    for line in lines:
      # get the current parent (the last one in the parents list)
      parent:list = parents[-1]
      # if line like 'key = value'
      if re.match(r'^\w+ = \w+$', line):
        if not parent is top:
          # these lines always describe a top level element, so move to the top
          parent=top
          parents = [top]
          listndx = 0
        spl = line.split(' = ')
        top[0][spl[0]] = spl[1][:-1]
      # if line 'key =\r\n'
      if re.match(r'^\s*\S+ (\[\d+\] ){0,1}=$', line):
        indent = tabs(line)
        # if i've found a key with no indent, i'm back at the top
        if indent == 0:
          parent=top
          parents = [top]
          listndx = 0
        # if i've found a key with the same indent as the previous parent. i'm done with that parent. move up
        elif indent == parent[0]['indent']:
          parents.pop()
          parent = parents[-1]
          listndx = 0
        # get the name of this key
        name = re.findall(r'\S+', line)[0]
        # if this key already exists in the last element
        if parent[-1].get(name):
          # make a new element in this parent
          parent.append({})
        # add this key to the last element in current parent
        parent[-1][name] = [{'indent':indent}]
        # and then set this as the new parent
        parents.append(parent[-1][name])
      # if line is 'value'
      if re.match(r'^[\w\.\-\+]+$', line):
        # done with this parent, pop it off
        parents.pop()[-1]['_'] = line[:-1]

      # if re.search('\S', a).start() > tab:

      # if line is like 'name [#] = ', set this as the new parent, check the tab
      # if line is like 'name [#] = ', set this as the new parent
    return self


class BZN:
  header = []
  footer = []
  objects = []
  paths = []

  def readHeader(self, f):
    line:str = f.readline()
    while not line.startswith('size'):
      self.header.append(line)
      line = f.readline()
    # backup to the beginning of the last line
    f.seek(f.tell() - len(line) - 1)
    self.header = BZNObject

  def readFooter(self, f):
    line:str = f.readline()
    while line:
      self.footer.append(line)
      line = f.readline()

  def readObjects(self, f):
    objectlines = []
    skip(f, 2)
    line:str = f.readline()
    while not line.startswith('groupTargets'):
      if line.startswith('[GameObject]'):
        object = []
        objectlines.append(object)
      else:
        object.append(line)
      line = f.readline()
    # backup to the beginning of the last line
    f.seek(f.tell() - len(line) - 1)
    for lines in objectlines:
      self.objects.append(BZNObject().fromLines(lines))

  def readPaths(self, f):
    pathlines = []
    skip(f, 7)
    line:str = f.readline()
    while not line.startswith('hasEntered'):
      if line.startswith('name = AiPath'):
        path = []
        pathlines.append(path)
      else:
        path.append(line)
      line = f.readline()
    # backup to the beginning of the last line
    f.seek(f.tell() - len(line) - 1)
    for lines in pathlines:
      self.paths.append(BZNObject().fromLines(lines))

  def fromFile(self, fn):
    with open(fn, 'r') as f:
      self.readHeader(f)
      self.readObjects(f)
      self.groupTargets = f.readline()
      self.dllName = f.readline()
      self.readPaths(f)
      self.readFooter(f)
    # self.parsePaths()

fn = r'C:\Users\Mike\Documents\My Games\Battlezone Combat Commander\FE\addon\missions\Multiplayer\test\toparse.bzn'
bzn = BZN()
bzn.fromFile(fn)
with open(r'C:\Users\Mike\Documents\My Games\Battlezone Combat Commander\FE\addon\missions\Multiplayer\test\test.json', 'w') as f:
  f.write(json.dumps(bzn.paths, indent=2))
with open(r'C:\Users\Mike\Documents\My Games\Battlezone Combat Commander\FE\addon\missions\Multiplayer\test\flat.json', 'w') as f:
  f.write(json.dumps(flatten(bzn.paths), indent=2))