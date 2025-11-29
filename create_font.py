#!/usr/bin/env python3
"""
Create TTF font from SVG glyphs with proper metrics
"""
import subprocess
import os
from pathlib import Path

# Character mapping
chars = [
    (0x0025, "U+0025.svg"),
    (0x002B, "U+002B.svg"),
    (0x002C, "U+002C_,.svg"),
    (0x002D, "U+002D.svg"),
    (0x002E, "U+002E_..svg"),
    (0x002F, "U+002F.svg"),
    (0x0030, "U+0030_0.svg"),
    (0x0031, "U+0031_1.svg"),
    (0x0032, "U+0032_2.svg"),
    (0x0033, "U+0033_3.svg"),
    (0x0034, "U+0034_4.svg"),
    (0x0035, "U+0035_5.svg"),
    (0x0036, "U+0036_6.svg"),
    (0x0037, "U+0037_7.svg"),
    (0x0038, "U+0038_8.svg"),
    (0x0039, "U+0039_9.svg"),
    (0x003A, "U+003A.svg"),
    (0x003F, "U+003F.svg"),
    (0x0041, "U+0041_A.svg"),
    (0x0042, "U+0042_B.svg"),
    (0x0048, "U+0048_H.svg"),
    (0x0049, "U+0049_I.svg"),
    (0x004C, "U+004C_L.svg"),
    (0x004D, "U+004D_M.svg"),
    (0x004E, "U+004E_N.svg"),
    (0x0050, "U+0050_P.svg"),
    (0x0054, "U+0054_T.svg"),
    (0x00B0, "U+00B0.svg"),
    (0x2026, "U+2026.svg"),
    (0x25AF, "U+25AF.svg"),
]

# Build FontForge script
script = """#!/usr/bin/env fontforge

New()
SetFontNames("JPBF", "JPBF", "JPBF Regular", "Regular", "Copyright 2025", "1.0")
Reencode("unicode")
SetOS2Value("Weight", 400)
SetOS2Value("Width", 5)

"""

for codepoint, filename in chars:
    svg_path = f"temp_svg/{filename}"
    script += f"""
# U+{codepoint:04X}
Select({codepoint})
Import("{svg_path}")
Scale(67)
Simplify()
RoundToInt()
CorrectDirection()
AutoWidth(100)

"""

# Add space character
script += """
# U+0020 (Space)
Select(0x0020)
SetWidth(300)

"""

script += """
Generate("JPBF.ttf")
Print("Generated JPBF.ttf successfully!")
Quit()
"""

# Write script to file
with open("temp_fontforge.pe", "w") as f:
    f.write(script)

print("Running FontForge to create TTF with proper metrics...")
result = subprocess.run(["fontforge", "-script", "temp_fontforge.pe"], 
                       capture_output=True, text=True)

# Clean up
os.remove("temp_fontforge.pe")

if result.returncode == 0:
    print("✓ Font created successfully!")
else:
    print("Errors:", result.stderr)
