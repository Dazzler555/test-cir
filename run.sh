export DEBIAN_FRONTEND="noninteractive"
# apt-get install libc6-dev
wget -q "${cu}"
pwd
ls
curl -L -H "Accept: application/vnd.github+json"   -H "Authorization: Bearer ${gt}"  -H "X-GitHub-Api-Version: 2022-11-28"   https://api.github.com/gists/"${cid}" | jq -r '.files | ."config.txt" | .content' > config.txt
source config.txt
if [ -n "${url}" ] && [ -n "${ref}" ]; then
   mpx -F "${url}" --referer "${ref}"
elif [ -n "${url}" ]; then
   mpx -F "${url}"
fi

str=$(python3 uni.py "${name}")
name="${str}"
# calculate vd
if [[ -n "${video_res}" && -n "${video_id}" ]]; then
  vd="bestvideo[height<=${video_res}]"
elif [[ -n "${video_res}" ]]; then
  vd="bestvideo[height<=${video_res}]"
elif [[ -n "${video_id}" ]]; then
  vd="${video_id}"
else
  vd=""
fi

# calculates ad
if [[ -n "${audio_id}" ]]; then
  ad="${audio_id}"
else
  ad=""
fi

# calculate final
if [[ -n "${ad}" ]]; then
  final="${vd}+${ad}"
else
  final="${vd}"
fi

# print the final result
echo "${final}"




# Derive output_name variable
if [[ -n "${video_res}" && -n "${video_id}" || -n "${video_res}" && -z "${video_id}" ]]; then
  output_name="${name}-${video_res}p.mkv"
elif [[ -z "${video_res}" && -n "${video_id}" ]]; then
  output_name="${name}-${video_id}.mkv"
else
  output_name="${name}.mkv"
fi
echo "Starting....."
# Generate output file
# mpx -q --convert-subs srt --merge-output-format mkv -f "$final" --downloader aria2c -N 10 --embed-subs -o "$output_name" "$url"

if [ -n "${url}" ] && [ -n "${ref}" ]; then
    mpx -q --merge-output-format mkv -f "$final" --downloader aria2c -N 10 -o "${output_name}" "${url}" --referer "${ref}"
elif [ -n "${url}" ]; then
    mpx -q --merge-output-format mkv -f "${final}" --downloader aria2c -N 10  -o "${output_name}" "${url}"
fi


# gclone --config ./rclone.conf move "$name-${video}p.mkv" severus:{$id} -drive-chunk-size 128M -P
echo "DL done"

if [ -n "${sub_url}" ]; then
  mpx "${sub_url}" -o "sub-test.%(ext)s" > /dev/null
  sf=$(find . -maxdepth 1 -type f -name "sub-test.*" -printf "%T@ %p\n" | sort -n | tail -n1 | cut -d" " -f2- | sed 's|^./||')
  ffmpeg -hide_banner -i "$sf" subs.srt
  ext=".mkv"
  mkv_filename=$(basename "${output_name}" "${ext}")
  sb="-sub"
  sub_mkv="${mkv_filename}${sb}${ext}"
  echo "MKV SUB"
  cmp -o "$sub_mkv" --language 0:"${sub_lang}" "subs.srt" "${output_name}" > /dev/null
  ls
#  rm "${output_name}"
  mv "${sub_mkv}" "${output_name}"
  rm -f sub-test.*
  rm -f subs.*
fi

ls



if [[ "${output_name}" == "${name}-${video_res}p.mkv" ]]; then
  final_output_name="${output_name}"
elif [[ "${output_name}" == "${name}-${video_id}.mkv" || "${output_name}" == "${name.mkv}" ]]; then
  vid_ht=$(ffprobe -v error -select_streams v:0 -show_entries stream=width,height -of csv=s=x:p=0 "${output_name}" | awk -F 'x' '{print $2}')
  final_output_name="${name}-${vid_ht}p.mkv"
fi

echo "video height: ${vid_ht}"

# Rename output file if necessary
if [[ "${final_output_name}" != "${output_name}" ]]; then
  mv "${output_name}" "${final_output_name}"
fi
echo "2nd ls"
ls


# info=$(basename "${final_output_name}" .mkv)
mediainfo "${final_output_name}" >> minfo.txt

gclone --config ./rclone.conf move "${final_output_name}" "severus:{$id}" --drive-chunk-size 128M -P --stats-one-line



if [[ $? -eq 0 ]]; then
  echo "${final_output_name}" > log.txt
  echo "success.txt" >> log.txt
else
  echo "no file, check log" > log.txt
  echo "error.txt" >> log.txt
fi
