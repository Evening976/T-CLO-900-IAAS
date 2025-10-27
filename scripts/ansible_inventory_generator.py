#!/usr/bin/env python3
import json
import sys


# Usage: terraform output -json > tf_out.json
# python3 tf_to_ansible_inventory.py tf_out.json > ansible/inventories/hosts.ini


if len(sys.argv) < 2:
  print("Usage: tf_to_ansible_inventory.py <terraform_output.json>")
  sys.exit(1)


with open(sys.argv[1]) as f:
  data = json.load(f)


hosts = data.get('hosts', {}).get('value', {})


masters = hosts.get('masters', [])
workers = hosts.get('workers', [])
gitlab = hosts.get('gitlab')


print('[masters]')
for h in masters:
  print(h)


print('\n[workers]')
for h in workers:
  print(h)


print('\n[gitlab]')
print(gitlab)

bastion = hosts.get('bastion')

print('[bastion]')
print(bastion)



print('\n[all:vars]')
print('ansible_user=azureuser')
print('ansible_python_interpreter=/usr/bin/python3')