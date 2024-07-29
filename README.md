![](slogan.gif)

# About this project

This project is a delivery of an exercise related to a course on Flutter. It is a To Do List app with some gamification. The goal of the
exercise is to put into practice what has been learned in the course so far. Most of the decisions and limitations of this project were
driven by what the exercise asked for, my knowledge of Flutter limited to the basics, and the deadline.

# Testing notes

Most of the time I used the Pixel 6 API 30 Android emulator for testing. This is the most recommended emulator to test this app. For the
sign in part, I didn't do a very strict email validation (in order to facilitate testing). So if you don't want to enter your real email
address, it's possible to register a user using an email address that doesn't exist. The version of Flutter I used is 3.22.0.

There was a change to make the avatar animation more fluid. From my tests, the result was good on the real device and okay on the emulator.
If you have a crashing problem because of the avatar, you can try changing Constants.avatarType to PedroAvatarType.webpWith12Fps.
