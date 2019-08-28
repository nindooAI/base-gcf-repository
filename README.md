# base-gcf-repository

> Base template for GCF functions

## Standards

1. Every function must reside within the `src` folder
2. Every function must have its own folder
3. The folder name will be the display name of the function
4. Every folder must contain exactly one `.ts` function file
5. The function file name must be equal to the exported function within that same file

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
