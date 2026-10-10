# GlanceSwitch

**Switch windows by looking at them.** GlanceSwitch uses your webcam to follow your head
and eyes, and moves the keyboard focus, the mouse and the text cursor to the window you
look at. It works between monitors and between windows on a single screen.

## Download

Get the installer for your computer from the
**[latest release](https://github.com/orelrockah/GlanceSwitch/releases/latest)**.

| Computer | File |
|---|---|
| Mac with Apple Silicon (M1 or later), macOS 12+ | `GlanceSwitch-<version>-macOS-arm64.pkg` |
| Windows 10 / 11 (64-bit) | `GlanceSwitch-Setup-<version>.exe` |

Intel Macs are not supported yet.

## Install

**macOS**
1. Open the `.pkg`. If macOS says it is from an unidentified developer, right-click it,
   choose **Open**, then **Open** again.
2. Follow the installer. At the end it checks the installation and reports any problem.
3. Open **GlanceSwitch** from Applications. The eye icon appears in the menu bar. Allow
   **Camera**, **Accessibility** and, for the Double-Ctrl trigger, **Input Monitoring**.

**Windows**
1. Run `GlanceSwitch-Setup-<version>.exe`. If SmartScreen appears, choose **More info**,
   then **Run anyway**.
2. No administrator rights are needed. You can choose to start GlanceSwitch when you sign in.
3. At the end the installer checks the installation and reports any problem.

## Getting started

1. **Arrange Screens…** (menu bar or tray icon): place your screens and the camera.
2. **Calibrate Screens**: look at the dots that appear on the screen.
3. Look at a window and **tap Ctrl twice**, or choose *Dwell* to switch by looking
   at a window for a moment.

## Verify your download

Every release includes `SHA256SUMS.txt`.

```bash
# macOS
shasum -a 256 -c SHA256SUMS.txt --ignore-missing
```

```powershell
# Windows: compare the result with the line in SHA256SUMS.txt
Get-FileHash .\GlanceSwitch-Setup-<version>.exe -Algorithm SHA256
```

The installers also verify the installed files (model checksums and a test run) before
they report success.

## Privacy

The camera image is processed only on your computer. Nothing is recorded, stored or sent
anywhere.

---

<div dir="rtl">

### בעברית

**GlanceSwitch** מעביר את הפוקוס, העכבר וסמן הטקסט לחלון שאליו אתה מסתכל, בעזרת מצלמת
הרשת. מורידים את קובץ ההתקנה מ-[הגרסה האחרונה](https://github.com/orelrockah/GlanceSwitch/releases/latest):
`.pkg` למק עם Apple Silicon, או `.exe` ל-Windows. ההתקנה בודקת את עצמה בסוף. התמונה מהמצלמה
מעובדת רק במחשב שלך, ושום דבר לא נשמר או נשלח.

</div>
