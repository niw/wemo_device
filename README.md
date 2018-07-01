wemo_device
===========

NAME
----

`wemo_device` -- A simple Ruby gem library that lookups [Blkin](http://www.belkin.com/)’s [Wemo](http://www.wemo.com/) devices.

DESCRIPTION
-----------

`wemo_device` is a Ruby gem library that provides a set of interfaces that looks up Wemo devices by using SSDP protocol, which is a part of UPnP protocols.

Since Wemo devices are using SSDP, but its implementation is for their propriety usage, it does not fully conform the specifications.

This library wraps these behaviors and provides a simple interface to lookup the devices on the network.

This library does not have any extra dependencies, works perfect with Ruby standard libraries.

USAGE
-----

Recommend to use [Bundler](https://bundler.io/) to add `wemo_device` as a dependency to your project. Add next line in `Gemfile`.

    gem "wemo_device"

`wemo_device` provides a simple API to lookup. To list up all devices on the network, use next code.

    require "rubygems"
    require "wemo_device"
    require "pp"
    
    WemoDevice::Device.lookup.each do |device|
      pp device
    end

EXAMPLES
--------

In the `examples` directory, there are a few examples how to use this library.

 * `lookup.rb`

    Lookup all Wemo devices on the network.

 * `switch.rb`

    Turn on and off the Wemo switch.
    Set unique service name found by `lookup.rb` in form of `--usn uuid:....` argument,
    and use `--on` or `--off` to toggle the Wemo switch.
