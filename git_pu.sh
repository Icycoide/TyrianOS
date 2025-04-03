#!/bin/bash
git add .;
git commit -m "NEWBUILD:$(date +%I:%M@%y.%m.%d)";
git push
