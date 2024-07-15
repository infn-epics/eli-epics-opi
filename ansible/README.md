# Ansible Update
This ansible scripts update a list of sparc consoles

## Requirements
ssh daemon installed on the target machine. Automation without password ask requires *host ansible ssh key* installed on the target.
```
## try
ssh-copy-id sparc@<console>

```

## Execution:
```
ansible-playbook -i console_list.ini gitupdate.yaml --ask-pass

```
