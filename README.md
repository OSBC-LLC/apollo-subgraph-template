[![CircleCI](https://dl.circleci.com/status-badge/img/gh/OSBC-LLC/apollo-subgraph-template/tree/main.svg?style=svg)](https://dl.circleci.com/status-badge/redirect/gh/OSBC-LLC/apollo-subgraph-template/tree/main)

# apollo-subgraph-template
Template to create a new Apollo subgraph service using Entgo, Gqlgen, and some CI

## Prerequisites
- [pre-commit cli](https://pre-commit.com/)
- [docker](https://www.docker.com/products/docker-desktop/)
- [golang](https://go.dev/)
- [dagger](https://dagger.io/)
- [golang-ci](https://github.com/golangci/golangci-lint)

## Common Docs / Links
- [Entgo ORM](https://entgo.io/)
- [Gqlgen GraphQL Server](https://gqlgen.com/)

## Initial Setup
Take a look at these files and do any necessary changes to paths, names, or config details.

- go.mod
- Dockerfile
- docker-compose.psql.yml
- docker-compose.yml
- gqlgen.yml
- cue.mod/module.cue
- sonar-project.properties

This project template already has two objects: **Account** and **Tenant**. Feel free to remove and delete those files from the `ent/schema/` route.
This template also includes a custom ID type of UUID located in the same schema directory.

## Common Commands
These are common commands to generate code, build the project, run pre-commit hooks, start up docker, and so on.

**Generate all code for Entgo & Gqlgen**
```bash
go generate ./...
```

**Build project binary to bin/**
```bash
make build
```

**Dagger CI commands**
```bash
# Init dagger once installed
dagger project init

# Install all dagger files to /pkg dir
dagger project update
```

**Docker commands**
```bash
# Start only postgres database
make dp

# Build all docker images
make db

# Start both docker images
make du

# Run both db & du commands
make da
```

**Pre-commit commands**
```
# Force run all pre-commit hooks
pre-commit run --all-files
```
