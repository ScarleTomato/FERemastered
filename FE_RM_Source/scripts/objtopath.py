import os, oyaml as yaml
from copy import deepcopy

teams = {'102':'6', '119':'7', '136':'8'}
labels = {
    'ibrecy': 'Recycler_'
  , 'ibarmo': 'armory_edf_'
  , 'ibbomb': 'bomber_edf_'
  , 'ibcbun': 'bunker_edf_'
  , 'ibfact': 'factory_edf_'
  , 'ibsbay': 'sbay_edf_'
  , 'ibtcen': 'tech_edf_'
  , 'ibtrain': 'training_edf_'
  , 'ibpgen': 'pgen#_edf_'
  , 'ibgtow': 'gtow#_'
  , 'fbrecy': 'Recycler_'
  , 'fbantm': 'antm_scion_'
  , 'fbstro': 'stro_scion_'
  , 'fbspir': 'base_spire#_scion_'
  , 'fbdowe': 'dowe_scion_'
  , 'fbkiln': 'kiln_scion_'
  , 'fbjamm': 'jamm_scion_'
}

toRemove = ['fblung', 'ipdrop', 'fbrecy']

def toPathMarker(label, x, z, y = 0):
  # make an object (apserv?) here that we can see in-game
  return {
          "objClass": "apserv",
          "seqno#": "0",
          "team#": "0",
          "label": "pathMarker",
          "isUser#": "false",
          "objAddr": "0",
          "transform#": [
            {
              "..right.x#": "1.00000000e+00",
              "..right.y#": "0.00000000e+00",
              "..right.z#": "0.00000000e+00",
              "..up.x#": "0.00000000e+00",
              "..up.y#": "1.00000000e+00",
              "..up.z#": "0.00000000e+00",
              "..front.x#": "0.00000000e+00",
              "..front.y#": "0.00000000e+00",
              "..front.z#": "1.00000000e+00",
              "..posit.x#": '{:.8e}'.format(float(x)),
              "..posit.y#": '{:.8e}'.format(float(y)),
              "..posit.z#": '{:.8e}'.format(float(z)),
            }
          ],
          "illumination#": "1.00000000e+00",
          "euler": [
            {
              ".mass#": "1.25000146e+04",
              ".mass_inv#": "7.99999034e-05",
              ".v_mag#": "0.00000000e+00",
              ".v_mag_inv#": "1.00000002e+30",
              ".I#": "9.37501797e+04",
              ".k_i#": "1.06666466e-05",
              ".v#": [
                {
                  "..x#": "0.00000000e+00",
                  "..y#": "0.00000000e+00",
                  "..z#": "0.00000000e+00"
                }
              ],
              ".omega#": [
                {
                  "..x#": "0.00000000e+00",
                  "..y#": "0.00000000e+00",
                  "..z#": "0.00000000e+00"
                }
              ],
              ".Accel#": [
                {
                  "..x#": "0.00000000e+00",
                  "..y#": "0.00000000e+00",
                  "..z#": "0.00000000e+00"
                }
              ]
            }
          ],
          "name": label,
          "saveFlags#": "108",
          "isVisible#": "65535",
          "EffectsMask#": "65535",
          "isSeen#": "0",
          "groupNumber#": "0",
          "undefaicmd": None,
          "priority#": "0",
          "what": "00000000",
          "who#": "0",
          "where": "00000000",
          "param#": "0",
          "aiProcess#": "false",
          "independence#": "1"
        }

def newpath(label, x, z):
  return {
          'sObject': 0
        , 'size#': 0
        , 'label': label
        , 'pointCount#': 0
        , 'points#': [{
            '..x#': '{:.8e}'.format(float(x))
          , '..z#': '{:.8e}'.format(float(z))
        }]
        , 'pathType': '00000000'
      }

def objtopath(top, ignoreMarkers = True):
  newobjects = []
  for o in top['objects']:
    # if this is a path marker, make a path from it
    if not ignoreMarkers and 'apserv' == o['objClass'] and 'pathMarker' == o.get('label'):
      # create a new path
      path = newpath(o.get('name'), o['transform#'][0]['..posit.x#'], o['transform#'][0]['..posit.z#'])
      # and add it to the list
      top['paths'][path['label']] = path
    # if this is a base building (that we're watching for) make a path from it
    elif int(o['team#']) > 0 and o['objClass'] in labels.keys():
      objectlabel:str = o.get('label')
      # if no label or default label, do some hunting
      if not objectlabel or objectlabel.startswith('unnamed_') or objectlabel[0].isdigit():
        # grab the new pathname from the labels map for this objClass and the team
        pathname = labels[o['objClass']] + teams[o['team#']]
        # add the count from the object label if this is an enumerated bldg
        if '#' in pathname and objectlabel[0].isdigit():
          pathname = pathname.replace('#', o['label'])
      # otherwise just use the label given
      else:
        pathname = objectlabel
      # create a new path
      path = newpath(pathname, o['transform#'][0]['..posit.x#'], o['transform#'][0]['..posit.z#'])
      # and add it to the list
      top['paths'][path['label']] = path
    # if this is an ipdrop, leave it out
    elif o['objClass'] in toRemove:
      continue
    # and just dump everything else back into the object list
    else:
      newobjects.append(o)
  top['objects'] = newobjects

  debugPaths = True
  if(debugPaths):
    for p in top['paths'].values():
      # only do this for single point paths (don't want to fucks w edge_path)
      if 1 == len(p['points#']):
        top['objects'].append(toPathMarker(p['label'], p['points#'][0]['..x#'], p['points#'][0]['..z#'], 5))

  return top

def toFile(o, path):
  print(f'saved to {os.path.basename(path)}')
  with open(path, 'w') as fout:
    fout.write(o)

def fromYamlFile(path):
  print(f'Reading {os.path.basename(path)}')
  with open(path, 'r') as fin:
    return yaml.load(fin, Loader=yaml.Loader)

def main(dir, inputfn):
  print(f'objtopath')
  yml = fromYamlFile(dir + inputfn)
  ymlstr = yaml.dump(objtopath(yml))
  outfn = os.path.splitext(inputfn)[0] + '_path.yaml'
  toFile(ymlstr, dir + outfn)

if '__main__' == __name__:
  main(r'C:/Users/Mike/Documents/My Games/Battlezone Combat Commander/FE/addon/missions/Multiplayer/test/', 'test.yaml')
