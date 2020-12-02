FROM erlang:23

RUN git clone https://github.com/nitrogen/nitrogen /nitrogen \
  && chdir /nitrogen \
  && make slim_cowboy PROJECT=app PREFIX=/
EXPOSE 8000
WORKDIR /app
CMD ["/app/bin/nitrogen", "foreground"]
