#!/bin/bash

# Informations Keycloak
KEYCLOAK_URL="http://localhost:8080"
CLIENT_ID="proverbs-front-client"
CLIENT_SECRET="3vZsB0yB1c7lBkus3ULRy6LcMPLjYqRb"
REALM="proverb-realm"

# Endpoint pour obtenir le token
TOKEN_URL="$KEYCLOAK_URL/realms/$REALM/protocol/openid-connect/token"

# Requête pour obtenir le token
echo "Obtaining access token from Keycloak..."
TOKEN_RESPONSE=$(curl -s -X POST "$TOKEN_URL" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "client_id=$CLIENT_ID" \
  -d "client_secret=$CLIENT_SECRET" \
  -d "grant_type=client_credentials")

# Extraction du token
ACCESS_TOKEN=$(echo "$TOKEN_RESPONSE" | jq -r '.access_token')

# Vérification du token
if [ "$ACCESS_TOKEN" == "null" ] || [ -z "$ACCESS_TOKEN" ]; then
  echo "Failed to retrieve access token. Response:"
  echo "$TOKEN_RESPONSE"
  exit 1
fi

# Affichage du token
echo "Access Token retrieved successfully:"
echo "$ACCESS_TOKEN"

# API Proverbs - Ajout d'un proverbe
PROVERBS_API_URL="http://localhost:5000/proverbs"
NEW_PROVERB_JSON='{"text": "Un proverbe est une leçon en une phrase.", "author": "Anonyme"}'

echo "Adding a new proverb to the API..."
RESPONSE_CODE=$(curl -s -o /dev/null -w "%{http_code}" -X POST "$PROVERBS_API_URL" \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  -H "Content-Type: application/json" \
  -d "$NEW_PROVERB_JSON")

# Affichage du code de retour
echo "Response code from the Proverbs API: $RESPONSE_CODE"

# Fin du script
if [ "$RESPONSE_CODE" -eq 200 ] || [ "$RESPONSE_CODE" -eq 201 ]; then
  echo "Proverb added successfully!"
else
  echo "Failed to add proverb. Response code: $RESPONSE_CODE"
fi
