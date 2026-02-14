#!/bin/bash
# Reset ADB setiap kali skrip dimulai ulang
/usr/bin/adb kill-server
sleep 2
/usr/bin/adb devices

WEBHOOK_URL="http://localhost:5678/webhook/sms-otomatis"

# Gunakan keyword logcat yang Anda temukan sebelumnya
/usr/bin/adb shell "logcat -b main | grep --line-buffered 'ReceiveSmsMessageAction'" | while read line
do
    sleep 1.5
    # Ambil data dari ADB
    DATA=$(/usr/bin/adb shell "content query --uri content://sms --projection address:body:date --where \"type=1\" --sort \"date DESC\"" | head -n 1)
    
    # Gunakan jq untuk membuat JSON yang valid dan menangani karakter aneh/newline
    JSON_PAYLOAD=$(jq -n --arg raw "$DATA" '{raw_data: $raw}')
    
    # Kirim payload yang sudah bersih ke n8n
    curl -s -X POST -H "Content-Type: application/json" -d "$JSON_PAYLOAD" $WEBHOOK_URL
done