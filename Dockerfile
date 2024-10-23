FROM instrumentisto/rsync-ssh:latest

LABEL "com.github.actions.name"="WordPress Deployment Action"
LABEL "com.github.actions.description"="Set up automatic deployments using an SSH private key and the rsync command. Supports Pressable and WP Engine."
LABEL "com.github.actions.icon"="upload-cloud"
LABEL "com.github.actions.color"="red"
LABEL "repository"="https://github.com/IlanVivanco/wp-deployment-action"
LABEL "maintainer"="Ilán Vivanco <ilanvivanco@gmail.com>"

RUN apk add bash php
ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
