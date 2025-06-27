while true
do

    # date n time
    date=$(date +'%A, %b %d')
    time=$(date +'%H%M')

    # brightness
    brtval=$(brightnessctl get)
    brt=$(echo "scale=2; $brtval / 255 * 100" | bc)
    brt=${brt%.00}%

    # cpu temp
    temp=$(( $(cat /sys/class/thermal/thermal_zone0/temp) / 1000 ))°C

    # mem
    mem=$(free -h | grep Mem: | awk '{print $3}' | sed 's/Gi/g/')

    # vol
    volstr=$(wpctl get-volume @DEFAULT_AUDIO_SINK@)
    vol=$(echo "$volstr" | awk '{print $2 * 100}')%

    # bat
    bat=$(cat /sys/class/power_supply/BAT0/capacity)%

    if echo "$volstr" | grep -q MUTED; then
	vol=󰖁
    else
	vol="󰕾 $vol"
    fi

    echo "$vol︲ 󰆼 $mem  $temp ︲ 󰃝 $brt ︲ 󰄌 $bat ︲ $date  $time "
    sleep 1
done
    
