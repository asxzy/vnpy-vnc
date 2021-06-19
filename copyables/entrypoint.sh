#!/bin/bash
set -e

# VNC default no password
export X11VNC_AUTH="-nopw"

# look for VNC password file in order (first match is used)
passwd_files=(
  /root/.vnc/passwd
  /run/secrets/vncpasswd
)

for passwd_file in ${passwd_files[@]}; do
  if [[ -f ${passwd_file} ]]; then
    export X11VNC_AUTH="-rfbauth ${passwd_file}"
    break
  fi
done

# override above if VNC_PASSWORD env var is set (insecure!)
if [[ "$VNC_PASSWORD" != "" ]]; then
  export X11VNC_AUTH="-passwd $VNC_PASSWORD"
fi

# make sure .config dir exists
mkdir -p /root/.config
# chown vnpy:vnpy /root/.config

# # set sizes for both VNC screen & VNPY window
: ${VNC_SCREEN_SIZE:='1920x1080'}
IFS='x' read SCREEN_WIDTH SCREEN_HEIGHT <<< "${VNC_SCREEN_SIZE}"
export VNC_SCREEN="${SCREEN_WIDTH}x${SCREEN_HEIGHT}x24"

exec "$@"
