# boxee-remote-ios
An iOS remote control app for Boxee media players

This is currently a WIP. Expect more to come...

Steps to run:

1. Edit `ViewController.swift`
  1. Edit `username`, `password`, `host`, `port`
2. Build the project
3. Sideload onto iPhone
4. Enjoy!


Here is a screenshot of the app:

If the pressed command was successful, it will pop up in green above the keypad. If it was unsuccessful, it will pop up in red.

The app looks good on any device. All of the buttons are dynamically sized based on the screen size.

![remote preview](http://i.imgur.com/WSpl4mM.png)

# TODO

- [x] Make the MVP...
- [x] Make it look decent on any size device
- [ ] Add handling for being unable to connect to a device ( b/c of authorization or incorrect host/port )
- [ ] Polish the interface ( a lot )
- [ ] Haptic feedback
- [ ] Make buttons glow green/red
- [ ] Day/Night mode
- [ ] Support configuring creds/host at runtime instead of compile time.
