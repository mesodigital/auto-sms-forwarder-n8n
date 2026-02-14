#!/bin/bash
cd /root/n8n-myopenwrt/auto-messager-v1.0
cp /etc/systemd/system/sms-monitor.service .
git add .
git commit -m "Auto-backup: $(date)"
git push origin main
