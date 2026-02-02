#!/usr/bin/env python3
"""
bright_accent.py - Extract bright accent color from wallpaper for borders
Works alongside pywal
"""

import sys
import os
import colorsys
from PIL import Image
from collections import Counter

# ============ CONFIG ============
CACHE_DIR = os.path.expanduser("~/.cache/wal")
WAL_FILE = os.path.join(CACHE_DIR, "wal")
ACCENT_FILE = os.path.join(CACHE_DIR, "accent")
ACCENT_SH = os.path.join(CACHE_DIR, "colors-accent.sh")

# How bright/saturated you want the accent
MIN_SATURATION = 0.5
MIN_BRIGHTNESS = 0.5
TARGET_LIGHTNESS = 0.65  # Higher = brighter
TARGET_SATURATION = 0.8  # Higher = more vibrant


def rgb_to_hex(r, g, b):
    return f"#{r:02x}{g:02x}{b:02x}"


def get_hls(r, g, b):
    """Convert RGB (0-255) to HLS"""
    return colorsys.rgb_to_hls(r / 255, g / 255, b / 255)


def hls_to_rgb(h, l, s):
    """Convert HLS to RGB (0-255)"""
    r, g, b = colorsys.hls_to_rgb(h, l, s)
    return int(r * 255), int(g * 255), int(b * 255)


def brighten_color(r, g, b):
    """Make color brighter and more vibrant"""
    h, l, s = get_hls(r, g, b)
    
    # Boost lightness
    l = max(l, TARGET_LIGHTNESS)
    l = min(l, 0.75)  # Cap to avoid too white
    
    # Boost saturation
    s = max(s, TARGET_SATURATION)
    
    return hls_to_rgb(h, l, s)


def extract_colors(image_path, sample_size=150):
    """Extract dominant colors from image"""
    img = Image.open(image_path).convert("RGB")
    img = img.resize((sample_size, sample_size), Image.Resampling.LANCZOS)
    
    # Reduce color depth for better grouping
    img = img.quantize(colors=32, method=Image.Quantize.MEDIANCUT)
    img = img.convert("RGB")
    
    pixels = list(img.getdata())
    return [color for color, _ in Counter(pixels).most_common(32)]


def score_color(r, g, b):
    """Score color based on vibrancy (high sat + good brightness)"""
    h, l, s = get_hls(r, g, b)
    
    # Skip grays and extremes
    if s < 0.2:
        return 0
    if l < 0.15 or l > 0.9:
        return 0
    
    # Prefer saturated colors with moderate-high lightness
    saturation_score = s
    brightness_score = 1 - abs(l - 0.5) * 2  # Peak at 0.5
    
    return (saturation_score * 0.7) + (brightness_score * 0.3)


def find_accent_color(colors):
    """Find the most vibrant color from extracted colors"""
    scored = [(score_color(*c), c) for c in colors]
    scored = [(s, c) for s, c in scored if s > 0]
    
    if not scored:
        # Fallback: return first non-gray color
        for c in colors:
            if get_hls(*c)[2] > 0.1:
                return c
        return colors[0] if colors else (255, 100, 100)
    
    scored.sort(reverse=True, key=lambda x: x[0])
    return scored[0][1]


def get_wallpaper_path():
    """Read wallpaper path from pywal cache"""
    if os.path.exists(WAL_FILE):
        with open(WAL_FILE, "r") as f:
            path = f.read().strip()
            if os.path.exists(path):
                return path
    return None

def save_hypr_accent(rgba_value):
    """Save:  $accent = rgba(r,g,b,a)  into ~/.cache/wal/hypr-accent.conf"""
    path = os.path.expanduser("~/.cache/wal/hypr-accent.conf")
    os.makedirs(os.path.dirname(path), exist_ok=True)

    with open(path, "w") as f:
        f.write(f"$accent = {rgba_value}\n")

def save_accent(hex_color):
    """Save accent color to cache files"""
    os.makedirs(CACHE_DIR, exist_ok=True)
    
    # Plain text file
    with open(ACCENT_FILE, "w") as f:
        f.write(hex_color)
    
    # Sourceable shell file
    with open(ACCENT_SH, "w") as f:
        f.write(f'# Bright accent color from wallpaper\n')
        f.write(f'accent="{hex_color}"\n')
        f.write(f'export BORDER_COLOR="{hex_color}"\n')
    
    # CSS variables (optional)
    with open(os.path.join(CACHE_DIR, "accent.css"), "w") as f:
        f.write(f':root {{ --accent-bright: {hex_color}; }}\n')


def main():
    # Get wallpaper path from argument or pywal cache
    if len(sys.argv) > 1:
        wallpaper = sys.argv[1]
    else:
        wallpaper = get_wallpaper_path()
    
    if not wallpaper:
        print("Usage: bright_accent.py [wallpaper_path]", file=sys.stderr)
        print("Or run 'wal' first to set wallpaper in cache", file=sys.stderr)
        sys.exit(1)
    
    if not os.path.exists(wallpaper):
        print(f"Error: File not found: {wallpaper}", file=sys.stderr)
        sys.exit(1)
    
    # Extract and process
    colors = extract_colors(wallpaper)
    accent_rgb = find_accent_color(colors)
    bright_rgb = brighten_color(*accent_rgb)
    hex_color = rgb_to_hex(*bright_rgb).lstrip("#")  # remove #
    alpha = "ff"  # change if you ever want transparency
    rgba = f"rgba({hex_color}{alpha})"
    hex = f"#{hex_color}" 
    # Save and output
    save_hypr_accent(rgba)
    save_accent(hex)
    print(rgba)


if __name__ == "__main__":
    main()
