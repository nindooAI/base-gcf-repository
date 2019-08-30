# base-gcf-repository

> Base template for GCF functions

## Required dependencies

In order to run these scipts you'll need to have:

- Gcloud SDK installed and authenticated
- Node v10.x or newer

## Standards

1. Every function must reside within the `src/functions` folder
2. Every function must have its own folder
   1. The folder name will be the display name of the function
3. Every folder must contain exactly one `.ts` function file
4. The function file name must be equal to the exported function within that same file

### Environment Variables

All environment variables for Cloud Functions are described into one single `envs.yaml` file. This file, if it exists, will automatically be added to all deployed functions.

## Running locally

```bash
npm start <functionName>
```

## Running with custom port

```bash
npm start <functionName> -- --port <port>
```

## Deploying

Interactive shell

```
npm run deploy:single
```

Deploy all functions

```
npm run deploy
```

## Package.json config

You can set the triggers and methods for each function by changing the `functionConfig` key within your `package.json` file:

```jsonc
{
  // ... Rest of file
  "functionConfig": {
    "display-name": {
      "trigger": {
        "type": "gcloud trigger types (trigger-http, trigger-bucket and so on...)",
        "name": "if trigger is not of type http, then it requires the resource name, put it here (the name of the bucket for example)"
      },
      "methods": ["GET", "POST"] // methods this function will respond to
    }
  },
  // ...
}
```
