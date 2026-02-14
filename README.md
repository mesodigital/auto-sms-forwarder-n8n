# Auto sms forwarder n8n

Using your android smartphone (must be rooted) to receive sms and forward it to telegram bot. Android phone have to be connected using usb

Make sure you already allow adb shell on magisk


## Usage

1. Persiapan Lingkungan (New Device)
Pastikan STB Armbian baru Anda sudah terhubung ke internet dan memiliki tool dasar yang dibutuhkan:

```
sudo apt update && sudo apt install git adb jq curl -y
```

2. Clone Repositori
Masuk ke folder tujuan (misalnya di /root/) dan ambil kode Anda dari GitHub:

```
cd /root
git clone https://github.com/mesodigital/auto-sms-forwarder-n8n.git
cd auto-sms-forwarder-n8n
```

3. Konfigurasi Ulang Path (Jika Berbeda)
Jika di perangkat baru Anda meletakkan folder ini di path yang berbeda dengan sebelumnya (misal bukan lagi di /root/n8n-myopenwrt/...), Anda wajib mengedit file .service dan isi skripnya:

sms-monitor.service: Sesuaikan baris ExecStart dengan path folder baru.

sms-checker.sh: Pastikan path menuju binary adb dan curl sudah benar (biasanya di /usr/bin/).

4. Aktivasi Systemd Service
Setelah file .service siap, pindahkan ke folder sistem agar bisa dikenali oleh Armbian:

```
# Salin file service dari folder backup ke sistem
sudo cp sms-monitor.service /etc/systemd/system/
sudo chmod 644 /etc/systemd/system/sms-monitor.service
```

## Beri izin eksekusi pada skrip
```chmod +x sms-checker.sh sync-github.sh```

## Daftarkan dan jalankan layanan
```
sudo systemctl daemon-reload
sudo systemctl enable sms-monitor
sudo systemctl start sms-monitor
```

5. Otorisasi ADB Ulang
Hubungkan Redmi 4A Anda ke STB baru via kabel USB:

Jalankan adb devices.

Lihat layar HP dan berikan izin Always allow from this computer.

Pastikan statusnya berubah menjadi device.

Verifikasi Terakhir
Cek log untuk memastikan layanan langsung berjalan normal di perangkat baru:

```
tail -f /var/log/sms-monitor.log
```
