# src/app.py
import sys
import os
from pathlib import Path

os.environ.setdefault("QSG_RHI_BACKEND", "opengl")

from PySide6.QtCore import QUrl, QObject, Slot
from PySide6.QtGui import QGuiApplication
from PySide6.QtQml import QQmlApplicationEngine
from PySide6.QtQuickControls2 import QQuickStyle


def resource_path(rel: str) -> Path:
    """Works both in dev and inside a PyInstaller bundle."""
    if getattr(sys, "frozen", False):
        base = Path(sys._MEIPASS)
    else:
        base = Path(__file__).parent
    return base / rel


class Launcher(QObject):
    @Slot()
    def startLive(self):
        print("[Launcher] Live mode requested")

    @Slot()
    def startUpload(self):
        print("[Launcher] Upload mode requested")


def main():
    QQuickStyle.setStyle("Basic")
    app = QGuiApplication(sys.argv)

    engine = QQmlApplicationEngine()
    launcher = Launcher()
    engine.rootContext().setContextProperty("launcher", launcher)

    qml_file = resource_path("web/main.qml")
    engine.load(QUrl.fromLocalFile(str(qml_file)))

    if not engine.rootObjects():
        sys.exit(-1)
    sys.exit(app.exec())


if __name__ == "__main__":
    main()
