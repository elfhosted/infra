#!/bin/bash
# This script performs a restore of the autorestic locations to the local filesystem

PATH=$PATH:/usr/local/bin/
OUTPUT=/var/lib/node-exporter/textfiles/problem_autorestic_restores.prom

# Null the output file
echo > $OUTPUT

RESTORE_DIR=$(mktemp -d)
BACKUP_DIR=/backups

declare -a backuplocations=("k3s-server")
for backuplocation in ${backuplocations[@]}
do
    /usr/local/bin/autorestic restore -l ${backuplocation} --to $RESTORE_DIR/${backuplocation}
    MOST_RECENT_RESTORE=$(ls -Art $RESTORE_DIR/$backuplocation/backups/$backuplocation/ | grep -v pki | tail -n 1)
    echo du -s "$RESTORE_DIR/$backuplocation/$MOST_RECENT_RESTORE"
    FILESIZE_RESTORE=$(du -s "$RESTORE_DIR/$backuplocation/backups/$backuplocation/$MOST_RECENT_RESTORE" | cut -f1)
    TIMESTAMP_RESTORE=$(stat -c%Y "$RESTORE_DIR/$backuplocation/backups/$backuplocation/$MOST_RECENT_RESTORE")

    echo autorestic_restore_${backuplocation}_size $FILESIZE_RESTORE        >> $OUTPUT
    echo autorestic_restore_${backuplocation}_TIMESTAMP_RESTORE $TIMESTAMP_RESTORE  >> $OUTPUT

    # and also summarize the original size and timestamp
    MOST_RECENT_BACKUP=$(ls -Art $BACKUP_DIR/$backuplocation | tail -n 1)
    echo du -s "$BACKUP_DIR/$backuplocation/$MOST_RECENT_BACKUP"
    FILESIZE_BACKUP=$(du -s "$BACKUP_DIR/$backuplocation/$MOST_RECENT_BACKUP" | cut -f1)
    TIMESTAMP_BACKUP=$(stat -c%Y "$BACKUP_DIR/$backuplocation/$MOST_RECENT_BACKUP")

    echo autorestic_BACKUP_${backuplocation}_size $FILESIZE_BACKUP        >> $OUTPUT
    echo autorestic_BACKUP_${backuplocation}_TIMESTAMP_BACKUP $TIMESTAMP_BACKUP  >> $OUTPUT

done

# Tidy up temporary location
rm -rf $RESTORE_DIR