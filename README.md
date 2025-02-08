# 🥁 BPM Kick Calculator 

_A simple PowerShell CLI tool for calculating kick drum timing intervals based on BPM_

---

## 🚀 Features

- ⚡ **Instant Calculations**: Convert BPM to milliseconds between kicks
- ⚙️ **Config Management**: Save/Edit base value (30,000 default) & BPM presets
- 📂 **Auto-Create Config**: Generates `config.json` on first run
- ↩️ **Menu Navigation**: Intuitive CLI interface with back/quit options
- ✔️ **Input Validation**: Handles invalid entries gracefully

---

## 📥 Installation & Startup

1. **Download Files**:
   - [`BpmCalculator.ps1`](BpmCalculator.ps1)
   - [`Run.bat`](Run.bat)

2. **Install**:
   - Create a new Folder
   - Move the files to this Folder
     
3. **Run**:
   - Double-click Run.bat
     (First run may require approving PowerShell execution)

---

## 🕹️ Quick CLI Guide
```text
=== Main Menu ===
1. 🧮 Calculate Kick Timing
2. ⚙ Edit Configuration
3. 🚪 Exit
```

**🔢 Calculation Flow**
1. Choose "Calculate" from main menu
2. Either:
	- Select preset BPM from list, or
	- Type custom BPM value
3. See instant result:
	30000 ÷ [BPM] = [ms]

**⚙ Configuration Options**
1. Edit Base Value: Change the 30,000 constant
2. Manage BPM Presets:
	- Add new BPM values
	- Remove existing entries
	- Auto-sorted list

---

## 🖥️ Example Calculation
```powershell
=== BPM Selection ===
1. 120 BPM
2. 128 BPM
3. 140 BPM

Enter: 
- Number from list
- Custom BPM
- 'b' to back

Your selection: 120

=== Result ===
Base Value: 30000
BPM: 120
Time between kicks: 250 ms
Formula: 30000 ÷ 120 = 250
```

---

## 💡 Future Ideas
- GUI version
- Multiple time signatures
- MIDI clock integration
- Export/import presets

---

Note: Requires Windows 10+ with PowerShell 5.1.
