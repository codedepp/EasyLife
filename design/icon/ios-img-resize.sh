#!/bin/bash

cp "icon-1024.png" "20@2x.png"
cp "icon-1024.png" "20@3x.png"
cp "icon-1024.png" "29@2x.png"
cp "icon-1024.png" "29@3x.png"
cp "icon-1024.png" "40@2x.png"
cp "icon-1024.png" "40@3x.png"
cp "icon-1024.png" "60@2x.png"
cp "icon-1024.png" "60@3x.png"
cp "icon-1024.png" "ipad-20.png"
cp "icon-1024.png" "ipad-20@2x.png"
cp "icon-1024.png" "ipad-29.png"
cp "icon-1024.png" "ipad-29@2x.png"
cp "icon-1024.png" "ipad-40.png"
cp "icon-1024.png" "ipad-40@2x.png"
cp "icon-1024.png" "ipad-76.png"
cp "icon-1024.png" "ipad-76@2x.png"
cp "icon-1024.png" "ipad-83.5@2x.png"

/opt/ImageMagick/bin/mogrify -resize 40x40 "20@2x.png"
/opt/ImageMagick/bin/mogrify -resize 60x60 "20@3x.png"
/opt/ImageMagick/bin/mogrify -resize 58x58 "29@2x.png"
/opt/ImageMagick/bin/mogrify -resize 87x87 "29@3x.png"
/opt/ImageMagick/bin/mogrify -resize 80x80 "40@2x.png"
/opt/ImageMagick/bin/mogrify -resize 120x120 "40@3x.png"
/opt/ImageMagick/bin/mogrify -resize 120x120 "60@2x.png"
/opt/ImageMagick/bin/mogrify -resize 180x180 "60@3x.png"
/opt/ImageMagick/bin/mogrify -resize 20x20 "ipad-20.png"
/opt/ImageMagick/bin/mogrify -resize 40x40 "ipad-20@2x.png"
/opt/ImageMagick/bin/mogrify -resize 29x29 "ipad-29.png"
/opt/ImageMagick/bin/mogrify -resize 58x58 "ipad-29@2x.png"
/opt/ImageMagick/bin/mogrify -resize 40x40 "ipad-40.png"
/opt/ImageMagick/bin/mogrify -resize 80x80 "ipad-40@2x.png"
/opt/ImageMagick/bin/mogrify -resize 76x76 "ipad-76.png"
/opt/ImageMagick/bin/mogrify -resize 152x152 "ipad-76@2x.png"
/opt/ImageMagick/bin/mogrify -resize 167x167 "ipad-83.5@2x.png"