#!/bin/bash
# Reset ADB setiap kali skrip dimulai ulang
/usr/bin/adb kill-server
sleep 2
/usr/bin/adb devices

WEBHOOK_URL="http://localhost:5678/webhook/sms-otomatis"

echo "Monitoring SMS started (Multi-line Support Enabled)..."

# Monitor logcat untuk SMS baru
/usr/bin/adb shell "logcat -b main | grep --line-buffered 'ReceiveSmsMessageAction'" | while read line
do
    sleep 2
    
    # Ambil data terbaru tanpa head -n 1 agar baris baru tidak terpotong.
    # Kita menggunakan awk untuk hanya mengambil entri pertama (Row: 0) sampai sebelum entri kedua (Row: 1) muncul.
    DATA=$(/usr/bin/adb shell "content query --uri content://sms --projection address:body:date --where \"type=1\" --sort \"date DESC\"" | awk '/Row: 0 / {p=1; print; next} /Row: 1 / {p=0} p')
    
    # Validasi jika DATA kosong
    if [ -z "$DATA" ]; then continue; fi

    # JQ akan secara otomatis mengubah karakter newline asli menjadi string "\n" yang valid dalam JSON
    JSON_PAYLOAD=$(jq -n --arg raw "$DATA" '{raw_data: $raw}')
    
    # Kirim payload ke n8n
    curl -s -X POST -H "Content-Type: application/json" -d "$JSON_PAYLOAD" $WEBHOOK_URL
    
    echo "SMS Sent to Webhook at $(date)"
done