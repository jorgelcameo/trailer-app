sub RunContentTask()
  m.contentTask = CreateObject("roSGNode", "ContentLoaderTask")
  m.contentTask.authToken = GetAuthToken()
  m.contentTask.ObserveField("content", "OnContentLoaded")
  m.contentTask.control = "run"
  m.loadingIndicator.visible = true
end sub

sub OnContentLoaded()
  m.GridScreen.SetFocus(true)
  m.loadingIndicator.visible = false
  m.GridScreen.content = m.contentTask.content
end sub
