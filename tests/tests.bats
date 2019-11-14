#! /usr/bin/bats
#
# Requirements:
#   - bats: https://github.com/sstephenson/bats
#   - jq: https://stedolan.github.io/jq/
#
function setup_workdir () {
    # export TESTS_OUT_DIR=$(mktemp --directory)
    export INVENTORY=${INVENTORY:-hosts.yml}
    export NW_TARGETS_AVAIL=${NW_TARGETS_AVAIL:-no}  # yes | no
}

function prune_workdir () {
    # test -d ${TESTS_OUT_DIR:?} && [[ ${TESTS_OUT_DIR} != "/" ]] && rm -rf ${TESTS_OUT_DIR}
    :
}

function setup () {
    cd $BATS_TEST_DIRNAME
    setup_workdir
}

function teardown () {
    prune_workdir
}

function skip_tests_if_targets_are_not_available () {
    [[ ${NW_TARGETS_AVAIL} == 'yes' ]] || skip "Skip tests because targets are not available"
}

function check_results () {
    [[ ${status} -eq 0 ]] || {
        cat << EOM
output:
${output}
EOM
        exit ${status}
    }
}

@test "Lint all yaml files" {
    run yamllint --strict .
    check_results
}

@test "Check styles of all playbook files" {
    run ansible-lint playbook.yml
    check_results
}

# 10: test access
@test "Test if we can access target network nodes" {
    skip_tests_if_targets_are_not_available
    run ansible-playbook -v -i $INVENTORY test_access.yml
    check_results
}

# 20: dump
@test "Test dumping version info [ios]" {
    skip_tests_if_targets_are_not_available
    run ansible-playbook -v -i $INVENTORY playbook.yml \
        -e @files/20_evars_ios_dump.yml
    check_results
}

@test "Test dumping version info [junos]" {
    skip_tests_if_targets_are_not_available
    run ansible-playbook -v -i $INVENTORY playbook.yml \
        -e @files/20_evars_junos_dump.yml
    check_results
}

# 30: dryrun
@test "Test version info was shown in the result w/o running command [ios]" {
    run ansible-playbook -v -i $INVENTORY playbook.yml \
        -e @files/30_evars_ios_dryrun.yml \
        -e @ref/ios0_ios_ref.out
    check_results
}

@test "Test version info was shown in the result w/o running command [junos]" {
    run ansible-playbook -v -i $INVENTORY playbook.yml \
        -e @files/30_evars_junos_dryrun.yml \
        -e @ref/junos0_junos_ref.out
    check_results
}

# 40: normal
@test "Test version info was gotten successfully [ios]" {
    skip_tests_if_targets_are_not_available
    run ansible-playbook -v -i $INVENTORY playbook.yml \
        -e @files/40_evars_ios_normal.yml
    check_results
}

@test "Test version info was gotten successfully [junos]" {
    skip_tests_if_targets_are_not_available
    run ansible-playbook -v -i $INVENTORY playbook.yml \
        -e @files/40_evars_junos_normal.yml
    check_results
}

# 50: dump (interfaces)
@test "Test dumping interfaces info [ios]" {
    skip_tests_if_targets_are_not_available
    run ansible-playbook -v -i $INVENTORY playbook.yml \
        -e @files/50_evars_ios_dump_interfaces.yml
    check_results
}

@test "Test dumping interfaces info [junos]" {
    skip_tests_if_targets_are_not_available
    run ansible-playbook -v -i $INVENTORY playbook.yml \
        -e @files/50_evars_junos_dump_interfaces.yml
    check_results
}

# 60: dryrun (interfaces)
@test "Test interfaces was found in the result w/o running command [ios]" {
    run ansible-playbook -v -i $INVENTORY playbook.yml \
        -e @files/60_evars_ios_dryrun_interfaces.yml \
        -e @ref/ios0_ios_intf_ref.out
    check_results
}

@test "Test interfaces was found in the result w/o running command [junos]" {
    run ansible-playbook -v -i $INVENTORY playbook.yml \
        -e @files/60_evars_junos_dryrun_interfaces.yml \
        -e @ref/junos0_junos_intf_ref.out
    check_results
}

# vim:sw=4:ts=4:et:filetype=sh:
