#!/bin/bash

# no longer required
true

# A very hacky workaround to https://github.com/cilium/cilium/issues/33395
# systemctl stop systemd-journald.service
# cat /dev/null > /var/log/syslog
# cat /dev/null > /var/log/kern.log
