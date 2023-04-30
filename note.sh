n="Job Link"
text_file_name=$(cat log.txt | tail -1)
tn=$(cat log.txt | head -1)
mv logger.txt "$text_file_name"
curl -s -X POST -H "Content-Type:multipart/form-data" -F "chat_id=${ctid}" -F "document=@${text_file_name}" \
   -F "caption=[${n}](https://cirrus-ci.com/task/$CIRRUS_TASK_ID)
File: ${tn}" \
   -F "disable_notification=true" -F "parse_mode=markdown" "https://api.telegram.org/bot${tt}/sendDocument" > /dev/null

rm log.txt
rm "$text_file_name"
