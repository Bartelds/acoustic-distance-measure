#!/bin/bash
# Specify the corpus in which the wav files are located

for filename in ./corpus/*.wav; do
    ./align.py "$filename" "./transcript.txt" "$filename.TextGrid"
done