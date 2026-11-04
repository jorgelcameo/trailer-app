sub Init()
  m.top.functionName = "DoLogin"
  m.host = "https://evjj5l2215.execute-api.us-east-2.amazonaws.com"
end sub

sub DoLogin()
  port = CreateObject("roMessagePort")
  xfer = CreateObject("roUrlTransfer")
  xfer.SetMessagePort(port)
  xfer.SetCertificatesFile("common:/certs/ca-bundle.crt")
  xfer.InitClientCertificates()
  xfer.SetUrl(m.host + "/login")
  xfer.AddHeader("Content-Type", "application/x-www-form-urlencoded")

  ' Escape() so characters like & + = in the password don't break the body
  body = "username=" + xfer.Escape(m.top.username) + "&password=" + xfer.Escape(m.top.password)

  print "Login: POST " + m.host + "/login"

  if not xfer.AsyncPostFromString(body)
    print "Login: AsyncPostFromString failed"
    m.top.result = { success: false, error: "Can't reach the server. Try again." }
    return
  end if

  msg = wait(10000, port)

  if type(msg) <> "roUrlEvent"
    print "Login: timed out after 10s"
    xfer.AsyncCancel()
    m.top.result = { success: false, error: "Can't reach the server. Try again." }
    return
  end if

  code = msg.GetResponseCode()
  print "Login: response code " + code.ToStr()
  if code < 0
    print "Login: failure reason: " + msg.GetFailureReason()
  end if

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
