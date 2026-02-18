#!/bin/bash

sealed=$(curl -s ${VAULT_URL}/v1/sys/seal-status | grep '"sealed":true')

if [ -z "$sealed" ]; then
    echo "Vault is already unsealed."
    exit 0
fi

echo "Vault is sealed. Attempting to unseal..."

for key in $(echo "$VAULT_UNSEAL_KEYS" | tr "," " "); do
    curl -s \
      --request POST \
      --header "Content-Type: application/json" \
      --data "{\"key\": \"$key\"}" \
      ${VAULT_URL}/v1/sys/unseal >/dev/null
done

echo "Unseal request completed."