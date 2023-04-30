n="Job Link"
text_file_name="log.txt"
tn=$(cat output_name.txt)
curl -s -X POST -H "Content-Type:multipart/form-data" -F "chat_id=${ctid}" -F "document=@${text_file_name}" \
   -F "caption=[${n}](https://cirrus-ci.com/task/$CIRRUS_TASK_ID)
File: ${tn}" \
   -F "disable_notification=true" -F "parse_mode=markdown" "https://api.telegram.org/bot${tt}/sendDocument" > /dev/null

rm output_name.txt
