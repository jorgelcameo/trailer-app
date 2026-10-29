sub Init()
  m.usernameField = m.top.FindNode("usernameField")
  m.passwordField = m.top.FindNode("passwordField")
  m.loginButtonBackground = m.top.FindNode("loginButtonBackground")
  m.errorLabel = m.top.FindNode("errorLabel")
  m.usernameBorder = m.top.FindNode("usernameBorder")
  m.passwordBorder = m.top.FindNode("passwordBorder")

  m.selectedField = 0
  m.dialog = invalid
  m.loginTask = invalid

  m.top.SetFocus(true)
  UpdateFieldSelection()
end sub

sub UpdateFieldSelection()
  m.usernameBorder.opacity = 0
  m.passwordBorder.opacity = 0
  m.loginButtonBackground.color = "0x5882E8FF"

  if m.selectedField = 0
    m.usernameBorder.opacity = 1
  else if m.selectedField = 1
    m.passwordBorder.opacity = 1
  else if m.selectedField = 2
    m.loginButtonBackground.color = "0x3355FFFF"
  end if
end sub

function OnKeyEvent(key as String, press as Boolean) as Boolean
  if not press
    return false
  end if

  if key = "down"
    if m.selectedField < 2
      m.selectedField += 1
      UpdateFieldSelection()
      return true
    end if
  else if key = "up"
    if m.selectedField > 0
      m.selectedField -= 1
      UpdateFieldSelection()
      return true
    end if
  else if key = "OK"
    if m.selectedField = 2
      AttemptLogin()
      return true
    else
      ShowKeyboard()
      return true
    end if
  end if

  return false
end function

sub ShowKeyboard()
  dialog = CreateObject("roSGNode", "StandardKeyboardDialog")
  if m.selectedField = 0
    dialog.title = "Username"
    dialog.text = m.usernameField.text
  else
    dialog.title = "Password"
    dialog.text = m.passwordField.text
    dialog.textEditBox.secureMode = true
  end if
  dialog.buttons = ["OK", "Cancel"]
  dialog.observeField("buttonSelected", "OnKeyboardButton")
  m.dialog = dialog
  m.top.GetScene().dialog = dialog
end sub

sub OnKeyboardButton()
  if m.dialog.buttonSelected = 0
    if m.selectedField = 0
      m.usernameField.text = m.dialog.text
    else
      m.passwordField.text = m.dialog.text
    end if
  end if
  m.dialog.close = true
  m.dialog = invalid
  m.top.SetFocus(true)
  UpdateFieldSelection()
end sub

sub AttemptLogin()
  m.errorLabel.visible = false
  m.errorLabel.text = ""

  username = m.usernameField.text
  password = m.passwordField.text

  if Len(username) = 0 or Len(password) = 0
    ShowError("Enter your credentials.")
    return
  end if

  LoginWithCredentials(username, password)
end sub

sub ShowError(message as String)
  m.errorLabel.text = message
  m.errorLabel.visible = true
end sub

sub LoginWithCredentials(username as String, password as String)
  ' Ignore extra OK presses while a request is already running
  if m.loginTask <> invalid and m.loginTask.state = "run"
    return
  end if

  m.loginTask = CreateObject("roSGNode", "LoginTask")
  m.loginTask.username = username
  m.loginTask.password = password
  m.loginTask.observeField("result", "OnLoginResult")
  m.loginTask.control = "RUN"
end sub

sub OnLoginResult()
  result = m.loginTask.result

  if result <> invalid and result.success = true
    m.top.loginResult = { success: true, token: result.token }
  else
    message = "Enter your credentials."
    if result <> invalid and result.error <> invalid
      message = result.error
    end if
    ShowError(message)
  end if
end sub
