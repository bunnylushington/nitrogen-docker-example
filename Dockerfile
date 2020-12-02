FROM erlang:23

RUN git clone https://github.com/nitrogen/nitrogen /nitrogen
WORKDIR /nitrogen
RUN make slim_cowboy PROJECT=app PRFIX=/app
EXPOSE 8000
WORKDIR /app
CMD ["/app/bin/nitrogen", "foreground"]
