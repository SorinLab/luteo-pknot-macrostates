#!/usr/bin/env sh

for i in M1 M2 M3 M4 M5 U1 U2;
do
    cd $i
    if [ ! -d "0.IOs" ]; then
        mkdir "0.IOs"
    fi
    ./0.contacts-filter.sh &
    cd ..
done