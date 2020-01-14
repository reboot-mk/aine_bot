#!/usr/bin/env bash

mkdir images

mkdir images/dcd_friends
mkdir images/dcd_onpa

for i in 1 2 3
do
	mkdir images/opening_$i
done

for i in 1 2 3
do
	mkdir images/ending_$i
done

for i in {01..50}
do
	mkdir images/episode_$i
done