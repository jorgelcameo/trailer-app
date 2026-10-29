sub Init()
  m.rowList = m.top.FindNode("rowList")
  m.rowList.SetFocus(true)
  m.descriptionLabel = m.top.FindNode("descriptionLabel")
  m.titleLabel = m.top.FindNode("titleLabel")
  m.logoutButton = m.top.FindNode("logoutButton")
  m.logoutButtonBackground = m.top.FindNode("logoutButtonBackground")
  m.top.ObserveField("visible", "OnVisibleChange")
  m.rowList.ObserveField("rowItemFocused", "OnItemFocused")
end sub

sub OnVisibleChange()
  if m.top.visible = true
    FocusLogout(false)
  end if
end sub

function OnKeyEvent(key as String, press as Boolean) as Boolean
  if not press
    return false
  end if

  if key = "up"
    ' If focused on row list, move to logout button
    if m.rowList.HasFocus()
      FocusLogout(true)
      return true
    end if
  else if key = "down"
    ' If focused on logout button, move back to row list
    if m.logoutButton.HasFocus()
      FocusLogout(false)
      return true
    end if
  else if key = "OK"
    if m.logoutButton.HasFocus()
      OnLogoutPressed()
      return true
    end if
  end if

  return false
end function

sub FocusLogout(focused as Boolean)
  if focused
    m.logoutButton.SetFocus(true)
    m.logoutButtonBackground.color = "0x3355FFFF"
  else
    m.rowList.SetFocus(true)
    m.logoutButtonBackground.color = "0x5882E8FF"
  end if
end sub

sub OnLogoutPressed()
  m.top.LogoutPressed = true
end sub

sub OnItemFocused()
  focusedIndex = m.rowList.rowItemFocused
  row = m.rowList.content.GetChild(focusedIndex[0])
  item = row.GetChild(focusedIndex[1])
  m.descriptionLabel.text = item.description
  m.titleLabel.text = item.title

  if item.length <> invalid
    m.titleLabel.text += " | " + GetTime(item.length)
  end if
end sub

function GetTime(length as Integer) as String
  minutes = (length \ 60).ToStr()
  seconds = length MOD 60

  if seconds < 10
    seconds = "0" + seconds.ToStr()
  else
    seconds = seconds.ToStr()
  end if

  return minutes + ":" + seconds
end function
