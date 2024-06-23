package main

import (
	"log"
	"net/http"
	"os"

	ginErrors "github.com/Kamaalio/kamaalgo/gin/errors"
	"github.com/Kamaalio/kamaalgo/strings"
	"github.com/gin-gonic/gin"
)

func main() {
	serverAddress, err := strings.Unwrap(os.Getenv("SERVER_ADDRESS"))
	if err != nil {
		log.Fatalln("SERVER_ADDRESS is undefined")
	}

	engine := gin.Default()
	engine.SetTrustedProxies(nil)
	engine.GET("/ping", func(context *gin.Context) {
		context.JSON(http.StatusOK, pingResponse{Message: "pong"})
	})
	engine.NoRoute(func(context *gin.Context) {
		ginErrors.ErrorHandler(context, ginErrors.Error{Status: http.StatusNotFound, Message: "Not found"})
	})

	engine.Run(serverAddress)
}

type pingResponse struct {
	Message string `json:"message"`
}
