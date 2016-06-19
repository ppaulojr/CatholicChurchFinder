#!/bin/bash

set -e

convert -resize 171x171 iTunesArtwork.png Icon@3x.png
convert -resize 114x114 iTunesArtwork.png Icon@2x.png
convert -resize 57x57 iTunesArtwork.png Icon.png
