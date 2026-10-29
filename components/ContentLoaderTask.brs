sub Init()
  m.top.functionName = "GetContent"
  m.staticHost = "https://impeding-dwelling-sternness.ngrok-free.dev"
end sub

sub GetContent()
  xfer = CreateObject("roURLTransfer")
  xfer.SetCertificatesFile("common:/certs/ca-bundle.crt")
  xfer.SetURL(m.staticHost + "/trailers")

  ' Add authorization header with JWT token
  if m.top.authToken <> invalid and m.top.authToken <> ""
    xfer.AddHeader("Authorization", "Bearer " + m.top.authToken)
    print "Authorization header added"
  end if

  rsp = xfer.GetToString()

  print "API Response: " + rsp

  rootChildren = []
  json = ParseJson(rsp)

  if json <> invalid AND json.Count() > 0
    row = {}
    row.title = "Trailers"
    row.children = []

    for each trailer in json
      itemData = GetTrailerData(trailer)
      if itemData <> invalid
        row.children.Push(itemData)
      end if
    end for

    rootChildren.Push(row)

    contentNode = CreateObject("roSGNode", "ContentNode")
    contentNode.Update({
      children: rootChildren
    }, true)
    m.top.content = contentNode

    print "Loaded " + row.children.Count().ToStr() + " trailers"
  else
    print "Failed to fetch or parse trailers from API"
  end if
end sub

function GetTrailerData(trailer as Object) as Object
  if trailer = invalid
    return invalid
  end if

  item = {}

  if trailer["title"] <> invalid
    item.title = trailer["title"]
  else
    item.title = "Unknown"
  end if

  if trailer["long_description"] <> invalid
    item.description = trailer["long_description"]
  else if trailer["short_description"] <> invalid
    item.description = trailer["short_description"]
  else
    item.description = ""
  end if

  if trailer["thumbnail_url"] <> invalid
    thumbnailUrl = trailer["thumbnail_url"]
    if thumbnailUrl.Left(4) <> "http"
      item.hdPosterURL = m.staticHost + thumbnailUrl
    else
      item.hdPosterURL = thumbnailUrl
    end if
  end if

  if trailer["id"] <> invalid
    item.id = trailer["id"]
  end if

  if trailer["duration"] <> invalid
    item.length = trailer["duration"]
  end if

  if trailer["video_url"] <> invalid
    videoUrl = trailer["video_url"]
    if videoUrl.Left(4) <> "http"
      item.url = m.staticHost + videoUrl
    else
      item.url = videoUrl
    end if
  end if

  if trailer["video_type"] <> invalid
    item.streamFormat = LCase(trailer["video_type"])
  else
    item.streamFormat = "mp4"
  end if

  item.contentType = "episode"

  ' Add buffering/streaming hints for slow connections
  item.switchingStrategy = "aggressive"
  item.isxmlfile = false

  return item
end function
