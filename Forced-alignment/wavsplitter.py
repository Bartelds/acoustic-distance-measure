#!/usr/bin/env python
import os
import sys
from glob import glob
from pydub import AudioSegment
from pydub.playback import play

def retrieve_files():
    """ Retrieves all audio files and the corresponding FAs from their directories"""
    audio_files = sorted([audio for audio in glob("*.wav")])
    time_files = sorted([time for time in glob("*.txt")])

    return audio_files, time_files


def segment_audio(audio_files, time_files):
    """Matches the corresponding audio with FA and splits each audio into the correct words"""
    for i in range(len(audio_files)):
        if audio_files[i].split("/")[2][:-4] == time_files[i].split("/")[2][:-4]:
            with open(os.path.join(time_files[i]), "r") as f:
                for line in f:
                    elements = line.rstrip().split("\t")
                    if not elements[1].startswith("sp"):
                        pron_word = elements[1]
                        start = int(float(elements[2]) * 1000 - 5)
                        end = int(float(elements[3])* 1000 + 5)
                        target_audio = AudioSegment.from_wav(audio_files[i])
                        target_segment = target_audio[start:end]
                        target_segment.export(audio_files[i].split("/")[2][:-4] + "_" + pron_word + ".wav", format="wav")
                
                print("{} {} {}".format("### Successfully segmented", audio_files[i].split("/")[2], "###"))


def main():
    audio_files, time_files = retrieve_files()
    
    if len(audio_files) != len(time_files):
        print("Error: amount of audio files and forced alignments is inconsistent", file=sys.stderr)

    segment_audio(audio_files, time_files)                  

if __name__ == '__main__':
    main()
