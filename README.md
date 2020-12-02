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


## Example Deployment

> NB: This is an example.  No warranty is provided or implied.

To further this example, let's now deploy to Digital Ocean (DO).
We'll use [sample.yml](sample.yml) to docker-compose two containers,
the Nitrogen application and [Traefik](https://traefik.io) which will
manage certificates, routing, and http -> https redirection.

There are a few preliminary steps to set up the environment which are
beyond the scope of this example:

1. Create a DO account.

2. Create a new droplet, using the Docker image from the DO Marketplace.

3. Setup DNS to point to the droplet (this is required).[^1]

4. Ensure droplet access via ssh.

> For the purposes of this example, the domain we're using is
> example.com.  Note that this must be changed in the `sample.yml`
> file.  We will use `/var/tmp/sample` as our base directory though
> this is arbitrary.

With that out of the way:

5. Copy the `sample.yml` file to
   `example.com:/var/tmp/sample/sample.yml`.

6. Copy the `site` directory to `example.com:/var/tmp/sample/site`.

7. Execute `docker-compose -f sample.yml up`.

At this point the Traefik and Nitrogen images will be pulled from
hub.docker.com and started; progress will be reflected to stdout.

Once the front end Nitrogen instance (FE) is running, it will take a
minute or two for Traefik to generate a certificate request and
receive a valid certificate from Let's Encrypt.  Note that this will
fail if DNS is not configured (you need an A or CNAME record) or if
the sample.yml file was not edited correctly.

After a minute or so, you should be able to browse to
`http://example.com`, see that you're redirected to
`https://example.com` and your site.

**Let me reiterate: this is a proof of concept!  Although DO droplets
are usually configured with reasonable ipchains rules it is *your*
responsibility to ensure that host security is adequate.**  I do not
suggest that this is a production environment (at least as I'd
describe one) but might be a good starting place towards building one.

[^1]: I use DO to manage DNS for domains which are primarily deployed
there.  It works well, at least for mid-traffic applications.

## Author

Bunny Lushington

All errors are mine and mine alone.  Please send suggestions for
improvement or requests for clarification if required.

## License

MIT License

Copyright (c) 2020 Bunny Lushington and Bunny & Pink, Ink.

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
