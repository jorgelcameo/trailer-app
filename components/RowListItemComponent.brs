sub OnContentSet()
  content = m.top.itemContent
  if content <> invalid AND content.hdPosterURL <> invalid
    m.top.FindNode("poster").uri = content.hdPosterURL
  end if
end sub
