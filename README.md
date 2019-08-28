# base-gcf-repository

> Base template for GCF functions

## Running locally

```bash
npm start <functionName>
```

## Running with custom port

```bash
npm start <functionName> -- --port <port>
```

## Deploying

```
gcloud functions deploy <displayName> --runtime nodejs10 --<your-trigger> --entry-point <functionName> --env-vars-file ./envs.yaml
```
