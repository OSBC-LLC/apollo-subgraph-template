package main

import (
	"dagger.io/dagger"
	"dagger.io/dagger/core"

	"universe.dagger.io/docker"
	"universe.dagger.io/go"
)

dagger.#Plan & {
	client: {
		filesystem: ".": read: {
			contents: dagger.#FS

			exclude: [
				".github",
				".git",
				".env.example",
				".env.dagger.example",
				"bin",
				"build",
				"tmp",
			]
		}
		env: {
			SONAR_HOST_URL:  string | *"https://sonarcloud.io"
			SONAR_LOGIN:     string | *""
			GITHUB_HEAD_REF: string | *GITHUB_HEAD_REF
		}
	}

	actions: {
		deps: {
			vars: core.#NewSecret & {
				input:     client.filesystem.".".read.contents
				path:      ".env.dagger"
				trimSpace: true
			}
			sonarscanner:
				docker.#Build & {
					steps: [
						docker.#Pull & {
							source: "index.docker.io/sonarsource/sonar-scanner-cli"
						},
						docker.#Copy & {
							contents: client.filesystem.".".read.contents
							dest:     "/usr/src"
						},
					]
				}
		}

		build: go.#Build & {
			source: client.filesystem.".".read.contents
		}

		staticAnalysis: {
			sonarscanner:
				docker.#Run & {
					env: {
						GITHUB_BRANCH_NAME: "main"
						SONAR_LOGIN:        client.env.SONAR_LOGIN
						SONAR_HOST_URL:     client.env.SONAR_HOST_URL
					}
					workdir: "/usr/src"
					input:   deps.sonarscanner.output
				}
		}
	}
}
