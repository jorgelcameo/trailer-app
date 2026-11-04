sub ShowVideoScreen(content as Object, itemIndex as Integer)
  m.videoPlayer = CreateObject("roSGNode", "Video")

  ' Configure buffering for slow connections
  bufferingConfig = {
    initialBufferTime: 5000
    resumeBufferTime: 2000
  }
  m.videoPlayer.bufferingConfig = bufferingConfig

  if itemIndex <> 0
    numOfChildren = content.GetChildCount()
    children = content.GetChildren(numOfChildren - itemIndex, itemIndex)
    childrenClone = []
    for each child in children
      childrenClone.Push(child.Clone(true))
    end for
    node = CreateObject("roSGNode", "ContentNode")
    node.Update({ children: childrenClone }, true)
    m.videoPlayer.content = node
  else
    m.videoPlayer.content = content.Clone(true)
  end if

  m.videoPlayer.contentIsPlaylist = true
  m.videoPlayer.enableCookies = true
  m.videoPlayer.showSubtitles = false

  m.videoPlayer.ObserveField("state", "OnVideoPlayerStateChange")
  m.videoPlayer.ObserveField("bufferingStatus", "OnVideoBufferingStatusChange")
  m.videoPlayer.ObserveField("streamInfo", "OnVideoStreamInfoChange")

  ShowScreen(m.videoPlayer)
  m.videoPlayer.control = "play"
  m.videoPlayer.ObserveField("visible", "OnVideoVisibleChange")
end sub

sub OnVideoPlayerStateChange()
  state = m.videoPlayer.state
  print "Video state: "; state; " position="; m.videoPlayer.position
  if state = "error"
    print "Video error code: "; m.videoPlayer.errorCode
    print "Video error msg: "; m.videoPlayer.errorMsg
    print "Video error info: "; m.videoPlayer.errorInfo
  end if
  if state = "error" or state = "finished"
    CloseScreen(m.videoPlayer)
  end if
end sub

' bufferingStatus is only valid while buffering; it becomes invalid when done
sub OnVideoBufferingStatusChange()
  status = m.videoPlayer.bufferingStatus
  if status = invalid
    print "Video buffering: done position="; m.videoPlayer.position
    return
  end if
  print "Video buffering: "; status.percentage; "% underrun="; status.isUnderrun; " position="; m.videoPlayer.position
end sub

sub OnVideoStreamInfoChange()
  info = m.videoPlayer.streamInfo
  if info = invalid
    return
  end if
  print "Video stream: measuredBitrate="; info.measuredBitrate; " streamBitrate="; info.streamBitrate; " underrun="; info.isUnderrun; " resume="; info.isResume
end sub

sub OnVideoVisibleChange()
  if m.videoPlayer.visible = false and m.top.visible = true
    currentIndex = m.videoPlayer.contentIndex
    m.videoPlayer.control = "stop"
    m.videoPlayer.content = invalid
    m.GridScreen.SetFocus(true)
    m.GridScreen.jumpToRowItem = [m.selectedIndex[0], currentIndex + m.selectedIndex[1]]
  end if
end sub
