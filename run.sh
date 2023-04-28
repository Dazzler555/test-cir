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
if [ -n "$video_res" ] && [ -n "$audio_id" ]; then
  final="bestvideo[height<=$video_res]+$audio_id"
elif [ -n "$video_res" ]; then
  final="bestvideo[height<=$video_res]"
elif [ -n "$video_id" ]; then
  if [ -n "$audio_id" ]; then
    final="$video_id+$audio_id"
  else
    final="$video_id"
  fi
fi

if [[ -n "$video_res" && -n "$video_id" ]]; then
  output_name="$name-${video_res}p.mkv"
elif [[ -n "$video_res" ]]; then
  output_name="$name-${video_res}p.mkv"
elif [[ -n "$video_id" ]]; then
  output_name="$name-${video_id}.mkv"
else
  output_name="$name.mkv"
fi


yt-dlp --merge-output-format mkv -f "$final" --downloader aria2c -N 10 --embed-subs -o "$name-${video_id}p.mkv" "$url" 
# gclone --config ./rclone.conf move "$name-${video}p.mkv" severus:{$id} -drive-chunk-size 128M -P

# yt-dlp "$sub_url" -o "sub-test.%(ext)s"
# fmpeg -i sub-test.* subs.srt
# mkvmerge -o "$name-${video}p-sub.mkv" --language 0:$lang subs.srt "$name-${video}p.mkv
gclone --config ./rclone.conf move "$output_name" "severus:{$id}" --drive-chunk-size 128M -P --stats-one-line
