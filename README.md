[![Build Status](https://travis-ci.org/MonsieurCode/bouncer.svg?branch=master)](https://travis-ci.org/MonsieurCode/bouncer)
[![Code Climate](https://codeclimate.com/github/MonsieurCode/bouncer/badges/gpa.svg)](https://codeclimate.com/github/MonsieurCode/bouncer)
[![Test Coverage](https://codeclimate.com/github/MonsieurCode/bouncer/badges/coverage.svg)](https://codeclimate.com/github/MonsieurCode/bouncer)
[![Dependency Status](https://gemnasium.com/MonsieurCode/bouncer.svg)](https://gemnasium.com/MonsieurCode/bouncer)

Bouncer
===

Bouncer provides a simple endpoint to use for all authentication, including users and devices. Bouncer also allows users to log in via facebook and create devices.

[API Documentation](http://docs.mbouncer.apiary.io/#) is available.

Bouncer sends transactional emails via Mandrill templates

## Getting Started

### Bootstrapping

```
bin/bootstrap
```

After bootstrapping, you'll need to create an `.env.development` file in the root path of the
app. Do the following to use the (**incomplete**) sample env as a starting point:

```
cp config/env.sample .env.development
```

Run locally with Foreman

```
bundle exec foreman s
```

### Requirements

1. Ruby 2.1.2
2. MongoDB

### Testing

```
bundle exec rspec
```

### Deploying

```
bin/deploy
```
