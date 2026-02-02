#!/usr/bin/env bash

# === Configurable Variables ===
BATTERY_PATH="/sys/class/power_supply/BAT0"
ALERT_FILE="$HOME/battery_alert.txt"

CRITICAL_LEVEL=30
SHIT_LEVEL=80

OVERRIDE_LEVEL=5              # Below this, snooze is ignored
CHECK_INTERVAL=1

SNOOZE_FILE="/tmp/battery_snooze_until"
SNOOZE_DURATION=180           # 3 minutes

SHIT_MODE_FILE="/tmp/battery_shit_mode"


# === Handle parameters ===
case "$1" in
    delay)
        BATTERY_LEVEL=$(cat "$BATTERY_PATH/capacity")

        if [[ "$BATTERY_LEVEL" -gt $OVERRIDE_LEVEL ]]; then
            date +%s | awk -v d="$SNOOZE_DURATION" '{print $1+d}' > "$SNOOZE_FILE"
            pkill -f 'rofi -e' 2>/dev/null
            exit 0
        else
            exit 1
        fi
        ;;
    shit)
        # toggle shit mode
        if [[ -f "$SHIT_MODE_FILE" ]]; then
            rm -f "$SHIT_MODE_FILE"
        else
            touch "$SHIT_MODE_FILE"
        fi
        exit 0
        ;;
    shit-on)
        touch "$SHIT_MODE_FILE"
        exit 0
        ;;
    shit-off)
        rm -f "$SHIT_MODE_FILE"
        exit 0
        ;;
esac


while true; do
    BATTERY_LEVEL=$(cat "$BATTERY_PATH/capacity")
    CHARGING_STATUS=$(cat "$BATTERY_PATH/status")
    NOW=$(date +%s)

    # === Decide active critical level ===
    if [[ -f "$SHIT_MODE_FILE" ]]; then
        ACTIVE_CRITICAL_LEVEL=$SHIT_LEVEL
    else
        ACTIVE_CRITICAL_LEVEL=$CRITICAL_LEVEL
    fi

    # === Snooze check ===
    if [[ -f "$SNOOZE_FILE" ]]; then
        SNOOZE_UNTIL=$(cat "$SNOOZE_FILE")

        if [[ "$BATTERY_LEVEL" -le $OVERRIDE_LEVEL ]]; then
            rm -f "$SNOOZE_FILE"
        elif [[ "$NOW" -lt "$SNOOZE_UNTIL" ]]; then
            sleep $CHECK_INTERVAL
            continue
        else
            rm -f "$SNOOZE_FILE"
        fi
    fi

    case "$CHARGING_STATUS" in
        Discharging)
            if [[ "$BATTERY_LEVEL" -le $ACTIVE_CRITICAL_LEVEL ]]; then
                rofi -e "$(~/scripts/batterylvl.sh)" -theme ~/.cache/wal/darkrofi.rasi &
                ROFI_PID=$!

                while kill -0 $ROFI_PID 2>/dev/null; do
                    CHARGING_STATUS=$(cat "$BATTERY_PATH/status")
                    [[ "$CHARGING_STATUS" != "Discharging" ]] && pkill -f 'rofi -e' && break
                    sleep $CHECK_INTERVAL
                done
            fi
            ;;
    esac

    sleep $CHECK_INTERVAL
done

