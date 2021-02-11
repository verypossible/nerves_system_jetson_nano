# Jetson Nano

## v0.1.1

When migrating custom systems based on this one, please be aware of the following
important changes:

* There's a new `getrandom` syscall that is made early in BEAM startup. This
  blocks the BEAM before `rngd` can be started to provide entropy. The
  workaround is to start `rngd` from `erlinit`. See `erlinit.config`.

* Updated dependencies
  * [nerves_system_br: bump to v1.14.4](https://github.com/nerves-project/nerves_system_br/releases/tag/v1.14.4)
  * [Buildroot 2020.11.2](http://lists.busybox.net/pipermail/buildroot/2021-January/302574.html)
  * [Erlang/OTP 23.2.4](https://erlang.org/download/OTP-23.2.4.README)

## v0.1.0

Initial release

Based off NVIDIA L4T Release 32.5
