#!/bin/bash

# 2018, Georg Sauthoff <mail@gms.tf>
# 2021, Wei Peng <me@1pengw.com>
# SPDX-License-Identifier: GPL-3.0-or-later

# called by dracut
check() {
    #require_binaries agetty || return 1
    # 0 enables by default, 255 only on request
    return 0
}

# called by dracut
depends() {
    return 0
}

# called by dracut
# i.e. during: dracut --print-cmdline
cmdline() {
    printf " plymouth.enable=0"
}

# called by dracut
install() {
    inst_simple "${systemdsystemunitdir}/serial-getty@.service" "${systemdsystemunitdir}/serial-getty@.service"
    inst_simple "${moddir}/systemd-ask-password-serial@.service" "${systemdsystemunitdir}/systemd-ask-password-serial@.service"
    ls /dev/ttyS* | xargs -n 1 basename | while read -r tty; do
    #for tty in ttyS0 ttyS4; do
        systemctl --root "$initdir" enable serial-getty@"$tty".service
        systemctl --root "$initdir" enable systemd-ask-password-serial@"$tty".service
    done
    return 0
}

