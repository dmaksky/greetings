# Greetings
This is a project for learning basics of the CI/CD pipelines in Jenkins.

## Description
The project is a CI/CD pipeline in Jenkins that builds and deploys a simple application on Go.

Pipeline stages:

1. Unit testing and building application. 
2. Packer builds vm image with OS + application and dependencies in YC infrastructure.
3. Terraform creates testing infrastructure in YC and performs functional testing.
4. Terraform creates prod infrastructure in YC (one balancer with health-check + 2 instances).

## Technologies
Yandex-Cloud, Packer, Jenkins, Terraform


