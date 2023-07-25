#!/bin/bash

THEMES=(
    aquamarine
    dark
    dracula
    hotline
    hotpink
    maroon
    nord
    organizr
    overseerr
    plex
    space-gray
)

for THEME in "${THEMES[@]}"; do
    mkdir -p ../theme-park/$THEME
    for MIDDLEWARE in $(ls middleware*); do
        cp $MIDDLEWARE ../theme-park/$THEME/$(echo $MIDDLEWARE | cut -f1 -d.)-$THEME.yaml
    done
    gsed -i s/THEME_NAME_HERE/$THEME/ ../theme-park/$THEME/*
done