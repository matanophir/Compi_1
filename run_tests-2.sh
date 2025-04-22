#!/bin/bash

make clean && make
if [ $? -ne 0 ]; then
    echo "Compilation failed!"
    exit 1
fi

echo "Compilation succeeded."
echo "Running tests..."

passed=0
failed=0

for test_in in hw1-tests/t*.in; do
    test_name=$(basename "$test_in" .in)
    test_out="hw1-tests/${test_name}.out"
    test_res="${test_name}.res"

    echo -n "Running $test_name... "

    ./hw1 < "$test_in" 2>&1 > "$test_res"

    if diff "$test_res" "$test_out" > /dev/null; then
        echo "PASSED"
        rm "$test_res"
        ((passed++))
    else
        echo "FAILED (see $test_res)"
        ((failed++))
    fi
done

echo
echo "Summary:"
echo "Passed: $passed"
echo "Failed: $failed"
