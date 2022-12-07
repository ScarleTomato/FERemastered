import os, re, json, oyaml as yaml, shutil
from datetime import datetime
from collections import OrderedDict

def skip(f, n:int):
  for _ in range(n):
    f.readline()

def tabs(line):
  return re.search('\S', line).start()

def int24(s):
    i = int(s, 16)
    if i >= 2**23:
        i -= 2**24
    return i

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

class BZNObject(OrderedDict):

  def fromLines(self, lines):
    top = []
    # everything with a [#] is a list of dictionaries
    # if the dictionary has a single unnamed value, name it '_'
    # for ease, [GameObject] is also a list of one dictionary
    top.append(self)
    # the parent is the list that i'm adding into
    parents = [top]
    name = ''
    for line in lines:
      # get the current parent (the last one in the parents list)
      parent:list = parents[-1]
      # if line like 'key = value'
      if re.match(r'^\w+ = .*$', line):
        if not parent is top:
          # these lines always describe a top level element, so move to the top
          parent=top
          parents = [top]
        spl = line.split(' = ')
        top[0][spl[0]] = spl[1][:-1]
      # if line 'key =\r\n'
      if re.match(r'^\s*\S+ (\[\d+\] ){0,1}=$', line):
        indent = tabs(line)
        # if i've found a key with no indent, i'm back at the top
        if indent == 0:
          parent=top
          parents = [top]
        # if i've found a key with the same indent as the previous parent. i'm done with that parent. move up
        elif indent == parent[0]['indent']:
          parents.pop()
          parent = parents[-1]
        # get the name of this key
        name = '.' * indent + re.findall(r'\S+', line)[0]
        # if the [#] exists add a dot to the end of the name (for keepsies)
        if re.search(r'\[\d+\]', line):
          name += '#'
        # if this key already exists in the last element
        if parent[-1].get(name):
          # make a new element in this parent
          parent.append(OrderedDict())
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


class BZN(dict):

  def toJson(self):
    return json.dumps(flatten(self), indent=2)

  def toYaml(self):
    return yaml.dump(flatten(self), indent=2)

  def readHeader(self, f):
    headerlines = []
    line:str = f.readline()
    while not line.startswith('msn_filename'):
      headerlines.append(line)
      line = f.readline()
    # backup to the beginning of the last line
    f.seek(f.tell() - len(line) - 1)
    self['header'] = BZNObject().fromLines(headerlines)

  def readSimpleSection(self, f, end):
    lines = []
    line:str = f.readline()
    while line and not line.startswith(end):
      lines.append(line)
      line = f.readline()
    # backup to the beginning of the last line
    f.seek(f.tell() - len(line) - 1)
    return BZNObject().fromLines(lines)

  def readObjects(self, f):
    objectlines = []
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
    objects = []
    for lines in objectlines:
      objects.append(BZNObject().fromLines(lines))
    return objects

  def readPaths(self, f):
    pathlines = []
    skip(f, 3)
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
    paths = {}
    for lines in pathlines:
      path = BZNObject().fromLines(lines)
      paths[path['label']] = path
    return paths

  def fromFile(self, fn):
    with open(fn, 'r') as f:
      self['header'] = self.readSimpleSection(f, 'msn_filename')
      self['header2'] = self.readSimpleSection(f, '[GameObject]')
      self['objects'] = self.readObjects(f)
      # for o in self['objects']:
      #   out = o['seqno#'][0]['_'] + ':' + o['objClass'] + ':' + str(int24(o['seqno#'][0]['_'])) + ':'
      #   for key in o.keys():
      #     out += key[0]
      #   print(out)
      self['mid'] = self.readSimpleSection(f, '[AiMission]')
      self.readSimpleSection(f, '[AiPaths]') # ignore this stuff
      self['paths'] = self.readPaths(f)
      self['entered'] = self.readSimpleSection(f, 'PadData')
      self['footer'] = self.readSimpleSection(f, 'fakeline')

def toFile(o, path):
  print(f'saved to {os.path.basename(path)}')
  with open(path, 'w') as f:
    f.write(o)

def main(dir, inputfn):
  print(f'bzntojson reading {inputfn}')
  os.makedirs(dir + '/bak/', exist_ok=True)
  bakfn = inputfn + datetime.now().strftime('.%Y%m%d-%H%M')
  print(f'backed up to {bakfn}')
  shutil.copyfile(dir + inputfn, dir + '/bak/' + bakfn)
  bzn = BZN()
  bzn.fromFile(dir + inputfn)
  toFile(bzn.toJson(), dir + inputfn.replace('.bzn', '.json'))
  toFile(bzn.toYaml(), dir + inputfn.replace('.bzn', '.yaml'))

if '__main__' == __name__:
  dir = r'C:/Users/Mike/Documents/My Games/Battlezone Combat Commander/FE/addon/missions/Multiplayer/test/'
  main(dir, 'test.bzn')
  import objtopath, bznwriter
  # objtopath.main(dir, 'test.yaml')
  # bznwriter.main(dir, 'test_path.yaml')