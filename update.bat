@echo off
set /P comment=comment? 
git status
git add --all
git commit -am %comment%
git pull origin master
git push origin master