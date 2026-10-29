sub Init()
  m.top.functionName = "DoLogin"
  m.host = "https://impeding-dwelling-sternness.ngrok-free.dev"
end sub

sub DoLogin()
  port = CreateObject("roMessagePort")
  xfer = CreateObject("roUrlTransfer")
  xfer.SetMessagePort(port)
  xfer.SetCertificatesFile("common:/certs/ca-bundle.crt")
  xfer.InitClientCertificates()
  xfer.SetUrl(m.host + "/login")
  xfer.AddHeader("Content-Type", "application/x-www-form-urlencoded")
  xfer.AddHeader("ngrok-skip-browser-warning", "true")

  ' Escape() so characters like & + = in the password don't break the body
  body = "username=" + xfer.Escape(m.top.username) + "&password=" + xfer.Escape(m.top.password)

  if not xfer.AsyncPostFromString(body)
    m.top.result = { success: false, error: "Can't reach the server. Try again." }
    return
  end if

  msg = wait(10000, port)

  if type(msg) <> "roUrlEvent"
    ' Timed out
    xfer.AsyncCancel()
    m.top.result = { success: false, error: "Can't reach the server. Try again." }
    return
  end if

  code = msg.GetResponseCode()

  if code = 200
    json = ParseJson(msg.GetString())
    if json <> invalid and json.access_token <> invalid
      m.top.result = { success: true, token: json.access_token, contentType: json.content_type }
      return
    end if
  else if code < 0
    ' Negative codes are transport errors (DNS, TLS, connection refused...)
    m.top.result = { success: false, error: "Can't reach the server. Try again." }
    return
  end if

  m.top.result = { success: false, error: "Enter back you credentials." }
end sub
