import { DynamoDB, DynamoDBClientConfig } from "@aws-sdk/client-dynamodb";
import { DynamoDBDocument } from "@aws-sdk/lib-dynamodb";
import NextAuth from "next-auth";
import GitHubProvider from "next-auth/providers/github";
import { DynamoDBAdapter } from "@auth/dynamodb-adapter";

const config: DynamoDBClientConfig = {
  credentials: {
    accessKeyId: process.env.NEXT_AUTH_AWS_ACCESS_KEY as string,
    secretAccessKey: process.env.NEXT_AUTH_AWS_SECRET_KEY as string,
  },
  region: process.env.NEXT_AUTH_AWS_REGION,
  endpoint: process.env.NEXT_AUTH_DYNAMO_ENDPOINT,
};

const client = DynamoDBDocument.from(new DynamoDB(config), {
  marshallOptions: {
    convertEmptyValues: true,
    removeUndefinedValues: true,
    convertClassInstanceToMap: true,
  },
});

export default NextAuth({
  // Configure one or more authentication providers
  providers: [
    GitHubProvider({
      clientId: process.env.GITHUB_ID as string,
      clientSecret: process.env.GITHUB_SECRET as string,
    }),
  ],
  //@ts-expect-error DynamoDBAdapter has some mismatching types
  adapter: DynamoDBAdapter(client),
});
