#!/usr/bin/env bash

PATH=$PATH:$(nix-build '<nixpkgs>' -A wget)/bin
PATH=$PATH:$(nix-build '<nixpkgs>' -A libxslt.bin)/bin

# Copyright (C) 2010-2015 Christophe Delord
# http://www.cdsoft.fr/pod
#
# pod.sh is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published
# by the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# pod.sh is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with pod.sh.  If not, see <http://www.gnu.org/licenses/>.

# Original idea: BashPodder (http://lincgeek.org/bashpodder/)

# audio and video directories
PODCASTS=~/Podcasts
AUDIO=Audio
VIDEO=Video

# Default tempo factor for mp3 files
TEMPO=1 # listen podcasts 1.5 x faster

# Database containing the already downloaded URLs
DB=~/.poddb

# Temporary files
PARTIAL=/tmp/.pod

# Get on screen notifications
NOTIFICATION=true

# The configuration file defines the URL of the RSS feeds.
CONF=$PARTIAL/pod.conf
mkdir -p $(dirname $CONF)
cat <<EOF >$CONF
# podcast name      tempo[^1]   URL

SkepticsGuide                    http://www.theskepticsguide.org/feed

#[1]: if tempo is not defined, $TEMPO is used as the default tempo
#01netTV                         http://feeds.feedburner.com/LaChaineTechno?format=xml
#12_Min                          http://feeds.feedburner.com/12minutesdemp3
#56Kast                          http://www.liberation.fr/podcast/40/
#AppLoad                         http://feeds2.feedburner.com/appload
##Apprendre_l_anglais             http://www.anglaispod.com/apprendre.xml
##Atelier_Numérique               http://podcast.bfmradio.fr/channel9/BFMchannel9.xml
#Bazingcast                      http://feeds.feedburner.com/bazingcast_mp3
#Ciel_et_Espace                  http://www.cieletespaceradio.fr/podcast.php
#CONTINENT_SCIENCES              http://radiofrance-podcast.net/podcast09/rss_16256.xml
##Deconnecast                     http://www.deconnecast.fr/feed/
#De_quoi_je_me_mail              http://podcast.rmc.fr/channel35/RMCInfochannel35.xml
#Divergence_Numérique            http://podcasts.divergence-fm.org/divergencenumerique.xml
##En_Flux_Libre                   http://enfluxlibre.tuxfamily.org/?feed=rss2
#En_quête_de_science             http://www.europe1.fr/podcasts/en-quete-de-science.xml
#FSPod                           http://rss.futura-sciences.com/fs/podcast
#Indesciences                    http://feeds.soundcloud.com/users/soundcloud:users:59221717/sounds.rss
#Info_sciences                   http://radiofrance-podcast.net/podcast09/rss_11074.xml
#La_folle_histoire_de_l_Univers  http://www.florenceporcel.com/podcast/lfhdu.xml
#La_Grotte_Du_Barbu              http://feeds.feedburner.com/lagrottedubarbu/bPUL
#LA_MARCHE_DES_SCIENCES          http://radiofrance-podcast.net/podcast09/rss_11193.xml
#L_apéro_du_Captain              http://feeds.feedburner.com/LaperoDuCaptain
##La_revue_du_net                 http://www.europe1.fr/podcasts/c-est-pas-tres-net.xml
#La_science_en_question          http://radiofrance-podcast.net/podcast09/rss_10336.xml
#La_tête_au_carré                http://radiofrance-podcast.net/podcast09/rss_10212
##La_voix_du_libre-capsule        http://feeds.feedburner.com/capsulemp3vdl?format=xml
##La_voix_du_libre-entrevue       http://feeds.feedburner.com/entrevuesoggvdl?format=xml
##La_voix_du_libre                http://feeds.feedburner.com/podcastoggvdl?format=xml
##Le_7-9                          http://radiofrance-podcast.net/podcast09/rss_11992.xml
##Le_bruit_du_net                 http://radiofrance-podcast.net/podcast09/rss_11064.xml
#L_écho_des_Gnous                http://www.chtinux.org/podcast/feed.xml
#L_éclectique_show               http://feeds.feedburner.com/eclectiqueshow
#Le_rendez-vous_Tech             http://feeds2.feedburner.com/lerendezvoustech
##Libre_FM                        http://s.libre.fm/podcast.rss
##L_innovation_du_jour            http://cdn-new-europe1.ladmedia.fr/var/exports/podcasts/sound/Innovation.xml
#NipDev                          http://feeds.feedburner.com/NipDev
#NipLife                         http://feeds.feedburner.com/NiptechPodcastNiplife
#NipSource                       http://feeds.feedburner.com/NipcastNipsource
#NipTech                         http://feeds.feedburner.com/niptechpodcast/
#Nouveau_monde                   http://radiofrance-podcast.net/podcast09/rss_18998.xml
#nouvo                           http://nouvo.ch/feeds/videos
##Oh_La_Radio                     http://feeds.feedburner.com/OhLaRadio
#Parole_de_Tux                   http://www.captainposix.net/RSSPodcast/feeditunes.xml
#Podcast_Science                 http://feeds.feedburner.com/PodcastScience
##Random_Radio                    http://fz-corp.net/podcast/podcast.xml
##Revue_de_presque                http://www.europe1.fr/podcasts/revue-de-presque.xml
#Sang_libre               1      http://libre.tuxakadjseb.net/?feed=rss2
#SCIENCE_PUBLIQUE                http://radiofrance-podcast.net/podcast09/rss_10192.xml
##Symbiose                        http://www.dogmazic.net/radio/groupePod.php?f=mp3&usr=&groupe=Symbiose
##Un_jour_sur_la_toile            http://radiofrance-podcast.net/podcast09/rss_10274.xml
#Vie_artificielle                http://feeds.feedburner.com/vieartificielle
EOF

PARSE=$PARTIAL/parse_enclosure.xsl
mkdir -p $(dirname $PARSE)
cat <<EOF >$PARSE
<?xml version="1.0"?>
<stylesheet version="1.0"
    xmlns="http://www.w3.org/1999/XSL/Transform">
    <output method="text"/>
    <template match="/">
        <apply-templates select="/rss/channel/item/enclosure"/>
    </template>
    <template match="enclosure">
        <value-of select="@url"/><text>&#10;</text>
    </template>
</stylesheet>
EOF

mkdir -p $AUDIO
mkdir -p $VIDEO

echo "*** $(basename $0) ***"

LOCKFILE=$PARTIAL/lock
if [ -e $LOCKFILE ]
then
    echo "$(basename $0) is already running..."
    exit 1
fi
trap "rm -f $LOCKFILE; rm -rf $PARTIAL; exit" EXIT INT TERM
echo $$ > $LOCKFILE

mkdir -p $PODCASTS/$AUDIO
mkdir -p $PODCASTS/$VIDEO
cd $PODCASTS

mkdir -p $PARTIAL

# The database must exist. Create it empty otherwise.
touch $DB

# Wait for an internet connection
while ! wget -q --tries=10 --timeout=20 --spider http://google.com
do
    sleep 60
done

# number of episodes downloaded
n=0

# Parse each line of the configuration file
cat $CONF | while read nom tempo podcast
do
    case "$podcast" in
        "")     # 2 arguments => the tempo is not defined, let take the default tempo ($TEMPO)
                podcast=$tempo; tempo=$TEMPO
                ;;
        *)      # 3 arguments => the tempo is defined for this podcast
                ;;
    esac
    case "$nom" in
        "")     # empty line => ignored
                ;;
        \#*)    # comment line => ignored
                ;;
        *)  # line with a podcast RSS feed => parse the RSS feed and download new episodes
            echo "* parse $nom ($podcast)"
            # get all episodes
            file=$(xsltproc $PARSE $podcast 2> /dev/null || wget -T 60 -t 1 -q $podcast -O - | tr '\r' '\n' | tr \' \" | sed -n "s/></>\n</gp" | sed -n 's/.*url="\([^"]*\)".*/\1/p')
            for url in $file
            do
                case "$url" in
                    (*.jpg|*.jpeg|*.png|*.JPG|*.JPEG|*.gif) # ignore images
                                                            ;;
                    (*) # not an image, it may be something to watch or listen to
                        if ! grep -q "$url" $DB
                        then
                            # not in the database => new episode to download
                            echo "*     $(basename $url)"
                            #echo "url = $url"
                            OUT=$nom-$(echo "$url" | awk -F'/' {'print $NF'} | awk -F'=' {'print $NF'} | awk -F'?' {'print $1'})
                            if wget -t 10 -c -q -O $PARTIAL/$OUT "$url"
                            then
                                NEW=$OUT
                                DATE=$(stat -c %y $PARTIAL/$OUT | sed 's/^..\(..\)-\(..\)-\(..\) \(..\):\(..\).*/\1\2\3\4\5/')
                                # Normalize the extension
                                NEW=${NEW/.MP3/.mp3}
                                NEW=${NEW/.MP4/.mp4}
                                # Speedup with the current tempo
                                case $NEW in
                                    (*.mp4) # video are not accelerated
                                            mv $PARTIAL/$OUT $PARTIAL/$DATE-$NEW
                                            ;;
                                    (*.mp3) # audio is accelerated according to the selected tempo
                                            case $tempo in
                                                (1) # tempo = 1 => no acceleration
                                                    mv $PARTIAL/$OUT $PARTIAL/$DATE-$NEW
                                                    ;;
                                                (*) # tempo != 1 => acceleration
                                                    if (ffmpeg -i "$PARTIAL/$OUT" -filter:a "atempo=$tempo" -c:a libmp3lame -q:a 4 "$PARTIAL/$DATE-$NEW" > /dev/null 2> /dev/null)
                                                    then
                                                        touch -r "$PARTIAL/$OUT" "$PARTIAL/$DATE-$NEW"
                                                    else
                                                        rm -f "$PARTIAL/$DATE-$NEW"
                                                    fi
                                                    rm "$PARTIAL/$OUT"
                                                    ;;
                                            esac
                                            ;;
                                    (*)     # other file types are not accelerated
                                            mv $PARTIAL/$OUT $PARTIAL/$DATE-$NEW
                                            ;;
                                esac
                                if [ -e $PARTIAL/$DATE-$NEW ]
                                then
                                    # copy audio and video episodes in $AUDIO and $VIDEO
                                    case $NEW in
                                        (*.mp3|*.ogg)   mv $PARTIAL/$DATE-$NEW $PODCASTS/$AUDIO/$DATE-$NEW ;;
                                        (*)             mv $PARTIAL/$DATE-$NEW $PODCASTS/$VIDEO/$DATE-$NEW ;;
                                    esac
                                    $NOTIFICATION && notify-send -c transfer.complete "$nom: new podcast" "$NEW"
                                    echo $url >> $DB
                                    n=$((n+1))
                                fi
                            fi
                        fi
                        ;;
                esac
            done
            ;;
    esac
done

# done => remove configuration files
rm -f $CONF $PARSE

if [ $n -gt 0 ]
then
    [ $n -gt 1 ] && s="s" || s=""
    $NOTIFICATION && notify-send -c transfer "Podcasts" "$n new episode$s downloaded"
fi

# remove lock and partially downloaded files, sleep for 2 hours and try again
rm -f $LOCKFILE
rm -rf $PARTIAL
echo "*** done ($(date)) ***"
# for some unexplained (yet) reasons, the main loop may be exited after some
# episodes are downloaded. As a workaround the script is restarted immediately
# when $n > 0 in case some new episodes were not downloaded.
# When every is done; we wait for 2 hours before restarting.
[ $n -gt 0 ] || sleep $((2*3600))
exec $0 $*
