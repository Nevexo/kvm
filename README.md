# jetkvm-next

> jetkvm-next is not affiliated with, nor supported by, JetKVM or BuildJet.

jetkvm-next is a fork of the JetKVM application with various in-progress features merged in from commnunity
pull requests.

This branch isn't meant to be pulled into the upstream, and will almost certainly contain some bugs, it's a 
bleeding-edge build of the software that community members can use to try out new features, or for developers to check
their upcoming features don't clash with other in-progress PRs.

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
- Nevexo - [Only start WebSocket client when necessary](https://github.com/jetkvm/kvm/pull/27)
- Nevexo - [Restore EDID on Reboot](https://github.com/jetkvm/kvm/pull/34)
- tutman - [Remove Rounded Corners](https://github.com/jetkvm/kvm/pull/86)
- antonym - [Update ISO Versions](https://github.com/jetkvm/kvm/pull/78)
- tutman - [Fix fullscreen video absolute position](https://github.com/jetkvm/kvm/pull/85)
- jackislanding - [Allow configuring USB IDs](https://github.com/jetkvm/kvm/pulls/90)
- williamjohnstone - [Multiple Keyboard Layouts](https://github.com/jetkvm/kvm/pull/116)
- andnic - [USB HID Fix](https://github.com/jetkvm/kvm/pull/113)
- Nevexo - Add Reboot Button (No PR for this as it's not final)

If you're looking to try these features out in jetkvm-next, you should go to the PR and read the authors documentation.

## next-multisession
As requested by a few in the [JetKVM Discord](https://jetkvm.com/discord), this tree also includes a branch that enables
support for multiple sessions connecting to the JetKVM.

It's a bit of a bodge implementation, but shows the multiple sessions can be handled by the JetKVM.

Every release of jetkvm-next includes jetkvm-next-multisession in a pre-release, the jetkvm-next-multisession branch is based
off the main jetkvm-next branch, and applies changes to the session handling code.

next-muiltisession does not include any concept of control authority/mutex, so all users connected will have full control
over the target machine, and you'll be fighting for the cursor with the other user.

## Installation
> You should read this section multiple times before even plugging in the JetKVM device.
> If these instructions don't immediately make sense, then it's probably best to avoid installing
> jetkvm-next, it's incredibly bleeding-edge, and could explode in a million different ways.

**DISCLAIMER:** This is very much beta, canary, unstable, software there could be bugs that cause
damage to your JetKVM hardware, such as wearing out the eMMC, breaking the LCD or overheating.

**On Windows?:** Install WSL now, it makes life much easier.

### Prepare the KVM
Boot up your KVM, login, and enable SSH access with your SSH public key.

Test you can login to the KVM with your SSH key, remember the username is `root`.

### Build your own binary
While I provide pre-compiled binaries with every [release](https://github.com/nevexo/jetkvm-kvm/releases), you can (and should) build
the binary yourself, this allows you to analyse the code running on your device, and be familiar with the innerworkings of the JetKVM
software stack, before you have to start debugging it.

#### You will need:
- A JavaScript runtime, such as Node.JS ([Bun](https://bun.sh) works fine, but you'll need to adjust the Makefile)
- Git
- Go (and the various compilers for ARMv7)
- make

#### Get the code
Make yourself a directory to keep jetkvm-next in, and clone the repo:

`git clone https://github.com/nevexo/jetkvm-kvm.git`

(If you're updating, just do `git pull` in the jetkvm-kvm directory.)

As the next branch is the main development branch of jetkvm-next, it may not build as-is, so you should check-out
one of the tags for the version you want to use. At the time of writing, that's next-7, but if I forget to update
the README (I will) you should check [the releases page](https://github.com/nevexo/jetkvm-kvm/releases) for the latest tags.

`git checkout next-7`

If you want multisession, then stick -multisession on the end of the checkout command, but note I usually release multisession
a little bit later than the default.

Your code will now be in line with the code in the binary released.

#### Build the code
This will automatically build both the frontend and the jetkvm-next binary. If you don't have the proper ARM compilers
installed for Go, you'll see some errors, simply Google the package that Go says is missing, and the name of your OS, and you'll
be able to find it. (If you're on WSL, search for the distro you're using, not Windows)

`make build_next`

#### Deploy the binary
**NOTE:** There's a bug in next_deploy.sh for all versions next-7 and older, so if you're building one of those, you'll need to
run these commands first:

```
mkdir -p bin/next
touch bin/jetkvm_app
```
(the script checks if the normal jetkvm_app binary exists, even though it only needs the one in bin/next, oops!)

Run the deployment script:
```
./next_deploy.sh -r [address of kvm]
```

After a moment, you should see `Deployment complete!` - skip to the bottom to see how to launch it.

### Use the provided binary
Again, I highly recommend you get familiar with the innerworkings of the JetKVM stack and build your own binaries.
But, if you can't be bothered with the above:

#### Get the binary
Simply go to the releases page, and download the latest available image, you can choose the multisession version at this stage, if you wish.

Pop the binary somewhere that you can get to with your terminal (on WSL, that's probably /mnt/c/Users/[yourname]/Downloads)

#### Deploy the binary 
**NOTE:** The buildroot image on the JetKVM doesn't have support for scp, so this is where it gets interesting.

Use `cat` to send the contents of the jetkvm_app_next binary over to your KVM.

`cat jetkvm_app_next | ssh "root@[IP of JetKVM]" "cat > /userdata/jetkvm/bin/jetkvm_app_next"`

That's it :)

## Run jetkvm-next
**NOTE:** You need to be somewhat quick at doing this as the kernel watchdog timer will reboot the jetkvm
if the jetkvm_app binary hasn't been running for a while. You can turn that off by running `echo 'V' > /dev/watchdog`

To run jetkvm-next now, run:
```
cd /userdata/jetkvm/bin
killall jetkvm_app
killall jetkvm_native
./jetkvm_app_next
```

The app will launch, and you can try out the new features! When you reboot the device, it'll return to jetkvm_app.

### Use jetkvm-next by default
You can rename the jetkvm_app binaries to make the KVM start next by default.

```
cd /userdata/jetkvm/bin
killall jetkvm_app
killall jetkvm_native
mv jetkvm_app jetkvm_app_old
mv jetkvm_app_next jetkvm_app
reboot
```

Your JetKVM is now running jetkvm-next!

### Going back to stable
If you followed the above instructions properly, switching back to stable is easy.

```
cd /userdata/jetkvm/bin
killall jetkvm_app
mv jetkvm_app jetkvm_app_next
mv jetkvm_app_old jetkvm_app
```

If you lost jetkvm_app_old, then [factory reset](https://jetkvm.com/docs/advanced-usage/factory-reset).