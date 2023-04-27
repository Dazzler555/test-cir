export DEBIAN_FRONTEND="noninteractive"
apt update -y

apt install tzdata -y ENV TZ="America/New_York"
apt install aria2 -y
apt install git  python3 python3-pip curl mediainfo ffmpeg wget mkvtoolnix -y
pip3 install yt-dlp
wget -q https://github.com/donwa/gclone/releases/download/v1.51.0-mod1.3.1/gclone_1.51.0-mod1.3.1_Linux_x86_64.gz
7z x gclone_1.51.0-mod1.3.1_Linux_x86_64.gz > /dev/null
sudo chmod a+x ./gclone && mv ./gclone /usr/bin/
wget -q $cu
wget -q $yt

source config.txt

if [ -z "$audio_id" ]; then
  final="$video_id"
else
  final="$video_id+$audio_id"
fi

yt-dlp --merge-output-format mkv -f "$final" --downloader aria2c -N 10 "$url" -o "$name-${video}p.mkv"
# gclone --config ./rclone.conf move "$name-${video}p.mkv" severus:{$id} -drive-chunk-size 128M -P

# yt-dlp "$sub_url" -o "sub-test.%(ext)s"
# fmpeg -i sub-test.* subs.srt
# mkvmerge -o "$name-${video}p-sub.mkv" --language 0:$lang subs.srt "$name-${video}p.mkv
gclone --config ./rclone.conf move "$name-${video}p.mkv" severus:{$id} -drive-chunk-size 128M -P
