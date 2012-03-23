#!/usr/bin/env python3

import os
import subprocess
import sys

def get_group(group, local=False):
  if local:
    op = '-Q'
  else:
    op = '-S'
  try:
    with open(os.devnull, 'w') as f:
      return set(
        subprocess.check_output(
          ['pacman', op, '-qg', group],
          stderr=f
        ).decode().strip().split('\n'))
  except subprocess.CalledProcessError:
    return set()


for group in sys.argv[1:]:
  sync_group = get_group(group)
  local_group = get_group(group, local=True)
  new = sync_group - local_group
  old = local_group - sync_group
  print(group)
  print('\tnew:\t', ' '.join(sorted(new)))
  print('\told:\t', ' '.join(sorted(old)))
