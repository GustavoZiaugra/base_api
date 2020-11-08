# Base API

![CI](https://github.com/GustavoZiaugra/base_api/workflows/CI/badge.svg?branch=main)

Base API is a web application using the Phoenix framework with Elixir.

Its basic purpose was to offer a pre-configured set of dependencies used in every robust API,considering part of deployment and infrastructure, tests, code analysis, small functionalities and CI.
I will try as much as possible to make each commit as explicit as possible regarding the implementation to follow a guide for those interested.

### Versions
* [Elixir] - v1.11.1
* [Erlang] - OTP 23.0
* [Phoenix Framework] - V1.56.0
* [Postgres] - V12.0.0

### How to run it?

Without Docker:
After installing the Elixir, Postgres and the technologies mentioned above, do the following commands:

```sh
$ mix ecto.setup
$ mix phx.server
```

With Docker:
For now you can generate a release to deploy/run whatever you want.
Just do this following command:
```sh
$ docker build . --tag #{your_tag_name}
```

### Development

Want to contribute? Great!

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.
Please make sure to update the tests as appropriate.

----

MIT
