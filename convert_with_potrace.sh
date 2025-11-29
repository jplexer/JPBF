#!/bin/bash
# Convert bitmap font to TTF using potrace for better vector tracing

echo "Creating temporary directories..."
rm -rf temp_bw temp_svg
mkdir -p temp_bw temp_svg

echo ""
echo "Step 1: Converting PNGs to pure black & white..."
for png in U+*.png; do
    if [ -f "$png" ]; then
        base="${png%.png}"
        echo "  $png -> temp_bw/$png"
        
        # Convert to pure black and white bitmap
        magick "$png" \
            -alpha remove \
            -background white \
            -flatten \
            -colorspace Gray \
            -contrast-stretch 0 \
            -threshold 50% \
            -type bilevel \
            "temp_bw/$png"
    fi
done

echo ""
echo "Step 2: Tracing bitmaps to SVG vectors with potrace..."
for png in temp_bw/U+*.png; do
    if [ -f "$png" ]; then
        base=$(basename "$png" .png)
        echo "  $png -> temp_svg/${base}.svg"
        
        # Convert PNG to PBM (potrace input format)
        magick "$png" "temp_bw/${base}.pbm"
        
        # Trace with potrace to SVG
        potrace -s -o "temp_svg/${base}.svg" "temp_bw/${base}.pbm" 2>/dev/null
        
        rm "temp_bw/${base}.pbm"
    fi
done

echo ""
echo "Step 3: Creating FontForge script..."
cat > temp_convert.pe << 'EOF'
#!/usr/bin/env fontforge

New()
SetFontNames("JPBF", "JPBF", "JPBF Regular", "Regular", "Copyright 2025", "1.0")
Reencode("unicode")
SetOS2Value("Weight", 400)
SetOS2Value("Width", 5)

# Helper function to import and fix metrics
procedure FixGlyph()
    Simplify()
    RoundToInt()
    
    # Get bounding box
    bb = GlyphInfo("BBox")
    
    # Move glyph to origin (left bearing = 0)
    Move(-bb[0], 0)
    
    # Recalculate bounding box after move
    bb = GlyphInfo("BBox")
    
    # Set width to bounding box width plus small margins
    width = bb[2] + 50
    SetWidth(width)
endprocedure

# Import SVG glyphs with proper metrics
Select(0x0025); Import("temp_svg/U+0025.svg"); FixGlyph()
Select(0x002C); Import("temp_svg/U+002C_,.svg"); FixGlyph()
Select(0x002D); Import("temp_svg/U+002D.svg"); FixGlyph()
Select(0x002E); Import("temp_svg/U+002E_..svg"); FixGlyph()
Select(0x002F); Import("temp_svg/U+002F.svg"); FixGlyph()
Select(0x0030); Import("temp_svg/U+0030_0.svg"); FixGlyph()
Select(0x0031); Import("temp_svg/U+0031_1.svg"); FixGlyph()
Select(0x0032); Import("temp_svg/U+0032_2.svg"); FixGlyph()
Select(0x0033); Import("temp_svg/U+0033_3.svg"); FixGlyph()
Select(0x0034); Import("temp_svg/U+0034_4.svg"); FixGlyph()
Select(0x0035); Import("temp_svg/U+0035_5.svg"); FixGlyph()
Select(0x0036); Import("temp_svg/U+0036_6.svg"); FixGlyph()
Select(0x0037); Import("temp_svg/U+0037_7.svg"); FixGlyph()
Select(0x0038); Import("temp_svg/U+0038_8.svg"); FixGlyph()
Select(0x0039); Import("temp_svg/U+0039_9.svg"); FixGlyph()
Select(0x003A); Import("temp_svg/U+003A.svg"); FixGlyph()
Select(0x003F); Import("temp_svg/U+003F.svg"); FixGlyph()
Select(0x0041); Import("temp_svg/U+0041_A.svg"); FixGlyph()
Select(0x0042); Import("temp_svg/U+0042_B.svg"); FixGlyph()
Select(0x0048); Import("temp_svg/U+0048_H.svg"); FixGlyph()
Select(0x0049); Import("temp_svg/U+0049_I.svg"); FixGlyph()
Select(0x004C); Import("temp_svg/U+004C_L.svg"); FixGlyph()
Select(0x004D); Import("temp_svg/U+004D_M.svg"); FixGlyph()
Select(0x004E); Import("temp_svg/U+004E_N.svg"); FixGlyph()
Select(0x0050); Import("temp_svg/U+0050_P.svg"); FixGlyph()
Select(0x0054); Import("temp_svg/U+0054_T.svg"); FixGlyph()
Select(0x00B0); Import("temp_svg/U+00B0.svg"); FixGlyph()
Select(0x2026); Import("temp_svg/U+2026.svg"); FixGlyph()
Select(0x25AF); Import("temp_svg/U+25AF.svg"); FixGlyph()

Generate("JPBF.ttf")
Print("Generated JPBF.ttf successfully!")
Quit()
EOF

echo ""
echo "Step 4: Running FontForge to create TTF with proper metrics..."
python3 create_font.py

echo ""
echo "Step 5: Cleaning up temporary files..."
rm -rf temp_bw temp_svg

echo ""
echo "✓ Done! JPBF.ttf has been created."
echo ""
ls -lh JPBF.ttf
