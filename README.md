# Acoustic-based distance calculation

An acoustic-based method that can be used to calculate the distance between pronunciations.

## Requirements
 - Python 3.6
 - PRAAT 6.1.08
 - Hidden Markov Toolkit (HTK) 3.4
 - FAVE
 - R

## Getting Started
    git clone https://github.com/Bartelds/acoustic-distance-measure.git

## Data
Identifiers of the audio samples used can be found in `Audio`

Data source: https://accent.gmu.edu/browse_language.php

## Usage
Before the distances can be computed, the input data must be preprocessed once (step 1:4). This can be done by adhering to the following procedure:

### 1: Forced-alignment
**Input:** audio files

**Output:** aligned .TextGrid files

    Forced-alignment

Forced-alignment is introduced to capture the words present inside the audio files.
The [Penn Phonetics Lab Forced Aligner](https://babel.ling.upenn.edu/phonetics/old_website_2015/p2fa/index.html) is used to accomplish the task of forced-alignment.

1. Resample all audio files to 16 KHz mono PCM.
2. Create a transcript file that contains all the words spoken in the audio samples.
3. Run alignment: `fa.sh`
4. Extract start and end of words: `extract_fa.praat`
5. Segment paragraphs into words: `wavsplitter.py`

### 2: MFCC generation
Generate MFCCs.

    MFCC

1. Generate .scp listing that suits your data: `example_hcopy.scp`
2. Use `config.txt` with HTK parameters. 
3. Generate MFCCs: `HCopy -T 1 -C config -S example_hcopy.scp`
4. HTK compressed format should be exported: `./exporthtk.sh`

### 3: Acoustic-based distance calculation
Distances are calculated using Dynamic Time Warping.

    DTW

1. `dtw.R` computes the distances (includes normalization).