one-plugin-template
============

A template for creating an AccedoOne plugin component.

## Getting started

Automates the boilerplate required for creating a plugin component.
- Add `OneCore` dependency to `<PluginName>.podspec`.
- Define the principal class in `<PluginName>.podspec`.
- Create `<PluginName>.swift` class that conforms to `Pluggable`.
- Create plugin identifier.
- Create template README

## Usage

Within the plugins directory, run the following:

`pod lib create --template-url="https://github.com/alexpezzi/one-plugin-template" Brightcove`

## Requirements:

- CocoaPods 1.0.0+
