#!/bin/sh
ls path_to_MFCC | sed 's/.mfc$//' >tempbasenames
for speaker in `cat tempbasenames`
do
    echo $speaker
    HList -r ./path_to_MFCC/$speaker.mfc > ./path_to_MFCC_exported/$speaker.mfcx
done
rm tempbasenames
