# Proverbs-back


## App overview


## App variables


## Build and Push Docker Image

-  Build docker images

```bash
docker build -t konewoumar/proverbs-back:${version} .
```

-  Athenticate for registry

```bash
docker login -u ${username}
```

-  Push docker images

```bash
docker push konewoumar/proverbs-back:${version}
```
