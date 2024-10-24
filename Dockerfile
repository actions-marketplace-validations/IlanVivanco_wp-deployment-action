FROM instrumentisto/rsync-ssh:latest

LABEL "com.github.actions.name"="WordPress Deployment Action"
LABEL "com.github.actions.description"="It allows you to easily deploy code directly from GitHub to a WordPress environment hosted on Pressable or WP Engine by using an SSH private key and the rsync command."
LABEL "com.github.actions.icon"="upload-cloud"
LABEL "com.github.actions.color"="red"
LABEL "repository"="https://github.com/IlanVivanco/wp-deployment-action"
LABEL "maintainer"="Ilán Vivanco <ilanvivanco@gmail.com>"

RUN apk add bash php
ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
