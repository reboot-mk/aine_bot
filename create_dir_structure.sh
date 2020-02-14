#!/usr/bin/env bash

mkdir images

mkdir images/fure_dcd
mkdir images/onpa_dcd

for i in 1 2 3
do
	mkdir images/fure_opening$i
done

for i in 1 2 3
do
	mkdir images/fure_ending$i
done

for i in {01..76}
do
	mkdir images/fure_ep$i
done