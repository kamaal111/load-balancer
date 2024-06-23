# List available commands
default:
    just --list --unsorted --list-heading $'Available commands\n'

# Start load balancer
start-load-balancer:
    just load-balancer/start

# Start service 1
start-service-1:
    just service-server/start-1

# Start service 2
start-service-2:
    just service-server/start-2

# Start service 3
start-service-3:
    just service-server/start-3

# Start service 4
start-service-4:
    just service-server/start-4
