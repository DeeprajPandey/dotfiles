#!/bin/bash

if [ "$(tmux show-option -gqv @wg_weather_enabled)" = "1" ]; then
    curl -s wttr.in/?format=1
else
    echo ""
fi

