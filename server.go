package main

import (
	"context"
	"log"
	"net/http"
	"os"

	_ "github.com/lib/pq"

	"github.com/99designs/gqlgen/graphql/handler"
	"github.com/99designs/gqlgen/graphql/playground"
	"github.com/OSBC-LLC/apollo-subgraph-template/ent"
	"github.com/OSBC-LLC/apollo-subgraph-template/graph"

	kit_utils "github.com/sailsforce/gomicro-kit/utils"
)

const defaultPort = "8080"

func init() {
	if err := kit_utils.InitEnv(); err != nil {
		log.Println("error loading .env: ", err)
	}
}

func main() {
	port := os.Getenv("PORT")
	if port == "" {
		port = defaultPort
	}

	var entOptions []ent.Option
	entOptions = append(entOptions, ent.Debug())

	client, err := ent.Open("postgres", kit_utils.GetDSN(os.Getenv("DATABASE_URL")), entOptions...)
	if err != nil {
		log.Fatalf("failed opening connection to postgres: %v", err)
	}
	defer client.Close()

	// Run the auto migration tool.
	if os.Getenv("MIGRATE") == "true" {
		if err := client.Schema.Create(context.Background()); err != nil {
			log.Fatalf("failed created schema resources: %v", err)
		}
	}

	srv := handler.NewDefaultServer(graph.NewSchema(client))

	http.Handle("/", playground.Handler("GraphQL playground", "/query"))
	http.Handle("/query", srv)

	log.Printf("connect to http://localhost:%s/ for GraphQL playground", port)
	log.Fatal(http.ListenAndServe(":"+port, nil))
}
