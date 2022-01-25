# VhrCtl - Vacation Home Rover Controller

VhrCtl is a web application to control the
Vacation Home Robot (VHR) and to collect, manage, and view data produced by the robot.

This system works with VhrRbt - Vacation Home Rover Robot. The robot can move around your
vacation home, reporting temperature, humidity, and battery level. It can also take
photos so you can see what your home looks like.

The controller and robot communicate via HTTP. The robot periodically reports its external
IP address, so if it sits behind a router that uses a dynamic IP address, you can always
communicate with it.

The controller runs a web interface to control the robot.

## Startup
### Host Mode
Controller and robot systems are running on the development host.
    iex -S mix phx.server

### Device Mode
Communicating with the robot.
    MIX_TARGET=rpi3 iex -S mix phx.server

## Running
Go to:
    http://localhost:4000

## Robot URL
The robot URL is set in `config/dev.exs`.

## Troubleshooting

### When taking a picture you get a connection refused error
If running on the Chromebook you need to forward the port in:

```
Settings | Advanced | Developers | Linux development environment
Port forwarding
Make sure port 4000 is forwarded.
```

