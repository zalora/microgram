## wtf

`wtf` is a unified diagnostics API for lightweight monitoring and low-frequency time-series checks.
`wtf/default.nix` builds a commandline tool, `wtf`, by assembling checks according to the interface specified in `api.nix`. 

It is possible to create various backends for these diagnostics, such as CloudWatch, collectd and so on.

See [test.nix](test.nix) for usage example.

#### API usage

There are a some of different kinds of diagnostics that you can implement.
The simplest one is just a shell script that should investigate whether your
application works or not and exit with code `0` if the check passes, any
other code if the check fails. You add such a check to your module in the
following way:

```nix
diagnostics = {
  mysql-running.script-retcode = ''
    ${sdk.mariadb}/bin/mysql -e ';'
  '';
};
```

This adds the check `mysql-running`, that just tries to do a connection to a
MySQL server running on localhost. If you deploy a module with such a check to
an instance you can then run the following command, logged in to that instance:

```bash
$ wtf mysql-running
```

If check is successful this command will print nothing;
otherwise it will print `mysql-running FAILED`.

You can also tell the platform that the check should run periodically and that
the result should be aggregated centrally (needs a backend implementation) so that it
is possible to do analytics and alerts. You do this by just setting
`timeseries.enable = true` on the check:

```nix
diagnostics.mysql-running = {
  timeseries.enable = true;
  script-retcode = ''
    ${sdk.mariadb}/bin/mysql -e ';'
  '';
};
```

This code is mostly `0` or `1`, so it is only useful
for triggering alerts when something goes down. A more interesting metric could
be some kind of counter from the application. This can also be implemented by a
simple script, that should return a numeric metric on `stdout`:

```nix
diagnostics.tcp-retransmits = {
  script-metric = ''
    awk 'NR==2 { print $42 + $46 + $47 + $48 + $102; }' /proc/net/netstat
  '';
  timeseries.enable = true;
};
```

Another simple check is the `http-ok` type. This check verifies that a specific
URL returns status 200. This is very useful if your application is a web
application that has some kind of healthcheck functionality builtin. You define
such a check this way:

```nix
diagnostics = {
  app-healthcheck = {
    http-ok = "http://localhost/healthcheck";
    timeseries.enable = true;
  };
};
```

There are some more types of checks, and it is possible to add more when needed. Check out
[api.nix](api.nix) for details on the options that exist.
