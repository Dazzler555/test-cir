export DEBIAN_FRONTEND="noninteractive"
#apt update -y
#
#apt install tzdata -y ENV TZ="America/New_York"
#apt install aria2 p7zip-full -y
#apt install git  python3 python3-pip curl mediainfo ffmpeg wget mkvtoolnix -y
pip3 install yt-dlp
#wget -q https://github.com/donwa/gclone/releases/download/v1.51.0-mod1.3.1/gclone_1.51.0-mod1.3.1_Linux_x86_64.gz
#7z x gclone_1.51.0-mod1.3.1_Linux_x86_64.gz > /dev/null
#chmod a+x ./gclone && mv ./gclone /usr/bin/
wget -q $cu
pwd
ls
curl -L -H "Accept: application/vnd.github+json"   -H "Authorization: Bearer $gt"  -H "X-GitHub-Api-Version: 2022-11-28"   https://api.github.com/gists/$cid | jq -r '.files | ."config.txt" | .content' > config.txt
source config.txt
yt-dlp -F "$url"

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




# Derive output_name variable
if [[ -n "$video_res" && -n "$video_id" ]]; then
  output_name="$name-${video_res}p.mkv"
elif [[ -z "$video_res" && -n "$video_id" ]]; then
  output_name="$name-${video_id}.mkv"
else
  output_name="$name.mkv"
fi

# Generate output file
yt-dlp --merge-output-format mkv -f "$final" --downloader aria2c -N 10 --embed-subs -o "$output_name" "$url" 
# gclone --config ./rclone.conf move "$name-${video}p.mkv" severus:{$id} -drive-chunk-size 128M -P

# yt-dlp "$sub_url" -o "sub-test.%(ext)s"
# fmpeg -i sub-test.* subs.srt
# mkvmerge -o "$name-${video}p-sub.mkv" --language 0:$lang subs.srt "$name-${video}p.mkv


if [[ "$output_name" == "$name-${video_res}p.mkv" ]]; then
  final_output_name="$output_name"
elif [[ "$output_name" == "$name-${video_id}.mkv" || "$output_name" == "$name.mkv" ]]; then
  vid_ht=$(mediainfo --Inform="Video;%Height%" "$output_name")
  final_output_name="$name-${vid_ht}p.mkv"
fi

# Rename output file if necessary
if [[ "$final_output_name" != "$output_name" ]]; then
  mv "$output_name" "$final_output_name"
fi


gclone --config ./rclone.conf move "$final_output_name" "severus:{$id}" --drive-chunk-size 128M -P --stats-one-line
