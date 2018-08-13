@echo off
set /P comment=comment? 
git status
git add --all
echo "added all items"
git commit -am %comment%
git pull origin master
echo "pulled all the records"
git push origin master
echo "pushes succesfully"