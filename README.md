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

## Quick install (one line, no security prompts)

The script downloads the latest release, checks its SHA-256 against
`SHA256SUMS.txt`, and runs the normal installer, which verifies the installation
at the end. Read it first if you like: [install.sh](install.sh) · [install.ps1](install.ps1).

**macOS**: paste into Terminal (it asks for your Mac password once):
```bash
curl -fsSL https://raw.githubusercontent.com/orelrockah/GlanceSwitch/main/install.sh | bash
```

**Windows**: paste into PowerShell:
```powershell
irm https://raw.githubusercontent.com/orelrockah/GlanceSwitch/main/install.ps1 | iex
```

Run the same line again to update.

## Install from the download page

**macOS**
1. Open the `.pkg`. Because the installer is not signed by Apple, macOS shows
   *"Apple could not verify…"*. Click **Done** (not *Move to Trash*), open
   **System Settings → Privacy & Security**, scroll down and click **Open Anyway**
   next to the GlanceSwitch installer, then confirm with your password or Touch ID.
   Or, in Terminal: `xattr -d com.apple.quarantine ~/Downloads/GlanceSwitch-*.pkg`
   and open the file again.
2. Follow the installer. At the end it checks the installation and reports any problem.
3. Open **GlanceSwitch** from Applications. The eye icon appears in the menu bar; its
   first line shows the installed version. Allow
   **Camera**, **Accessibility** and, for the Double-Ctrl trigger, **Input Monitoring**.

**Windows**
1. Run `GlanceSwitch-Setup-<version>.exe`. If SmartScreen appears, choose **More info**,
   then **Run anyway**.
2. No administrator rights are needed. You can choose to start GlanceSwitch when you sign in.
3. At the end the installer checks the installation and reports any problem.

## Blocked by macOS or Windows?

The installers are not signed with a paid certificate, so the system may block them.
These commands remove the "downloaded from the internet" mark.

**macOS** ("Apple could not verify…"), in Terminal:
```bash
# the downloaded installer
xattr -d com.apple.quarantine ~/Downloads/GlanceSwitch-*.pkg
```
```bash
# the installed app: unblock and open
xattr -dr com.apple.quarantine /Applications/GlanceSwitch.app && open /Applications/GlanceSwitch.app
```

**Windows** ("Windows protected your PC"), in PowerShell:
```powershell
Unblock-File "$env:USERPROFILE\Downloads\GlanceSwitch-Setup-*.exe"
```

Or use the [one-line install](#quick-install-one-line-no-security-prompts), which is never blocked.

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

**התקנה בשורה אחת, בלי אזהרות אבטחה:** במק מדביקים בטרמינל
`curl -fsSL https://raw.githubusercontent.com/orelrockah/GlanceSwitch/main/install.sh | bash`,
וב-Windows מדביקים ב-PowerShell
`irm https://raw.githubusercontent.com/orelrockah/GlanceSwitch/main/install.ps1 | iex`.
הסקריפט מוריד את הגרסה האחרונה, בודק את טביעת האצבע שלה ומתקין.

**נחסם?** במק מריצים בטרמינל:

```bash
xattr -d com.apple.quarantine ~/Downloads/GlanceSwitch-*.pkg
```

ואם האפליקציה עצמה נחסמת אחרי ההתקנה:

```bash
xattr -dr com.apple.quarantine /Applications/GlanceSwitch.app && open /Applications/GlanceSwitch.app
```

ב-Windows מריצים ב-PowerShell:

```powershell
Unblock-File "$env:USERPROFILE\Downloads\GlanceSwitch-Setup-*.exe"
```

**במק:** אם מופיעה ההודעה "Apple could not verify", לחצו `Done`, פתחו את **הגדרות המערכת ←
פרטיות ואבטחה**, גללו למטה ולחצו `Open Anyway` ליד קובץ ההתקנה. **ב-Windows:** אם מופיע
"Windows protected your PC", לחצו `More info` ואז `Run anyway`.

</div>
