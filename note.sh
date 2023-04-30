n="Job Link"
text_file_name="log.txt"
curl -s -X POST -H "Content-Type:multipart/form-data" -F "chat_id=${ctid}" -F "document=@${text_file_name}" \
   -F "caption=[${n}](https://cirrus-ci.com/task/$CIRRUS_TASK_ID)
File: ${k}" \
   -F "disable_notification=true" -F "parse_mode=markdown" "https://api.telegram.org/bot${tt}/sendDocument" > /dev/null
unset "${k}"
