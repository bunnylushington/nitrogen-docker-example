# Example Nitrogen Docker

This is an example of how Nitrogen and Docker can interact.  We use a
pre-built Docker container to host the Nitrogen application.  This
setup obviates the need to install Erlang and Nitrogen locally and
provides a quick way of test driving Nitrogen.

Note that this is a demonstration!  It is not expected that this is
anywhere near production ready except for the very simplest of
applications, although it might serve as a basis for further
exploration.

## Getting Going

### Building the Container

This step is optional.  Should you decide to build your own image
instead of pulling from [Docker
Hub](https://hub.docker.com/r/bunnylushington/example-nitrogen-cowboy)
change the name of the image below from
`bunnylusington/example-nitrogen-cowboy` to `nitrogen_cowboy`.

``` shell
docker build -t nitrogen_cowboy .
```

### Preparing the Site Directory

This step must be performed before the Nitrogen application can be
edited.  We're copying the (container hosted) site files to the local
filesystem.

``` shell
docker run --name nitrogen --rm \
  -v `pwd`:/site bunnylushington/example-nitrogen-cowboy \
  cp -r /app/site /site
```

### Starting the Nitrogen Application

``` shell
docker run --name nitrogen -d --rm \
  -p 127.0.0.1:8000:8000 \
  -v `pwd`/site:/app/site \
  bunnylushington/example-nitrogen-cowboy
```

### Connecting to the Console

``` shell
docker exec -it -e TERM=xterm nitrogen /app/bin/nitrogen remote_console
```

To disconnect from the console: `control-p control-q`.

### Stopping the Nitrogen Application

``` shell
docker stop nitrogen
```

## What Now?

Browse to [http://localhost:8000](http://localhost:8000) and marvel at
the awesomeness that is Nitrogen.

To test things out, connect to the console per the instructions above
and execute `sync:go().` to start the auto recompilation and reload
process.  Then make changes to the source code in the local `site`
directory; they'll be reflected in the example application.
