# Fly

## Connection

```bash
#!/bin/bash
DATABASE=${1:-postgres}
USERNAME=${2:-postgres}
PASSWORD=${3:-$OPERATOR_PASSWORD}

psql postgres://$USERNAME:$PASSWORD@$FLY_APP_NAME.internal:5432/$DATABASE
```
