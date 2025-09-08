#!/usr/bin/env bats

source tests/util.sh

@test 'example test' {
    capture_output echo "foobar"
    assert_no_stderr
    assert_stdout '^foobar$'
    assert_exit_code 0
}
