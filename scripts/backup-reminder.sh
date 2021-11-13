#!/bin/bash
# schedule this script to run 5 minutes before the backup job

gotify push -t "Backup Reminder" -p 10 "Backup job will run in 5 minutes, plug in the usb"
