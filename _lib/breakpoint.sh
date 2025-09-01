# shellcheck shell=bash

breakpoint() {
    # enable a debug prompt that allows you to see expanded variables and execute each
    # line thereafter step-by-step

    # shellcheck disable=SC2329  # shellcheck has a hard time with traps
    debug_prompt() {
        # ex usage:
        #
        #     debug_prompt filename line_num command_being_executed
        #
        # outputs:
        #
        #     [filename:line_num] command_being_executed
        #
        # ...and waits for the user to press enter

        # shellcheck disable=SC2317  # unreachable code false positive
        (read -r -p "[$1:$2] $3")
    }
    set -x
    trap 'debug_prompt "${BASH_SOURCE[0]}" ${LINENO} "${BASH_COMMAND}"' DEBUG
}
