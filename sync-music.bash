#! /bin/bash

# Suppression de Toutes les Bibliothèques Musicales
# find Musique/ -d -exec rm -r {} \;

# Synchronisation - MP3 ou flac
SAVEIFS=$IFS
IFS=$(echo -en "\n\b")
for i in `cat MUSIC_LIST.TXT`; do
	rsync -av $i Musique/ 2> /dev/null
done

# Conversion flac To mp3
find Musique/ -name '*.flac' \
	-exec /usr/local/bin/flac2mp3 {} \; 2> /dev/null

# Suppression fichiers flac
# find Musique/ -name '*.flac' \
#	-exec rm {} \; 2> /dev/null

# Suppression des .DS_STORE
find . -name .DS_Store \
	-exec rm {} \; 2> /dev/null

# Génération des Playlists
find . -name '*.mp3' \
	-execdir bash -c 'file="{}" ; printf "%s\n" "${file##*/}" >> "${PWD##*/}.m3u"' \;

if [ "$(du -sg Musique/ | awk {'print $1;'})" -lt "16" ]; then
	if [ -d "/Volumes/VOYAGER_16G/" ]; then
		find /Volumes/VOYAGER_16G/Musique/ -d -exec rm -r {} \;
		cp -f MUSIC_LIST.TXT /Volumes/VOYAGER_16G/
		rsync -av --exclude '*.jpg' --exclude '*.flac' Musique /Volumes/VOYAGER_16G/
	fi
fi
