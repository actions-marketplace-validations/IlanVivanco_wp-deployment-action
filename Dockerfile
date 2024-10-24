FROM instrumentisto/rsync-ssh:latest

LABEL "com.github.actions.name"="WordPress Deployment Action"
LABEL "com.github.actions.description"="Easily deploy code from GitHub to WordPress on Pressable or WP Engine using an SSH private key and the rsync command."
LABEL "com.github.actions.color"="red"
LABEL "repository"="https://github.com/IlanVivanco/wp-deployment-action"
LABEL "maintainer"="Ilán Vivanco <ilanvivanco@gmail.com>"

RUN apk add bash php
ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
