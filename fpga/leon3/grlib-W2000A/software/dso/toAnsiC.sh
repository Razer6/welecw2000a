##!/bin/bash

for i in $@; do
	echo $i
	sed -f toAnsiC.sed $i > ${i}.x
	mv ${i}.x $i
done
