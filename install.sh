#!/bin/bash

BASE=$(dirname "$0")

out=$(grep -e "3rdlvl-unified-symbols-en" /usr/share/X11/xkb/symbols/us)
if [ -z "$( grep -e "3rdlvl-unified-symbols-en" /usr/share/X11/xkb/symbols/us )" ]; then
    sudo bash -c "cat $BASE/symbols/3rdlvl-unified-symbols-en >> /usr/share/X11/xkb/symbols/us"
fi
if [ -z "$( grep -e "3rdlvl-unified-symbols-ru" /usr/share/X11/xkb/symbols/ru )" ]; then
    sudo bash -c "cat $BASE/symbols/3rdlvl-unified-symbols-ru >> /usr/share/X11/xkb/symbols/ru"
fi

# Edit /usr/share/X11/xkb/rules/evdev.lst

sudo sed -i -E 's/\s*3rdlvl-unified-symbols.*//g' /usr/share/X11/xkb/rules/evdev.lst
sudo sed -i -E 's/(! variant)/\1\n  3rdlvl-unified-symbols-en         us: English (3rd lvl unified symbols)\n  3rdlvl-unified-symbols-ru         ru: Russian (3rd lvl unified symbols)/g' /usr/share/X11/xkb/rules/evdev.lst

# Edit /usr/share/X11/xkb/rules/evdev.xml

sudo "$BASE/helper/xmladd.py" /usr/share/X11/xkb/rules/evdev.xml "$BASE/rules/variant_en" "$BASE/rules/variant_ru" /tmp/evdev.xml
sudo rm /usr/share/X11/xkb/rules/evdev.xml
sudo mv /tmp/evdev.xml /usr/share/X11/xkb/rules/evdev.xml

# Show further instructions
echo -e "\e[32mDone! Please log out and log in again to activate the new keyboard layouts.\e[0m"
echo
