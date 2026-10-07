#!/bin/bash

# AWS re/Start - Laboratório 253
# Desafio: Scripts de Shell Bash

counter=1

while [ $counter -le 25 ]
do
    touch azevaldo$counter
    echo "azevaldo$counter"
    ((counter++))
done
