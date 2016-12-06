#!/bin/sh

./macrostates-stats.pl macrostateF1.txt macrostateF1stats.txt &
./macrostates-stats.pl macrostateF2.txt macrostateF2stats.txt &
./macrostates-stats.pl macrostateI1.txt macrostateI1stats.txt &

./macrostates-stats.pl macrostateI2.txt macrostateI2stats.txt &

./macrostates-stats.pl macrostateM4.txt macrostateM4stats.txt &
./macrostates-stats.pl macrostateM1.txt macrostateM1stats.txt &
./macrostates-stats.pl macrostateU1.txt macrostateU1stats.txt &
./macrostates-stats.pl macrostateU2.txt macrostateU2stats.txt &

./macrostates-stats.pl macrostateM2.txt macrostateM2stats.txt &
./macrostates-stats.pl macrostateM3.txt macrostateM3stats.txt &
./macrostates-stats.pl macrostateU3.txt macrostateU3stats.txt &
