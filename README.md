Great — here is the updated **README.md** including the **GNU GPL v3.0** license reference.

---

# Backup to S3 Script

This repository contains a Bash script that creates a compressed backup of a local directory and uploads it to an Amazon S3 bucket with server-side encryption. The script is designed for automation (e.g., via cron) and logs its activity to a system log file.

## 📌 Features

* Creates a timestamped .tar.gz backup of a specified directory
* Validates S3 bucket accessibility before running
* Uploads the backup to Amazon S3 with AES-256 encryption
* Cleans up temporary backup files after upload
* Logs all activity (stdout and stderr) to /var/log/backup_to_s3.log

---

## 📂 Script Overview


SOURCE_DIR="/home/ec2-user/project"       # Folder to back up
S3_BUCKET="my-backup-bucket"              # S3 bucket name
BACKUP_NAME="project-backup-$(date +'%Y-%m-%d_%H-%M-%S').tar.gz"
TMP_DIR="/tmp"
LOG_FILE="/var/log/backup_to_s3.log"


Main script steps:

1. Redirect all output to the log file
2. Check S3 bucket availability
3. Create a compressed .tar.gz archive
4. Upload the archive to S3 using AES256 encryption
5. Delete the temporary archive file

---

## 🚀 Usage

### **1. Clone the Repository**

bash
git clone https://github.com/aunshk/Auto_backup_to_AWS_S3.git
cd Auto_backup_to_AWS_S3


### **2. Make the Script Executable**

bash
chmod +x backup_to_s3.sh


### **3. Configure the Script**

Edit the variables inside the script:

* SOURCE_DIR
* S3_BUCKET
* LOG_FILE (optional)

### **4. Run the Script**

bash
./backup_to_s3.sh


---

## 🔐 Requirements

* AWS CLI installed and configured
* IAM permissions enabling:

  * s3:ListBucket
  * s3:PutObject

Example minimal IAM policy:

json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:PutObject",
        "s3:ListBucket"
      ],
      "Resource": [
        "arn:aws:s3:::my-backup-bucket",
        "arn:aws:s3:::my-backup-bucket/*"
      ]
    }
  ]
}


---

## ⏱️ Optional: Automate with Cron

To run the backup daily at 2 AM:

bash
crontab -e


Add this line:


0 2 * * * /path/to/backup_to_s3.sh


---

## 📝 Logging

All logs are written to:


/var/log/backup_to_s3.log


Ensure the script has permission to write to that file.

---

## 📄 License — GNU General Public License v3.0

This project is licensed under the **GNU GPL v3.0** license.
You are free to use, modify, and distribute this script under the terms of the GPLv3.
See the LICENSE file in this repository for full license details.


