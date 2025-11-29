# Joshua's Pebble Block Font

A bitmap-based TrueType font converted from hand-designed PNG glyphs.

## Prerequisites

Install FontForge and potrace:

```bash
brew install fontforge potrace
```

ImageMagick is also required (usually already installed via Homebrew).

## Usage

### Quick Start

Simply run the conversion script:

```bash
./convert_with_potrace.sh
```

This will:
1. Process all `U+*.png` files
2. Convert them to vectors using potrace
3. Generate `JPBF.ttf`

### Adding New Characters

1. Create a PNG file named with the Unicode code point:
   - Format: `U+XXXX.png` or `U+XXXX_C.png`
   - Example: `U+0041_A.png` for the letter 'A'
   - Image should be black on white background

2. Add the character to `create_font.py`:
   ```python
   chars = [
       # ... existing characters ...
       (0x0041, "U+0041_A.svg"),  # Add your new character
   ]
   ```

3. Run the conversion script again

## Current Glyphs

- **Space**: (U+0020)
- **Numbers**: 0-9
- **Letters**: A, B, H, I, L, M, N, P, T
- **Punctuation**: %, +, ,, -, ., /, :, ?
- **Special**: ° (degree), … (ellipsis), ▯ (white vertical rectangle)

## Files

- `convert_with_potrace.sh` - Main conversion script
- `create_font.py` - FontForge script generator
- `JPBF.ttf` - Generated font file
- `test.html` - Test page to preview the font
- `U+*.png` - Source bitmap glyphs

## Installation

Double-click `JPBF.ttf` to install the font on your system, or use Font Book on macOS.
