```markdown
# Foothold Safety Assistant

A camera-based tool that highlights safe foot placement on hiking trails.
Built with PySide6 + QtQuick (glass UI) for a university team project.

![Foothold Safety Assistant UI](src/web/assets/sunset.jpg)

## Overview

Beginner trekkers often cannot tell where to place their foot on slippery, wet,
cracked, or loose ground, which leads to falls and injuries. This app uses a
camera and AI to look at the ground ahead and highlight safe areas in **green**,
uncertain areas in **yellow**, and risky areas in **red**, in real time.

## Features

| # | Feature | Description | Status |
|---|---------|-------------|--------|
| F1 | Live mode | Reads the camera feed and shows the risk overlay in real time | Planned |
| F2 | Upload mode | Analyzes an uploaded image or video with the same model and overlay | Planned |
| F3 | Risk overlay | Green = safe, yellow = uncertain, red = risky | Planned |
| F4 | Next step marker | Marks the safest nearby patch; shows a stop message if none is safe | Planned |
| F5 | Flag as wrong | User taps to save a frame the model got wrong, for later review | Planned |
| F6 | Sensitivity control | Lets the user make the overlay stricter or more relaxed | Planned |

## Stack

- Python 3.11.9
- PySide6 6.7.0 (QtQuick, QtQuick3D, QtQuick.Effects)
- OpenCV 4.9.0.80
- NumPy 1.26.4
- PyInstaller 6.22.3 (for `.exe` builds)

## Project Structure

```
foothold/
├── src/
│   ├── app.py              # PySide6 + QML launcher
│   └── web/
│       ├── main.qml        # Home screen UI
│       └── assets/
│           └── sunset.jpg  # Background image
├── models/                 # Trained .pt files
├── data/
│   ├── raw/                # Collected images
│   ├── review/             # Flagged frames awaiting review
│   └── labeled/            # Reviewed and labeled images
├── requirements.lock.txt
└── README.md
```

## Setup

```bash
py -3.11 -m venv .venv
.venv\Scripts\Activate.ps1
pip install -r requirements.lock.txt
pip install --force-reinstall "numpy==1.26.4" "opencv-python==4.9.0.80"
```

> **Important:** always reinstall `numpy` + `opencv-python` **together** as the
> last step whenever packages change. `opencv-python 4.9.0.80` is compiled
> against the NumPy 1.x C API and will crash if pip silently upgrades NumPy
> to 2.x. This is the single most common setup failure.

## Run

```bash
python src/app.py
```

The app opens a 1280×800 glass-themed home screen with **LIVE** and **UPLOAD**
buttons. Clicking either currently prints a message to the terminal; wiring them
to the camera and file picker is the next milestone.

## Build `.exe`

```bash
pyinstaller --noconfirm --windowed --name "FootholdSafety" ^
  --add-data "src/web;web" ^
  --hidden-import PySide6.QtQuick ^
  --hidden-import PySide6.QtQuick3D ^
  --hidden-import PySide6.QtQml ^
  --hidden-import PySide6.QtQuickEffects ^
  --collect-submodules PySide6.QtQuick3D ^
  src/app.py
```

Output: `dist/FootholdSafety/FootholdSafety.exe`

Test from a terminal first so any missing-DLL errors are visible:

```bash
.\dist\FootholdSafety\FootholdSafety.exe
```

## Tech Details

### Risk Engine Contract

The risk engine is a replaceable module with a fixed interface:

- **Input:** one BGR video frame (NumPy array)
- **Output:** a grid of risk values between 0 (safe) and 1 (risky), e.g. 12×16
- **Thresholds:** below 0.35 → green, 0.35–0.60 → yellow, above 0.60 → red

The current prototype uses `compute_risk_grid()` in pure image heuristics
(edges, glare, dark smooth areas). A trained model just has to return the same
kind of grid.

### Model Evolution

1. **Stage 1 — Heuristics (done):** simple image rules. Fast, no data needed.
2. **Stage 2 — Patch classification:** YOLO classification on grid patches.
3. **Stage 3 — Segmentation:** YOLO segmentation or U-Net for pixel outlines.
4. **Optional — Depth estimation:** catch steep drops and ledges.

## Safety Design

- A **yellow (uncertain)** state exists so the system does not force green or
  red when it is unsure.
- When no safe spot is found nearby, the UI shows a **stop-and-reassess** message.
- Thresholds lean cautious, because **a false green is worse than a false red.**
- The UI always shows that guidance is **not safety certified**.

## Not Safety Certified

This is decision support only. It does not replace a guide, proper footwear,
or trekking judgment. Test on varied terrain and lighting before any real trek
use, and never rely on it as the only safety measure.

## License

Team project. `ultralytics` is AGPL — fine for a team project, but if this
becomes commercial, swap to a U-Net implementation to avoid the AGPL license.
```
