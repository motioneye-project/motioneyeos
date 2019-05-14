=== Notes on using Mender on Buildroot
======================================
Default configurations files
----------------------------

Buildroot comes with a default artifact_info and device_type configuration files
in /etc/mender. They contain default values, and thus they should be overridden
on a production system.

The simplest way to do it is to change these files in an overlay or in a post
build script.

Configuring mender with certificates
------------------------------------

Mender uses TLS to communicate with the management server, and if you use a
CA-signed certificate on the server, you should select the ca-certificates
package otherwise it doesn't work.
