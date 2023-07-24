# Next Auth DynamoDB Adapter Starter

Author: Ong Seeu Sim [@SeeuSim](https://github.com/SeeuSim)

## Motivation

This is for people looking to store their [Next-Auth](https://next-auth.js.org) sessions within [DynamoDB](https://aws.amazon.com/dynamodb/).
Included with this repo are:

  - Scripts to deploy a DynamoDB local database, for testing.
  - Scripts to create the necessary schema for interacting with DynamoDB.
  - A basic configuration for Github OAuth for testing of OAuth login flow. This can be
    replaced with any of your own [providers](https://next-auth.js.org/providers/).

## Setup

1. First, install your own local DynamoDB instance with [`docker-compose`](https://www.google.com/url?sa=t&rct=j&q=&esrc=s&source=web&cd=&cad=rja&uact=8&ved=2ahUKEwjvnf3n9aOAAxVcwTgGHcwAChAQFnoECBgQAQ&url=https%3A%2F%2Fdocs.docker.com%2Fcompose%2F&usg=AOvVaw02oes91geDSZ-H__u_XMxc&opi=89978449).

    - First, if you haven't already, install [Docker](https://docker.com)
    - Next, ensure it is running by launching it.
    - Lastly, in the root directory of this repo, run `docker-compose up`. This creates a DynamoDB instance at `http://localhost:8000`.

2. Next, configure this instance using the `aws cli`.

    - First, if you haven't already, install the [aws cli](https://www.google.com/url?sa=t&rct=j&q=&esrc=s&source=web&cd=&cad=rja&uact=8&ved=2ahUKEwjikdix9qOAAxXt-zgGHZ5yAPwQFnoECBsQAQ&url=https%3A%2F%2Faws.amazon.com%2Fcli%2F&usg=AOvVaw0DaJN1gYGMhLWqP0DShfZd&opi=89978449)
    - Next, run this command:
    
    ```sh
    aws cli configure
    ```

      - When prompted for the access key ID and secret access key, enter the values in `./.env.example`.
      - When prompted for `region`, enter `ap-southeast-1`.
      - When prompted for `output-type`, enter `json`.

3. Next, run the script to configure and set up the tables:

```sh
# Add execution permissions
chmod +x ./next-auth-dynamo.sh

# Create the tables and schema
./next-auth-dynamo.sh
```
    
  - This performs two critical actions. Ensure that both complete without issue:

    1. Creates a table with the required schema for `next-auth` to work.
    2. Configures the TTL for the session objects within the table.

4. Lastly, create a [Github App](https://github.com/settings/apps).

  - Generate the following:
    - A `client id`
    - A `client secret`
  - Copy these values into `.env.example`
  - Configure the auth callback URL to `http://localhost:3000/api/auth/callbacks/github`

5. Copy the configured `.env.example` to `.env.local`. Ensure that no sensitive values are left in `.env.example`, and that any sensitive values are not committed to any remote repository.

6. You're all set! Simply run these commands to set up the packages and the repo, and start the app:

```sh
docker-compose up --build

##OR
# If doing so, change the DYNAMO_ENDPOINT to localhost
npm install
npm run dev
```

7. To login, simply click the `sign in` button at path "/".
  This triggers the OAuth login flow for Github.
8. The session should be created in the DynamoDB table. You may inspect it with the AWS CLI.
9. To sign out, simply click the `sign out` button at path "/accounts". Inspect the browser that it signs you out, and the table
in DynamoDB does not have your session object from earlier.

## Further Config

To configure further actions, such as sign in actions, session actions and other callbacks/configurations for other providers, you may refer to the Next Auth documentation.

## Stuff Included Here

- DynamoDB Adapter
- Github OAuth
- OAuth Middlewares for authenticated routes
- Sign In with callbacks
