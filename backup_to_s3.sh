#!/bin/bash

SOURCE_DIR="/home/ec2-user/project"       # Folder to back up
S3_BUCKET="my-backup-bucket"              # S3 bucket name (without s3://)
BACKUP_NAME="project-backup-$(date +'%Y-%m-%d_%H-%M-%S').tar.gz"
TMP_DIR="/tmp"
LOG_FILE="/var/log/backup_to_s3.log"

# LOGGING 
exec >> "$LOG_FILE" 2>&1   # Redirect stdout & stderr to log

echo "[$(date)] starting Backup ."

# CHECK IF S3 BUCKET IS ACCESSIBLE 
aws s3 ls "s3://$S3_BUCKET" >/dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "[$(date)] ERROR: S3 bucket s3://$S3_BUCKET is not accessible. Aborting backup."
    exit 1
fi
echo "[$(date)] S3 bucket s3://$S3_BUCKET is accessible."

# CREATE ARCHIVE 
tar -czf "$TMP_DIR/$BACKUP_NAME" -C "$(dirname "$SOURCE_DIR")" "$(basename "$SOURCE_DIR")"
if [ $? -ne 0 ]; then
    echo "[$(date)] ERROR: Failed to create archive."
    exit 1
fi
echo "[$(date)] Archive created at $TMP_DIR/$BACKUP_NAME."

# UPLOAD TO S3 WITH ENCRYPTION 
aws s3 cp "$TMP_DIR/$BACKUP_NAME" "s3://$S3_BUCKET/" --sse AES256
if [ $? -ne 0 ]; then
    echo "[$(date)] ERROR: Failed to upload backup to S3."
    rm -f "$TMP_DIR/$BACKUP_NAME"
    exit 1
fi
echo "[$(date)] Successfully uploaded $BACKUP_NAME to s3://$S3_BUCKET/."

# CLEANUP LOCAL FILE
rm -f "$TMP_DIR/$BACKUP_NAME"
echo "[$(date)] Backup completed successfully."
