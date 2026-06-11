terraform {
  required_providers {
    checkpoint = {
      source = "CheckPointSW/checkpoint"
      version = "3.1.0"
    }
  }
}

# Configure Check Point Provider for Management API
provider "checkpoint" {
}