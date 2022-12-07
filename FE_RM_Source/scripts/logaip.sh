cd /c/Users/Mike/My\ Documents/My\ Games/Battlezone\ Combat\ Commander/FE/logs/
tail -f "$( ls -Art *team_6* | tail -n 1)" | grep Plan20

cat "$( ls -Art *team_6* | tail -n 1)" | grep Plan20