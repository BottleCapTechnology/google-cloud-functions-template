# google-cloud-functions-template

This is a template repository designed to make it super easy to deploy Node.js code to [Google Cloud Functions](https://cloud.google.com/functions/). As well, it comes with a GitHub Actions workflow, designed to be triggered remotely.

## Using this template

After cloning this repo, all you really need to do is replace the words `sampleFunction` and `sample-function` with the name of your function, and define your function code in `sampleFunction.js`. The repo is totally ready to be deployed using the `gcloud` utility, provided you have configured the necessary environment variables.

## Secrets / Environment variables

All of the following are required as [Secrets](https://developer.github.com/actions/creating-workflows/storing-secrets/) stored in your repository, or as environment variables if you're deploying locally.

* `PROJECT_ID`: This is the [name of your project](https://cloud.google.com/storage/docs/projects)
* `GOOGLE_APPLICATION_CREDENTIALS`: The base64-encoded service account key, exported as JSON
   * For information about service account keys please see the [Google Cloud docs](https://cloud.google.com/sdk/docs/authorizing)
* `FUNCTION_BUCKET`: This is the [name of your Google Cloud Storage bucket](https://cloud.google.com/functions/docs/deploying/) which contains your funcion's code.

For more information about using Secrets in GitHub Actions please see the [Actions docs](https://developer.github.com/actions/creating-workflows/storing-secrets/)

## Deploying

Provided you've set those secrets correctly up above, you can deploy your function at any time by issuing a call to [GitHub's Deployments API](https://developer.github.com/v3/repos/deployments/#create-a-deployment), like this:

```bash
curl -u $USER:$PASSWORD \
  -H "Accept: application/vnd.github.ant-man-preview+json" \
  -X POST \
  https://api.github.com/repos/$owner/$repo/deployments \
  -d '{"ref": "production"}'
```

The final function will be hosted at: `https://$REGION-$PROJECT_ID.cloudfunctions.net/$FUNCTION_NAME`

### Deploying to a staging environment

In addition to the default `production` environment, the workflow/deploy script also supports sending a function to a staging environment:

```bash
curl -u $USER:$PASSWORD \
  -H "Accept: application/vnd.github.ant-man-preview+json" \
  -X POST \
  https://api.github.com/repos/$owner/$repo/deployments \
  -d '{"ref": "production", "environment": "staging"}'
```

It does this by rewriting the function name on deployment to be prepended with `staging__`.
