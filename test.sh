#!/bin/bash

# set the variables
url="https://example.com/343786417"
audio_id="dash-fastly_skyfire_sep-audio-c8aa45b1"
video_id="hls-fastly_skyfire-1575"
video_res="528"
sub_url=""
sub_lang=""
name="jamaica tapes 2019"
res=""
out_mkv=""
out_srt="subs.srt"

# calculate vd
if [[ -n "$video_res" && -n "$video_id" ]]; then
  vd="bestvideo[height<=$video_res]"
elif [[ -n "$video_res" ]]; then
  vd="bestvideo[height<=$video_res]"
elif [[ -n "$video_id" ]]; then
  vd="$video_id"
else
  vd=""
fi

# calculate ad
if [[ -n "$audio_id" ]]; then
  ad="$audio_id"
else
  ad=""
fi

# calculate final
if [[ -n "$ad" ]]; then
  final="$vd+$ad"
else
  final="$vd"
fi

# print the final result
echo "$final"
