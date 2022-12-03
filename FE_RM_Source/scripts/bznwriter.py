import json, io, oyaml as yaml

"{0:#0{1}x}".format(42,10)[2:].upper()

def premat(j):
  # fix size for objects
  j['header2']['size#'] = len(j['objects'])
  # readdress all objects and paths
  address = 1
  for o in j['objects']:
    o['objAddr'] = "{0:#0{1}x}".format(address, 10)[2:].upper()
    # set leading bit if object DOES NOT have a label
    o['seqno#'] = hex(5 * address + 2)[2:] if o.get('label') else hex(5 * address + 2 + 0x800000)[2:]
    address += 1
  j['header2']['seq_count#'] = 5 * address + 2
  for o in j['paths']:
    o['sObject'] = "{0:#0{1}x}".format(address, 10)[2:].upper()
    # fix path len indicator, and point count
    o['size#'] = len(o['label'])
    o['pointCount#'] = len(o['points#'])
    address += 1

class objectview(object):
    def __init__(self, d):
        self.__dict__ = d

def writeValue(f:io.TextIOWrapper, key:str, value, parent = None):
  indent = len(key)-len(key.lstrip('.'))
  key = key.lstrip('.')
  if value is None:
    f.writelines([f'{" " * indent}{key} =\n'])
  elif isinstance(value, list):
      if key.endswith('#'):
        f.writelines([f'{" " * indent}{key.rstrip("#")} [{len(value)}] =\n'])
      else:
        f.writelines([f'{" " * indent}{key.rstrip("#")} =\n'])
      for o in value:
        for k, v in o.items():
          writeValue(f, k, v, o)
  elif isinstance(value, dict):
    return
  else:
    if 'navSlot#' == key:
      # if we're writing an nav point, name shows up a second time directly before the navSlot
      f.writelines([f'name = ', f'{parent["name"]}\n'])
    if key.endswith('#'):
      f.writelines([f'{" " * indent}{key.rstrip("#")} [1] =\n', f'{value}\n'])
    else:
      f.writelines([f'{" " * indent}{key} = {value}\n'])

def writeBZN(json, fn):
  premat(json)
  with open(fn, 'w') as f:
    for k, v in json['header'].items():
      writeValue(f, k, v)
    for k, v in json['header2'].items():
      writeValue(f, k, v)
    for o in json['objects']:
      f.writelines([f'[GameObject]\n'])
      for k, v in o.items():
        writeValue(f, k, v, o)
    for k, v in json['mid'].items():
      writeValue(f, k, v)
    f.writelines(['[AiMission]\n'
    ,'[AOIs]\n'
    ,'size [1] =\n'
    ,'0\n'
    ,'[AiPaths]\n'
    ,'count [1] =\n'
    ,f'{len(json["paths"])}\n'
    ])
    for o in json['paths']:
      f.writelines([f'name = AiPath\n'])
      for k, v in o.items():
        writeValue(f, k, v)
    for k, v in json['entered'].items():
      writeValue(f, k, v)
    f.writelines(['ownerObj [1] =\n'
    ,'0\n'
    ,'ownerObj [1] =\n'
    ,'0\n'
    ])
    for k, v in json['footer'].items():
      writeValue(f, k, v)

# class JDEC(json.JSONDecoder):
#     def __init__(self, *args, **kwargs):
#         json.JSONDecoder.__init__(self, object_hook=self.object_hook, *args, **kwargs)
#     def object_hook(self, dct):
#       if isinstance(dct, dict):
#         return objectview(dct)
#       return dct


fin = r'C:\Users\Mike\Documents\My Games\Battlezone Combat Commander\FE\addon\missions\Multiplayer\test\test_path.yaml'
fout = r'C:\Users\Mike\Documents\My Games\Battlezone Combat Commander\FE\addon\missions\Multiplayer\test\test.bzn'
# with open(fin, 'r') as f:
#   writeBZN(json.load(f), fout)
with open(fin, 'r') as f:
  writeBZN(yaml.load(f, Loader=yaml.Loader), fout)