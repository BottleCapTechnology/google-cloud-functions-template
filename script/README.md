# The scripts folder

This folder contains a few more items for customization and demonstration of the deployment process.

## `bootstrap`

This script simply sets up the repository and installs its dependencies.

## `deploy`

This is the script which actually executes the deployment of a function from a repository to a Google Cloud Function. There are a few items to change, if desired:

* `COMMON_FILES`: This is a list of files which you want grouped up alongside your function. Beyond the `package*` files, you could also include some database handling (via knexfile.js) or some logging logic.
* `FUNC`: This is where you would actually use the name of your function.

## `server`

This spins up an emulator to test out the Google Cloud Function locally.

## `trigger-deployment`

This is a demonstration of how to execute a call to the GitHub Deployments API. Your ChatOps system should make a similar request to trigger the GitHub Action to execute `script/deploy`.
