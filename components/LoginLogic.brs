sub ShowLoginScreen()
  m.loginScreen = CreateObject("roSGNode", "LoginScreen")
  m.loginScreen.ObserveField("loginResult", "OnLoginAttempt")
  ShowScreen(m.loginScreen)
end sub

sub OnLoginAttempt(event as Object)
  result = event.GetData()

  if result.success = true
    m.authToken = result.token
    print "Authentication token stored: " + m.authToken
    CloseScreen(m.loginScreen)
    ShowGridScreen()
    RunContentTask()
  end if
end sub

sub Logout()
  m.authToken = invalid
  print "User logged out"
  CloseScreen(m.GridScreen)
  ShowLoginScreen()
end sub

function GetAuthToken() as String
  if m.authToken <> invalid
    return m.authToken
  end if
  return ""
end function
