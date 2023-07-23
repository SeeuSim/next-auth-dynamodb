aws dynamodb create-table \
    --table-name next-auth \
    --attribute-definitions AttributeName=pk,AttributeType=S AttributeName=sk,AttributeType=S AttributeName=GSI1PK,AttributeType=S AttributeName=GSI1SK,AttributeType=S \
    --key-schema AttributeName=pk,KeyType=HASH \
                AttributeName=sk,KeyType=RANGE \
    --provisioned-throughput ReadCapacityUnits=1,WriteCapacityUnits=1 \
    --global-secondary-indexes \
        "[
            {
                \"IndexName\": \"GSI1\",
                \"KeySchema\": [
                    {\"AttributeName\":\"GSI1PK\",\"KeyType\":\"HASH\"},
                    {\"AttributeName\":\"GSI1SK\",\"KeyType\":\"RANGE\"}
                ],
                \"Projection\": {
                    \"ProjectionType\":\"ALL\"
                },
                \"ProvisionedThroughput\": {
                    \"ReadCapacityUnits\": 1,
                    \"WriteCapacityUnits\": 1
                }
            }
        ]" \
    --endpoint-url http://localhost:8000 

aws dynamodb update-time-to-live \
  --time-to-live-specification Enabled=true,AttributeName=expires \
  --endpoint-url http://localhost:8000 \
  --table-name next-auth
