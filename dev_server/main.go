package main

import (
	"log"

	"github.com/pocketbase/pocketbase"
	"github.com/pocketbase/pocketbase/core"
	"github.com/pocketbase/pocketbase/plugins/migratecmd"
)

func main() {
    app := pocketbase.New()

	migratecmd.MustRegister(app, app.RootCmd, migratecmd.Config{
		Automigrate: true,
	})

    app.OnServe().BindFunc(func(se *core.ServeEvent) error {
        return se.Next()
    })

    if err := app.Start(); err != nil {
        log.Fatal(err)
    }
}