package main

import (
	"encoding/json"
	"fmt"
	"net/http"
	"strconv"
)

type Response struct {
	Greetings string `json:"greetings,omitempty"`
	Version   int    `json:"version,omitempty"`
	Error     string `json:"error,omitempty"`
	Healthy   string `json:"healthy,omitempty"`
}

// Function to get the ordinal suffix for a number
func getOrdinalSuffix(n int) string {
	if n%100 >= 11 && n%100 <= 13 {
		return "th"
	}
	switch n % 10 {
	case 1:
		return "st"
	case 2:
		return "nd"
	case 3:
		return "rd"
	default:
		return "th"
	}
}

func greetingsHandler(w http.ResponseWriter, r *http.Request) {
	versionStr := r.URL.Query().Get("version")
	version, err := strconv.Atoi(versionStr)

	// Set the content type to application/json
	w.Header().Set("Content-Type", "application/json")

	if err == nil && version == 1 {
		// Return the greetings for version 1
		response := Response{
			Greetings: "Hello there",
			Version:   1,
		}
		json.NewEncoder(w).Encode(response)
	} else {
		// Return an error for other versions
		ordinal := fmt.Sprintf("%d%s", version, getOrdinalSuffix(version))
		response := Response{
			Error: fmt.Sprintf("%s version is invalid", ordinal),
		}
		http.Error(w, "404 Not Found", http.StatusNotFound)
		json.NewEncoder(w).Encode(response)
	}
}

func healthyHandler(w http.ResponseWriter, r *http.Request) {
	// Set the content type to application/json
	w.Header().Set("Content-Type", "application/json")

	// Return the healthy status
	response := Response{
		Healthy: "true",
	}
	json.NewEncoder(w).Encode(response)
}

func main() {
	// Handle the endpoints
	http.HandleFunc("/greetings", greetingsHandler)
	http.HandleFunc("/healthy", healthyHandler)

	// Start the server on port 8080
	http.ListenAndServe(":8000", nil)
}
