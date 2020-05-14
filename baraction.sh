#!/bin/sh
# baraction.sh file for spectrwm status bar.
# Functions inspired on dwm_blocks.
# All bar functions works with FreeBSD. I have not test with any linux but I am certain at least one functions may need a modification.

#IDENTIFIER="unicode"

bar_date () {
    DATE=$(date "+%a %b %d, %Y %r")
    if [ "$IDENTIFIER" = "unicode" ]; then 
        printf " %s" "$DATE"
    else
        printf "DT %s" "$DATE"
    fi
}

bar_weather () {
    LOCATION=San_Francisco
    if [ "$IDENTIFIER" = "unicode" ]; then
        printf "%s" "$(curl -s wttr.in/$LOCATION?format=1)"
    else
        printf "WTTR: %s" "$(curl -s wttr.in/$LOCATION?format=1 | grep -o "[0-9].*")"
    fi
}

bar_keyboard () {
    KBLayout=$(setxkbmap -query | awk '/layout/{print $2}')
    if [ "$IDENTIFIER " = "unicode" ]; then
        printf " %s" "$KBLayout"
    else
        printf "KEYB: %s" "$KBLayout"
    fi
}

bar_memory () {
    RAM=$(free | awk 'NR==18{print $6}')
    if [ "$IDENTIFIER" = "unicode" ]; then
        printf " %s" "$RAM"
    else
        printf "RAM: %s" "$RAM"
    fi
}

bar_disk () {
    SSD=$(df -h | awk 'NR==4{print $3, $5}')
    if [ "$IDENTIFIER" = "unicode" ]; then
        printf " %s" "$SSD"
    else
        printf "SSD: %s" "$SSD"
    fi
}

bar_network () {
    PRIVATE=$(ifconfig -a | grep 'inet 192' | awk '{print $2}')
    PUBLIC=$(curl -s https://ipinfo.io/ip)
    if [ "$IDENTIFIER" = "unicode" ]; then
        printf "歷 %s - %s" "$PRIVATE" "$PUBLIC"
    else
        printf "IP: %s - %s" "$PRIVATE" "$PUBLIC"
    fi
}

bar_vpn () {
    VPN=$(ifconfig -a | grep tun0 | grep inet | wc -l)
    if [ $VPN == 1 ]; then
        if [ "$IDENTIFIER" = "unicode" ]; then
            printf "VPN  %s"
        else
            printf "VPN:On"
        fi
    else
        if [ "$IDENTIFIER" = "unicode" ]; then
            printf "VPN  %s"
        else
            printf "VPN:Off"
        fi
    fi
}

while :; do
    echo "| $(bar_network) | $(bar_weather) | [$(bar_memory) [$(bar_disk)] | $(bar_vpn) |"
    sleep 5
done
