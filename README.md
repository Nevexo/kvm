# jetkvm-next

jetkvm-next is a fork of the JetKVM application with various in-progress features merged in from commnunity
pull requests.

This branch isn't meant to be pulled into the upstream, and will almost certainly contain some bugs, it's a 
bleeding-edge build of the software that community members can use to try out new features, or for developers to check
their upcoming features don't clash with other in-progress PRs.

> Generally, you shouldn't run jetkvm-next on your device, you should keep it on the main update stream, or optionally
> switch to the beta branch in the device's settings.

Main repo: https://github.com/jetkvm/kvm

## Current Additional Features
The below [in-development features](https://github.com/jetkvm/kvm) are currently included in `jetkvm-next`.
The commits from the developer's working tree and cherry picked into this branch, to check the "version" of the feature,
compare the commit hash on this branch, to the current hash of the commit(s) in the pull request.

- tutman - [Plugin System](https://github.com/jetkvm/kvm/pull/10)
- SuperQ - [Prometheus Metrics](https://github.com/jetkvm/kvm/pull/6)
- Nevexo - [Force-release IPv4 addresses on Link Down](https://github.com/jetkvm/kvm/pull/16)
- Nevexo - [Display backlight brightness control](https://github.com/jetkvm/kvm/pull/17)
- Nevexo - [CTRL+ALT+DEL Button on Action Bar](https://github.com/jetkvm/kvm/pull/18)
- tutman - [Clean-up jetkvm_native when app exits](https://github.com/jetkvm/kvm/pull/19)

## Additional Info
There's a GitHub Action setup to build the JetKVM software whenever this repo has a new release added, it'll take
a few minutes for the binary to appear on the release once this repo is tagged.
