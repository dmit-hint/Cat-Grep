#!/bin/bash

SUCCESS=0
FAIL=0
COUNTER=0
DIFF_RES=""

declare -a tests=(
"VAR test_cat/test_case_cat.txt"
)

declare -a extra=(
"-s test_cat/test_1_cat.txt"
"-b -e -n -s -t -v test_cat/test_1_cat.txt"
"-t test_cat/test_3_cat.txt"
"-n test_cat/test_2_cat.txt"
"no_file.txt"
"-n -b test_cat/test_1_cat.txt"
"-s -n -e test_cat/test_4_cat.txt"
"test_1_cat.txt -n"
"-n test_cat/test_1_cat.txt"
"-n test_cat/test_1_cat.txt test_cat/test_2_cat.txt"
"-v test_cat/test_5_cat.txt"
)


testing()
{
    t=$(echo "$@" | sed "s/VAR/$var/")
    ./my_cat $t > test_cat/test_my_cat.log
    cat $t > test_cat/test_sys_cat.log
    DIFF_RES="$(diff -s test_cat/test_my_cat.log test_cat/test_sys_cat.log)"
    (( COUNTER++ ))
    echo $DIFF_RES
    if [ "$DIFF_RES" == "Files test_cat/test_my_cat.log and test_cat/test_sys_cat.log are identical" ]
    then
        (( SUCCESS++ ))
        echo -e "\e[31m$FAIL\e[0m/\e[32m$SUCCESS\e[0m/$COUNTER \e[32msuccess\e[0m cat $t"
    else
        (( FAIL++ ))
        echo -e "\e[31m$FAIL\e[0m/\e[32m$SUCCESS\e[0m/$COUNTER \e[31mfail\e[0m cat $t"
    fi
    rm test_cat/test_my_cat.log test_cat/test_sys_cat.log
}

# специфические тесты
for i in "${extra[@]}"
do
    var="-"
    testing "$i"
done

# 1 параметр
for var1 in b e n s t v
do
    for i in "${tests[@]}"
    do
        var="-$var1"
        testing "$i"
    done
done

# 2 параметра
for var1 in b e n s t v
do
    for var2 in b e n s t v
    do
        if [ $var1 != $var2 ]
        then
            for i in "${tests[@]}"
            do
                var="-$var1 -$var2"
                testing "$i"
            done
        fi
    done
done

# 3 параметра
for var1 in b e n s t v
do
    for var2 in b e n s t v
    do
        for var3 in b e n s t v
        do
            if [ $var1 != $var2 ] && [ $var2 != $var3 ] && [ $var1 != $var3 ]
            then
                for i in "${tests[@]}"
                do
                    var="-$var1 -$var2 -$var3"
                    testing "$i"
                done
            fi
        done
    done
done

# 4 параметра
for var1 in b e n s t v
do
    for var2 in b e n s t v
    do
        for var3 in b e n s t v
        do
            for var4 in b e n s t v
            do
                if [ $var1 != $var2 ] && [ $var2 != $var3 ] \
                && [ $var1 != $var3 ] && [ $var1 != $var4 ] \
                && [ $var2 != $var4 ] && [ $var3 != $var4 ]
                then
                    for i in "${tests[@]}"
                    do
                        var="-$var1 -$var2 -$var3 -$var4"
                        testing "$i"
                    done
                fi
            done
        done
    done
done

echo "======================================="
echo -e "\e[31mFAIL\e[0m: $FAIL"
echo -e "\e[32mSUCCESS\e[0m: $SUCCESS"
echo "ALL: $COUNTER"