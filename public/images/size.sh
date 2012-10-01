for i in *_button.png;do b=$(basename $i .png);convert -resize 70x $i $b.s.png;done
