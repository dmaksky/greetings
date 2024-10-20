package main

import (
	"encoding/json"
	"net/http"
	"net/http/httptest"
	"reflect"
	"testing"
)

func TestGreetingsHandler_Version1(t *testing.T) {
	req, err := http.NewRequest("GET", "/greetings?version=1", nil)
	if err != nil {
		t.Fatal(err)
	}

	rr := httptest.NewRecorder()
	handler := http.HandlerFunc(greetingsHandler)

	handler.ServeHTTP(rr, req)

	// Check the status code is what we expect
	if status := rr.Code; status != http.StatusOK {
		t.Errorf("handler returned wrong status code: got %v want %v",
			status, http.StatusOK)
	}

	// Decode the response
	var actual Response
	if err := json.Unmarshal(rr.Body.Bytes(), &actual); err != nil {
		t.Fatalf("could not decode response: %v", err)
	}

	// Expected response
	expected := Response{
		Greetings: "Hello there",
		Version:   1,
	}

	// Compare the actual response to the expected response
	if !reflect.DeepEqual(actual, expected) {
		t.Errorf("handler returned unexpected body: got %v want %v",
			actual, expected)
	}
}

func TestGreetingsHandler_InvalidVersion(t *testing.T) {
	req, err := http.NewRequest("GET", "/greetings?version=2", nil)
	if err != nil {
		t.Fatal(err)
	}

	rr := httptest.NewRecorder()
	handler := http.HandlerFunc(greetingsHandler)

	handler.ServeHTTP(rr, req)

	// Check the status code is what we expect
	if status := rr.Code; status != http.StatusNotFound {
		t.Errorf("handler returned wrong status code: got %v want %v",
			status, http.StatusOK)
	}

	// Decode the response
	var actual Response
	if err := json.Unmarshal(rr.Body.Bytes(), &actual); err != nil {
		t.Fatalf("could not decode response: %v", err)
	}

	// Expected response for 2nd version
	expected := Response{
		Error: "2nd version is invalid",
	}

	// Compare the actual response to the expected response
	if !reflect.DeepEqual(actual, expected) {
		t.Errorf("handler returned unexpected body: got %v want %v",
			actual, expected)
	}

	// Test with another version
	req, err = http.NewRequest("GET", "/greetings?version=10", nil)
	if err != nil {
		t.Fatal(err)
	}

	rr = httptest.NewRecorder()
	handler.ServeHTTP(rr, req)

	// Decode the response
	if err := json.Unmarshal(rr.Body.Bytes(), &actual); err != nil {
		t.Fatalf("could not decode response: %v", err)
	}

	// Expected response for 10th version
	expected = Response{
		Error: "10th version is invalid",
	}

	// Compare the actual response to the expected response
	if !reflect.DeepEqual(actual, expected) {
		t.Errorf("handler returned unexpected body: got %v want %v",
			actual, expected)
	}
}

func TestHealthyHandler(t *testing.T) {
	req, err := http.NewRequest("GET", "/healthy", nil)
	if err != nil {
		t.Fatal(err)
	}

	rr := httptest.NewRecorder()
	handler := http.HandlerFunc(healthyHandler)

	handler.ServeHTTP(rr, req)

	// Check the status code is what we expect
	if status := rr.Code; status != http.StatusOK {
		t.Errorf("handler returned wrong status code: got %v want %v",
			status, http.StatusOK)
	}

	// Decode the response
	var actual Response
	if err := json.Unmarshal(rr.Body.Bytes(), &actual); err != nil {
		t.Fatalf("could not decode response: %v", err)
	}

	// Expected response
	expected := Response{
		Healthy: "true",
	}

	// Compare the actual response to the expected response
	if !reflect.DeepEqual(actual, expected) {
		t.Errorf("handler returned unexpected body: got %v want %v",
			actual, expected)
	}
}
