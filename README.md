# jitsimeet

#### Table of Contents

1. [Description](#description)
2. [Setup](#setup)
    * [Setup requirements](#setup-requirements)
    * [Getting started](#getting-started)
3. [Limitations](#limitations)
4. [Reference](#reference)
5. [Development](#development)

## Description

This module installs and manages a Jitsi Meet instance.

It currently only support Debian.

## Setup

### Setup Requirements

This module needs:

 * the [stdlib module](https://github.com/puppetlabs/puppetlabs-stdlib.git)
 * the [prosody module](https://github.com/voxpupuli/puppet-prosody.git)

Explicit dependencies can be found in the project's metadata.json file.

### Getting started

Here is an example of a working configuration:


``` puppet
  class { 'jitsimeet':
    fqdn                     => 'jitsi.example.com',
    jitsi_videobridge_secret => 'mysupersecretstring',
    focus_secret             => 'anothersupersecretstring',
  }
```

## Limitations

This module is still very young and lacks a bunch of features. Please use it at
your own risk (and don't be afraid to send a path!).

At the moment, the following things aren't managed by this module:

* webserver (nginx, apache2) configuration
* prosody TLS certificates
* unattended-updates configuration

For now, only Debian 10 is supported.

# Reference

The full reference documentation for this module may be found at on
[GitLab Pages][pages].

Alternatively, you may build yourself the documentation using the
`puppet strings generate` command. See the documentation for
[Puppet Strings][strings] for more information.

[pages]: https://shared-puppet-modules-group.gitlab.io/jitsimeet
[strings]: https://puppet.com/blog/using-puppet-strings-generate-great-documentation-puppet-modules

## Development

This module's development is tracked on GitLab. Please submit issues and merge
requests on the [shared-puppet-modules-group/jitsimeet][smash] project page.

[smash]: https://gitlab.com/shared-puppet-modules-group/jitsimeet
