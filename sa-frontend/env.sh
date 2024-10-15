#!/bin/sh

# Replace placeholders in the static files with environment variables
echo "Replacing environment variables in JavaScript files..."
echo "${REACT_APP_API_URL}"
for file in /usr/share/nginx/html/static/js/*.js; do
  sed -i 's|REACT_APP_API_URL_PLACEHOLDER|'${REACT_APP_API_URL}'|g' $file
done

echo "Environment variables replaced successfully."
