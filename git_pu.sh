#!/bin/bash
git add .;
git commit -m "NEWBUILD:$(date +%H:%M@%y.%m.%d)";
git push
