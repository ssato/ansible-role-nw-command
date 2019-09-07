#! /usr/bin/bats
#
# Requirements:
#   - bats: https://github.com/sstephenson/bats
#   - jq: https://stedolan.github.io/jq/
#
function setup_workdir () {
    # export TESTS_OUT_DIR=$(mktemp --directory)
    export INVENTORY=${INVENTORY:-hosts.yml}
}

function prune_workdir () {
    # test -d ${TESTS_OUT_DIR:?} && [[ ${TESTS_OUT_DIR} != "/" ]] && rm -rf ${TESTS_OUT_DIR}
    :
}

function setup () {
    setup_workdir
}

function teardown () {
    prune_workdir
}

@test "Lint all yaml files" {
    run yamllint roles/ .
    [[ ${status} -eq 0 ]]
}

@test "Check styles of all playbook files" {
    run ansible-lint *.yml
    [[ ${status} -eq 0 ]]
}

# 10: test access
@test "Test if we can access target network nodes" {
    run ansible-playbook -v -i $INVENTORY test_access.yml
    [[ ${status} -eq 0 ]]
}

# 20: dump
@test "Test dumping version info [ios]" {
    run ansible-playbook -v -i $INVENTORY playbook.yml \
        -e @files/20_evars_ios_dump.yml
    [[ ${status} -eq 0 ]]
}

@test "Test dumping version info [junos]" {
    run ansible-playbook -v -i $INVENTORY playbook.yml \
        -e @files/20_evars_junos_dump.yml
    [[ ${status} -eq 0 ]]
}

# 30: dryrun
@test "Test version info was shown in the result w/o running command [ios]" {
    run ansible-playbook -v -i $INVENTORY playbook.yml \
        -e @files/30_evars_ios_dryrun.yml \
        -e @ref/ios0_ios_ref.out
    [[ ${status} -eq 0 ]]
}

@test "Test version info was shown in the result w/o running command [junos]" {
    run ansible-playbook -v -i $INVENTORY playbook.yml \
        -e @files/30_evars_junos_dryrun.yml \
        -e @ref/junos0_junos_ref.out
    [[ ${status} -eq 0 ]]
}

# 40: normal
@test "Test version info was gotten successfully [ios]" {
    run ansible-playbook -v -i $INVENTORY playbook.yml \
        -e @files/40_evars_ios_normal.yml
    [[ ${status} -eq 0 ]]
}

@test "Test version info was gotten successfully [junos]" {
    run ansible-playbook -v -i $INVENTORY playbook.yml \
        -e @files/40_evars_junos_normal.yml
    [[ ${status} -eq 0 ]]
}

# 50: dump (interfaces)
@test "Test dumping interfaces info [ios]" {
    run ansible-playbook -v -i $INVENTORY playbook.yml \
        -e @files/50_evars_ios_dump_interfaces.yml
    [[ ${status} -eq 0 ]]
}

@test "Test dumping interfaces info [junos]" {
    run ansible-playbook -v -i $INVENTORY playbook.yml \
        -e @files/50_evars_junos_dump_interfaces.yml
    [[ ${status} -eq 0 ]]
}

# 60: dryrun (interfaces)
@test "Test interfaces was found in the result w/o running command [ios]" {
    run ansible-playbook -v -i $INVENTORY playbook.yml \
        -e @files/60_evars_ios_dryrun_interfaces.yml \
        -e @ref/ios0_ios_intf_ref.out
    [[ ${status} -eq 0 ]]
}

@test "Test interfaces was found in the result w/o running command [junos]" {
    run ansible-playbook -v -i $INVENTORY playbook.yml \
        -e @files/60_evars_junos_dryrun_interfaces.yml \
        -e @ref/junos0_junos_intf_ref.out
    [[ ${status} -eq 0 ]]
}

# vim:sw=4:ts=4:et:filetype=sh:
