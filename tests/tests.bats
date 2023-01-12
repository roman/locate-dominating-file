#!/usr/bin/env bats

setup() {
    bats_load_library bats-support
    bats_load_library bats-assert
    DIR="$( cd "$( dirname "$BATS_TEST_FILENAME" )" >/dev/null 2>&1 && pwd )"
    WORKDIR="$(mktemp -d -t XXXXXX-locate-dominating-file)"
    PATH="$DIR/../src:$PATH"
    pushd "$WORKDIR" || exit 1
    mkdir -p one/two/three/four
    touch one/a.txt
    touch one/two/b.txt
    touch one/two/three/c.txt
    touch one/two/three/four/d.txt
    pushd one/two/three/four || exit 1

}

teardown() {
    popd || exit 1
    popd || exit 1
    rm -rf "$WORKDIR"
}

@test "file discovery" {
    run pwd
    assert_output "$WORKDIR/one/two/three/four"

    run locate-dominating-file.sh a.txt
    assert_output "$WORKDIR/one/a.txt"

    run locate-dominating-file.sh b.txt
    assert_output "$WORKDIR/one/two/b.txt"

    run locate-dominating-file.sh c.txt
    assert_output "$WORKDIR/one/two/three/c.txt"

    run locate-dominating-file.sh d.txt
    assert_output "$WORKDIR/one/two/three/four/d.txt"
}

@test "exit status code 1 when not found" {
    run pwd
    assert_output "$WORKDIR/one/two/three/four"

    run locate-dominating-file.sh foobar.txt
    assert_failure

}

@test "no-print option" {
    run pwd
    assert_output "$WORKDIR/one/two/three/four"

    run locate-dominating-file.sh --no-print a.txt
    assert_output ""
}

@test "print-dir option" {
    run pwd
    assert_output "$WORKDIR/one/two/three/four"

    run locate-dominating-file.sh --print-dir a.txt
    assert_output "$WORKDIR/one"
}

@test "print-dir and no-print option" {
    run pwd
    assert_output "$WORKDIR/one/two/three/four"

    run locate-dominating-file.sh --print-dir --no-print a.txt
    assert_success
    assert_output ""
}
