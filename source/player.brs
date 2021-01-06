function player(target = "" as String ) as Object
  _m = m

  this = {
    '*************************************************************************
    '#region *** INTERNAL
    '*************************************************************************
    "_name": "jwplayer",
    "_data": {
      "config": {
        "aspectratio": "16:9"
        "autostart": false,
        "height": 1920,
        "mute": false,
        "repeat": false,
        "stretching": "uniform",
        "volume": 100,
        "width": 1080
      },
      "seeking": {
        "active": false,
        "wasActive": false,
        "position": 0
      },
      "position": 0,
      "duration": 0
    }
    "_m": m,
    "_videoNode": Invalid,
    '*************************************************************************
    '#endregion *** INTERNAL
    '*************************************************************************
  
    '*************************************************************************
    '#region *** HELPERS
    '*************************************************************************
    "on": function(fieldName as String, fn)
      m["on" + fieldName].fn = fn
      return m
    end function,
    '*************************************************************************
    '#endregion *** HELPERS
    '*************************************************************************
  
    '*************************************************************************
    '#region *** SETUP
    '*************************************************************************
    "setup": function(params = {} as Object)
      di = CreateObject("roDeviceInfo")
      osVersion = di.getOSVersion()
      m._data.environment = {
        "OS": {
          "roku": true,
          "version": {
            "version": osVersion.major.toStr() + "_" + osVersion.minor.toStr() + "_" + osVersion.revision.toStr()+ "_" + osVersion.build.toStr(),
            "major": osVersion.major,
            "minor": osVersion.minor
          }
        },
        "features": {}
      }

      videoNodeTarget = m._m.top.findNode(m.target)
      if NOT params.autostart = invalid then m._data.config.autostart = params.autostart

      if NOT videoNodeTarget = Invalid then
        videoNode = createObject("roSGNode", "Video")
        videoNode.id = "videoNode"
        videoNode.enableUI = false
        videoNode.timedMetaDataSelectionKeys = ["*"]
        videoNode.observeFieldScoped("timedMetaData", "onTimedMetaDataChange")
        videoNode.observeFieldScoped("timeToStartStreaming", "onTimeToStartStreamingChange")
        videoNode.observeFieldScoped("position", "onTimeChange")
        videoNode.observeFieldScoped("state", "onStateChange")
        videoNode.observeFieldScoped("bufferingStatus", "onBufferingStatusChange")
        videoNode.contentIsPlaylist = true
        videoNodeTarget.appendChild(videoNode)
        m._videoNode = videoNode
        m["onReady"].fn(m["onReady"].scope)
      end if
      return m
    end function,
    "remove": sub()
    end sub,
    "setConfig": function(config = {} as Object)
      deepMerge(m._data.config, config)
      return m
    end function,
    "getProvider": sub()
    end sub,
    "getContainer": function()
      return m._m.top.findNode(m.target)
    end function,
    "getEnvironment": function()
      return m._data.environment
    end function,
    "getPlugin": function()
    end function,
    "onReady": {
      "fn": function(m)
      end function,
      "scope": m
    },
    "onSetupError": {
      "fn": function(m)
      end function,
      "scope": m
    },
    "onRemove": {
      "fn": function(m)
      end function,
      "scope": m
    },
    ' ADVERTISING
    "getAdBlock": function()
      return false
    end function,
    "pauseAd": sub(state)
    end sub,
    "playAd": sub(tag)
    end sub,
    "skipAd": sub()
    end sub,
    "onAdBidRequest": {
      "fn": function(m, obj)
        ' https://developer.jwplayer.com/jwplayer/docs/jw8-javascript-api-reference#section-jwplayer-on-ad-bid-request
      end function,
      "scope": m
    },
    "onAdBidResponse": {
      "fn": function(m, obj)
        ' https://developer.jwplayer.com/jwplayer/docs/jw8-javascript-api-reference#section-jwplayer-on-ad-bid-response
      end function,
      "scope": m
    },
    "onAdBlock": {
      "fn": function(m)
      end function,
      "scope": m
    },
    "onAdBreakEnd": {
      "fn": function(m)
      end function,
      "scope": m
    },
    "onAdBreakStart": {
      "fn": function(m)
      end function,
      "scope": m
    },
    '*************************************************************************
    '#endregion *** SETUP
    '*************************************************************************

    '*************************************************************************
    '#region *** AUDIO TRACKS
    '*************************************************************************
    "getAudioTracks": function()
      return []
    end function,
    "getCurrentAudioTrack": function()
      return -1
    end function,
    '*************************************************************************
    '#endregion *** AUDIO TRACKS
    '*************************************************************************

    '*************************************************************************
    '#region *** BUFFER
    '*************************************************************************
    "getBuffer": function()
      return 100
    end function,
    "onBufferChange": {
      "fn": function(m, data ={})
      end function,
      "scope": m
    },
    '*************************************************************************
    '#endregion *** BUFFER
    '*************************************************************************

    '*************************************************************************
    '#region *** CAPTIONS
    '*************************************************************************
    '*************************************************************************
    '#endregion *** CAPTIONS
    '*************************************************************************

    '*************************************************************************
    '#region *** CONTROLS
    '*************************************************************************
    '*************************************************************************
    '#endregion *** CONTROLS
    '*************************************************************************

    '*************************************************************************
    '#region *** METADATA
    '*************************************************************************
    '*************************************************************************
    '#endregion *** METADATA
    '*************************************************************************

    '*************************************************************************
    '#region *** PLAYBACK
    '*************************************************************************
    "getState": function()
      state = "idle"

      if NOT m._videoNode = invalid then
        videoNodeState = m._videoNode.state
        if NOT videoNodeState = "none" AND NOT videoNodeState = "stopped"
          if NOT videoNodeState = "finished" AND NOT videoNodeState = "error" then
            state = videoNodeState
          end if
        end if
      end if

      return state
    end function,
    "pause": function()
      videoNode = m._videoNode
      if NOT videoNode = invalid then
        state = videoNode.state
        if state = "paused" then return m
        videoNode.control = "pause"
      end if
      return m
    end function,
    "play": function()
      videoNode = m._videoNode
      if NOT videoNode = invalid then
        state = videoNode.state
        if state = "playing" then return m.pause()

        if state = "paused" then
          if m._data.seeking.active then
            m._data.seeking.active = false
            videoNode.seek = m._data.position
          else
            videoNode.control = "resume"
          end if
        else
          videoNode.control = "play"
        end if
      end if
      return m
    end function,
    "stop": function()
      if NOT m._videoNode = invalid then m._videoNode.control = "stop"
      return m
    end function,
    "onComplete": {
      "fn": function(m)
      end function,
      "scope": m
    },
    "onFirstFrame": {
      "fn": function(m, loadTime = 0, viewable = false)
      end function,
      "scope": m
    },
    "onIdle": {
      "fn": function(m)
      end function,
      "scope": m
    },
    "onPause": {
      "fn": function(m)
      end function,
      "scope": m
    },
    "onPlay": {
      "fn": function(m)
      end function,
      "scope": m
    },
    "onTime": {
      "fn": sub(m, position = 0, duration = 0)
      end sub,
      "scope": m
    },
    '*************************************************************************
    '#endregion *** PLAYBACK
    '*************************************************************************
    
    '*************************************************************************
    '#region *** PLAYLIST
    '*************************************************************************
    "load": function(playlistItems = [])
      playlist = CreateObject("RoSGNode", "ContentNode")

      for each item in playlistItems
        file = item.file
        streamFormat = "hls"
        if file.Instr(".mkv") > -1 then streamFormat = "mkv"

        itemNode = CreateObject("RoSGNode", "ContentNode")
        itemNode.title = item.title
        itemNode.streamFormat = streamFormat
        itemNode.url = file
        playlist.appendChild(itemNode)
      end for

      if NOT m._videoNode = invalid then
        m._videoNode.content = playlist
        if m._data.config.autostart then m.play()
      end if
      return m
    end function,
    "next": function()
      if NOT m._videoNode = invalid then m._videoNode.control = "skipcontent"
      return m
    end function,
    '*************************************************************************
    '#endregion *** PLAYLIST
    '*************************************************************************

    '*************************************************************************
    '#region *** QUALITY
    '*************************************************************************
    "getQualityLevels": {
      "fn": function()
        qualityLevels = []
        return qualityLevels
      end function
    },
    "getCurrentQuality": {
      "fn": function()
        return 0
      end function
    },
    "getVisualQuality": {
      "fn": function()
        return {
          "mode": "auto",
          "level": 0,
          "reason": "auto"
        }
      end function
    },
    '*************************************************************************
    '#endregion *** QUALITY
    '*************************************************************************

    '*************************************************************************
    '#region *** RELATED
    '*************************************************************************
    '*************************************************************************
    '#endregion *** RELATED
    '*************************************************************************

    '*************************************************************************
    '#region *** RESIZE
    '*************************************************************************
    '*************************************************************************
    '#endregion *** RESIZE
    '*************************************************************************

    '*************************************************************************
    '#region *** SEEK
    '*************************************************************************
    "seek": sub(position = 0)
      videoNode = m._videoNode
      if NOT videoNode = invalid then
        if NOT m._data.seeking.active then
          m._data.seeking.active = true
          m._data.seeking.startPosition = m._data.position
          videoNode.control = "pause"
        end if

        m._data.position = position

        onTime = m.onTime
        onTime.fn(onTime.scope, position, videoNode.duration)
      end if
    end sub,
    "fastForward": sub()
      m.seek(m._data.position + 10)
    end sub,
    "rewind": sub()
      m.seek(m._data.position - 10)
    end sub,
    "onSeek": {
      "fn": sub(m, position = 0, offset = 0)
      end sub,
      "scope": m
    }
    '*************************************************************************
    '#endregion *** SEEK
    '*************************************************************************
    
    '*************************************************************************
    '#region *** VIEWABILITY
    '*************************************************************************
    '*************************************************************************
    '#endregion *** VIEWABILITY
    '*************************************************************************
    
    '*************************************************************************
    '#region *** VOLUME
    '*************************************************************************
    '*************************************************************************
    '#endregion *** VOLUME
    '*************************************************************************
  }

  if NOT target = "" then this.target = target

  return this
end function


sub onBufferingStatusChange(event as object)
  bufferingStatus = event.getData()
  if bufferingStatus = invalid then return

  jwPlayer = rokujw_getJWPlayer()
  onBufferChange = jwPlayer["onBufferChange"]
  update = onBufferChange.fn(onBufferChange.scope, {
    "duration": jwPlayer._data.duration
    "bufferPercent": bufferingStatus.percentage
    "position": jwPlayer._data.position
    "metadata": {
      "bandwidth": 0
      "droppedFrames": 0
    }
  })
end sub

sub onTimedMetaDataChange(event as object)
  timedMetaDataS = event.getData()
  jwPlayer = rokujw_getJWPlayer()
end sub

sub onTimeToStartStreamingChange(event as object)
  ttss = event.getData()
  if ttss = 0 then return
  jwPlayer = rokujw_getJWPlayer()

  onFirstFrame = jwPlayer["onFirstFrame"]
  viewable = false
  videoNode = jwPlayer._videoNode
  if NOT videoNode = invalid then viewable = videoNode.visible

  onFirstFrame.fn(onFirstFrame.scope, ttss, viewable)
end sub

sub onStateChange(event)
  state = event.getData()
  jwPlayer = getJWPlayer()

  if state = "paused" then
    update = jwPlayer["onPause"].fn(jwPlayer["onPause"].scope)
  else if state = "playing" then
    update = jwPlayer["onPlay"].fn(jwPlayer["onPlay"].scope)
  else if state = "stopped" then
    update = jwPlayer["onIdle"].fn(jwPlayer["onIdle"].scope)
  else if state = "finished" then
    update = jwPlayer["onComplete"].fn(jwPlayer["onComplete"].scope)
  end if
end sub

sub onTimeChange(event)
  jwPlayer = getJWPlayer()
  viewable = false
  videoNode = jwPlayer._videoNode
  data = jwPlayer._data
  data.position = event.getData()
  data.duration = videoNode.duration

  onTime = jwPlayer.onTime
  if NOT onTime = invalid AND NOT data.seeking.active then update = onTime.fn(onTime.scope, data.position, data.duration)
end sub


' /**
' * @name deepMerge
' * @description Used to deep merge AssociativeArrays.
' * Useful for cases where you need to update large nested associative arrays.
' * @param {Dynamic} baseAA AssociativeArray you want to modify.
' * @param {AssociativeArray} a AssociativeArray you want to merge over baseAA.
' * @param {AssociativeArray} b an optional AssociativeArray you want to merge over baseAA after modified by a.
' * @param {AssociativeArray} c an optional AssociativeArray you want to merge over baseAA after modified by a and b.
' */
function deepMerge(baseAA as Dynamic, a as Dynamic, b = Invalid as Dynamic, c = Invalid as Dynamic) as Dynamic
	if NOT isAA(baseAA) then return Invalid
	if isAA(a) then
		for each key in a
			item = a[key]
			if isAA(baseAA[key]) then
				deepMerge(baseAA[key], item)
			else
				baseAA[key] = item
			end if
		end for
	end if

	if isAA(b) then
		deepMerge(baseAA, b)
	end if

	if isAA(c) then
		deepMerge(baseAA, c)
	end if

	return baseAA
end function


function getJWPlayer()
  for each key in m
    child = m[key]
    if type(child) = "roAssociativeArray" AND NOT child._name = invalid AND child._name = "jwplayer" then
      return child
    end if
  end for

  return invalid
end function