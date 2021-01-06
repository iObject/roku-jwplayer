# Roku JWPlayer API

The Roku JWPlayer API is an open source project to enable Roku developers who are familiar with the JWPlayer JavaScript API the ability to quickly implement video playback.

  - Import script into your main scene
  - Instantiate the player object
  - Communicate with the API which adheres to the JWPlayer JS API as much as possible
  - WIN!

# Features!

  - Video playback

### Installation

Roku JWPlayer API requires the [Roku Package Manager](https://github.com/rokucommunity/ropm) to run.

Install the module.

```sh
$ cd ../path_to_your_roku_project
$ ropm install roku-jw
```
The Roku Package manager will download the dependencies and automatically move them into your project.

Import the library into your project (only one instance of the API can exist, so import this at a location that can be widely accessible)
```sh
<script type="text/brightscript" uri="pkg:/source/roku_modules/rokujw/player.brs" />
```
