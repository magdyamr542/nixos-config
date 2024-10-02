rsync -auv --exclude=.git --exclude=.gitignore --exclude=Vagrantfile $(pwd)/ /etc/nixos
