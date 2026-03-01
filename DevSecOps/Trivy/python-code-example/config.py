# Sample app config - intentionally contains fake secrets for demo
import os

# Database config
DB_HOST = "prod-db.internal.company.com"
DB_PORT = 5432
DB_NAME = "demo_prod"

# Hardcoded credentials (BAD PRACTICE - for demo only)
DB_PASSWORD = "Sup3rS3cr3tP@ssw0rd!"
DB_USER = "admin"

# AWS credentials hardcoded (BAD PRACTICE - for demo only)
AWS_ACCESS_KEY_ID = "AKIAIOSFODNN7JKDT8JF"
AWS_SECRET_ACCESS_KEY = "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY"
AWS_REGION = "us-east-1"

# API Keys (BAD PRACTICE - for demo only)
STRIPE_SECRET_KEY = "sk_live_4eC39HqLyjWDarjtT1zdp7dc"
GITHUB_TOKEN = "ghp_16C7e42F292c6912E7710c838347Ae178B4a"
SENDGRID_API_KEY = "SG.xxxxxxxxxxxxxxxxxxxxxxxx.xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"

# JWT Secret
JWT_SECRET = "my-super-secret-jwt-key-do-not-share"

# Slack Webhook
SLACK_WEBHOOK = "https://hooks.slack.com/services/T00000000/B00000000/XXXXXXXXXXXXXXXXXXXXXXXX"
