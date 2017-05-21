pushd /home/hanno/erprobe/grub-und-fstab

# echo '*.class' > .gitignore
git config --global user.email "gerdkolano@wp.pl"
git config --global user.name gerdkolano
git config --global credential.helper 'cache --timeout=360000'

\## Im Browser:
\## https://github.com/gerdkolano/
\## Sign in
\## gerdkolano g körperteil
\## New
\## Altpapier # Repository name
\## Abfuhrtermine der Wertstoffe # Description

pushd /home/hanno/erprobe/grub-und-fstab
# beim ersten Mal: git init
git add .
git commit -m "erstes commit"
git remote add origin https://github.com/gerdkolano/altpapier.git

pushd /var/www/html/erprobe/altpapier
git add .
git commit -m "README.md 10"
git push -u origin master

Eine Kopie auf fadi oder zoe herstellen und nutzen
Dort einloggen, dann:

pushd /daten/srv/www/htdocs/erprobe/
mv altpapier zu-loeschen-altpapier
git clone https://github.com/gerdkolano/altpapier.git
javac altpapier/altpapier/Altpapier.java && java -classpath altpapier altpapier.Altpapier  > altpapier/abholtermine.html
php altpapier/abholtermine.php | less

remove unwanted swap files
git ls-files | grep '\.swp$' | xargs git rm

