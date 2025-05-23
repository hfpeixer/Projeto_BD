Usage:
  fly.exe postgres [command]

Aliases:
  postgres, pg

Available Commands:
  attach      Attach a postgres cluster to an app
  backup      Backup commands
  config      Show and manage Postgres configuration.
  connect     Connect to the Postgres console
  create      Create a new Postgres cluster
  db          Manage databases in a cluster
  detach      Detach a postgres cluster from an app
  events      Track major cluster events
  failover    Failover to a new primary
  import      Imports database from a specified Postgres URI
  list        List postgres clusters
  renew-certs Renews the SSH certificates for the Postgres cluster.
  restart     Restarts each member of the Postgres cluster one by one.
  users       Manage users in a postgres cluster

Flags:
  -h, --help   help for postgres

Global Flags:
  -t, --access-token string   Fly API Access Token
      --debug                 Print additional logs and traces
      --verbose               Verbose output

Use "fly.exe postgres [command] --help" for more information about a command.

