# WordPress Deployment Action

This GitHub Action set up automatic deployments using an SSH private key and the **rsync** command. Supports Pressable and WP Engine.

By default, the action will deploy the repository root directory, but you can optionally deploy a theme, plugin, or any other directory using the `SRC_PATH`. Likewise, if you need to specify a different destination directory, you can do so using `REMOTE_PATH`.

You can enable cache purging and PHP Link via the `CACHE_CLEAR` and `PHP_LINT` flags. Additionally, you can set up custom commands using the `SCRIPT` tag.

## GitHub Action workflow

1. Set up your [SSH key](#setting-up-your-ssh-key) on your server.

2. Create a new YML file in the directory `.github/workflows/` in the root of your repository. You can choose any name, e.g., `deploy-to-prod.yml`.

3. Add the following code to this new file, replacing values accordingly.

   **`> .github/workflows/deploy-to-prod.yml`**

   ```yml
   name: 📦 Production Deployment
   on:
      push:
         branches:
            - main
            - dev
            - 'feature/**'
      workflow_dispatch:
   env:
      SERVER_NAME: pressable # pressable or wpengine
      SERVER_ID: pressable-username # Pressable SFTP username or WP Engine environment name
      PROJECT_TYPE: theme # plugin or theme
      PROJECT_NAME: theme-name # Name of the plugin or theme
   jobs:
      build:
         name: 🚩 Deployment Job
         runs-on: ubuntu-latest
         steps:
         - name: 🚚 Getting latest code
           uses: actions/checkout@v4

         - name: 🔁 Starting Deployment
           uses: IlanVivanco/wp-deployment-action@main
           with:
               SSH_PRIVATE_KEY: ${{ secrets.SSH_KEY }}
               SERVER_ID: ${{ env.SERVER_ID }}
               SERVER_TYPE: ${{ env.SERVER_NAME }}
               REMOTE_PATH: 'wp-content/${{ env.PROJECT_TYPE }}s/${{ env.PROJECT_NAME }}'
               FLAGS: -azvri --inplace --delete --delete-excluded --exclude-from=.deployignore
               SCRIPT: 'bin/post-deploy.sh'
               PHP_LINT: TRUE
               CACHE_CLEAR: TRUE
   ```

4. Finally, push the latest changes to the repository, the action will do the rest.

   ![Magic](https://media.giphy.com/media/l3V0dy1zzyjbYTQQM/giphy.gif)

## Setting up your SSH key

1. [Generate a new SSH key pair](https://help.github.com/articles/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent/) as a special deploy key between your GitHub Repo and Pressable. The simplest method is to generate a key pair with a blank passphrase, which creates an unencrypted private key.

2. Add the public SSH key to your [Pressable](https://pressable.com/knowledgebase/connect-to-ssh-on-pressable/#connect-to-ssh-with-an-ssh-key/)/[WP Engine](https://wpengine.com/support/ssh-gateway/#Add_SSH_Key) configuration panel.

3. Store the private key in the GitHub repository as new [GitHub encrypted secret](https://docs.github.com/en/actions/reference/encrypted-secrets#creating-encrypted-secrets-for-a-repository) using the name `SSH_KEY` -as per this YML example-.

## Ignoring files

If you want some files to be ignored upon deployment, you can create a `.deployignore` file on your source directory, adding the exclude patterns —one per line—. Blank lines and lines starting with _#_ will be ignored.

**`> .deployignore`**

```bash
# Exclude rules
.*
bin
composer*
dist
gulp*
node_modules
package*
phpcs*
src
vendor
```

## Environment variables

### Required

| Name              | Type      | Usage                                                                                                       |
| ----------------- | --------- | ----------------------------------------------------------------------------------------------------------- |
| `SERVER_TYPE`     | _string_  | The type of server to deploy to. So far, only Pressable `preesable` and WP Engine `wpengine` are supported. |
| `SSH_PRIVATE_KEY` | _secrets_ | The private SSH key. You must save this in the GitHub Secrets and authorize it on Pressable or WP Engine.   |
| `SERVER_ID`       | _string_  | The SSH username for Pressable deployments or the install name for WP Engine deployments.                   |

### Optional

| Name          | Type     | Usage                                                                                                       |
| ------------- | -------- | ----------------------------------------------------------------------------------------------------------- |
| `REMOTE_PATH` | _string_ | The remote path on the server where files should be deployed. Defaults to the site root directory.          |
| `SRC_PATH`    | _string_ | Local path to the source files to deploy. Defaults to the repository root.                                  |
| `FLAGS`       | _string_ | Rsync flags to control the behavior of file synchronization. Defaults to `-azvri --inplace --exclude='.*'`. |
| `PHP_LINT`    | _string_ | Set to 'TRUE' to enable PHP linting before deployment. Defaults to 'FALSE'.                                 |
| `CACHE_CLEAR` | _string_ | Set to 'TRUE' to clear cache after deployment. Defaults to 'FALSE'.                                         |
| `SCRIPT`      | _string_ | Custom script to run on the remote server after deployment.                                                 |

### Additional Resources

-  [Generate a new SSH key pair](https://help.github.com/articles/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent/)
-  [Setting up SSH on Pressable](https://pressable.com/knowledgebase/how-to-create-ssh-keys/)
-  [Setting up SSH on WP Engine](https://wpengine.com/support/ssh-gateway/#Add_SSH_Key)
-  [Storing secrets in GitHub](https://docs.github.com/en/actions/reference/encrypted-secrets)

### Contributing

Contributions to this action are always welcome and highly encouraged.

### License & Attribution

-  Licensed as MIT &copy; [Ilán Vivanco](https://ilanvivanco.com).

-  This action was originally based on the work made by Alex Zuniga on [GitHub Action for WPE Site Deployments](https://github.com/wpengine/github-action-wpe-site-deploy).
