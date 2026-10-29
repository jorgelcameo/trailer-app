# Trailer Roku App

A Roku channel application that displays movie trailers fetched from the Trailer API and includes a built-in video player.

## Features

- ✅ Grid-based trailer display using RowList
- ✅ Fetches trailers from API endpoint: `https://impeding-dwelling-sternness.ngrok-free.dev/trailers`
- ✅ Integrated video player with playlist support
- ✅ Dynamic thumbnail loading from API
- ✅ Back button navigation support
- ✅ Smooth transitions between grid and video player

## Project Structure

```
trailer-roku-app/
├── source/
│   └── main.brs                    # Application entry point
├── components/
│   ├── MainScene.xml/.brs          # Main scene orchestrator
│   ├── GridScreen.xml/.brs         # Trailer grid display
│   ├── RowListItemComponent.xml/.brs # Individual trailer item
│   ├── ContentLoaderTask.xml/.brs  # API data fetching
│   ├── ScreenStackLogic.brs        # Screen stack management
│   ├── ContentTaskLogic.brs        # Content loading logic
│   ├── GridScreenLogic.brs         # Grid screen event handling
│   └── VideoPlayerLogic.brs        # Video playback handling
├── images/                         # Channel assets
├── manifest                        # Channel metadata
└── README.md                       # This file
```

## Components Overview

### MainScene
- Orchestrates the application flow
- Manages screen stack for navigation
- Initializes grid screen and content loading
- Handles back button events

### GridScreen
- Displays trailers in a grid (RowList)
- Shows title and description of focused trailer
- Triggers video player when trailer is selected

### ContentLoaderTask
- Makes HTTP request to the trailer API
- Parses JSON response into ContentNode structure
- Handles trailer metadata mapping

### VideoPlayerLogic
- Displays full-screen video player
- Supports playlist navigation
- Returns to grid when video ends or user presses back

## API Integration

The app fetches trailers from:
```
https://impeding-dwelling-sternness.ngrok-free.dev/trailers
```

Expected API response format:
```json
[
  {
    "id": "trailer-1",
    "title": "Attack On Titan The Final Season Final Chapter",
    "short_description": "...",
    "long_description": "...",
    "thumbnail_url": "http://localhost:8000/files/..._thumbnail.png",
    "video_url": "http://localhost:8000/files/..._video.mp4",
    "video_type": "MP4",
    "duration": 78,
    "quality": "HD",
    ...
  }
]
```

## Development

### Prerequisites
- Roku device in developer mode
- Roku SDK installed
- Network access to the trailer API

### Build & Deploy
```bash
# Using makefile (if available)
make install

# Or manually:
# 1. Zip the contents of this directory
# 2. Use Roku Dev Manager to install the package
```

### Testing
1. Deploy the app to your Roku device
2. Navigate to the channel
3. Wait for trailers to load from the API
4. Select a trailer to play
5. Use back button to return to grid

## Data Mapping

The app maps API response fields to Roku ContentNode metadata:

| API Field | Roku Field | Purpose |
|-----------|-----------|---------|
| `title` | `title` | Trailer name |
| `short_description` | `description` | Short info |
| `long_description` | `description` | Full info |
| `thumbnail_url` | `hdPosterURL` | Grid display image |
| `video_url` | `url` | Video stream URL |
| `video_type` | `streamFormat` | Stream format (MP4, HLS, etc.) |
| `duration` | `length` | Duration in seconds |
| `quality` | `quality` | Video quality |

## Troubleshooting

### Trailers not loading
- Check network connectivity
- Verify ngrok tunnel is active and accessible
- Check device logs for API errors

### Video won't play
- Ensure video URL is accessible from Roku device
- Check that streamFormat matches the actual video format
- Verify duration is a valid integer

### Thumbnails not showing
- Verify thumbnail_url is a valid image URL
- Check image dimensions match RowList expectations
- Test URL accessibility from Roku device
