===================================
ssato.nw_test_existence_by_regex
===================================

[![Build Status](https://img.shields.io/travis/ssato/ansible-role-nw-test-existence-by-regex.png)](https://travis-ci.org/ssato/ansible-role-nw-test-existence-by-regex) [![Ansible Galaxy](https://img.shields.io/ansible/role/44621.svg)](https://galaxy.ansible.com/ssato/nw_test_existence_by_regex)

An ansible role to test existence of target objects in network nodes.

This role has the following three modes depends on the value of the variable,
rntebr_mode (default: normal).

'normal' is a mode to run command on target network nodes to test existence of
target objects by regex patterns or test these are not found if the value of
variable rntebr_targets_should_be_found is false.

'dump' is a mode to run command on target network nodes and dump its result as
a JSON file in the pre-defined format.

'dryrun' is a mode to run this role w/o running command on target network nodes
actually. This should be useful to test given patterns match as expected.

Requirements
==============

- Python modules required by each ansible network modules you use

Role Variables
================

Variables should be customized for your use cases.

- rntebr_mode: 'dump' or 'dryrun' or other string including 'normal'

  - Set to 'dump' if you want dump the output of results of command run
  - Set to 'dryrun' if you just want to test regex pattern matches w/ reference
    data was given. (You need to prepare the reference data by yourself.)
  - Set to other string including 'normal' if you want to run command and test
    existence of target objects by finding regex matches given

- rntebr_targets_patterns: Regex patterns to search for target objects from
  outputs as a result of command run

- rntebr_res: Set to some results on 'dryrun' mode
- rntebr_dump_path: output file path on 'dump' mode
- rntebr_command: command to run on target network nodes on !'dryrun' mode

Other variables should not needed to be customized for most cases.

see also defaults/main.yml for default definitions of each variables and tests/files/\*_evars_\*.yml for .

Example Playbook
==================

see tests/playbook.yml

License
=========

MIT

Author
=========

Satoru SATOH `ssato@Github <https://github.com/ssato>`_

.. vim:sw=2:ts=2:et:
