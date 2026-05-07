from PIL import Image, ImageDraw, ImageFont
import os

W, H = 900, 240

img = Image.new('RGB', (W, H), '#0D1B2A')
draw = ImageDraw.Draw(img)

for y in range(H):
    t = y / H
    r = int(13 + t * 5)
    g = int(27 + t * 10)
    b = int(42 + t * 18)
    draw.line([(0, y), (W, y)], fill=(r, g, b))

try:
    font_title = ImageFont.truetype('segoeui.ttf', 56)
    font_sub = ImageFont.truetype('segoeui.ttf', 24)
except:
    try:
        font_title = ImageFont.truetype('arialbd.ttf', 56)
        font_sub = ImageFont.truetype('arial.ttf', 24)
    except:
        font_title = ImageFont.load_default()
        font_sub = ImageFont.load_default()

rx, ry = 50, 40

body_points = [
    (rx+45, ry), (rx+62, ry+28), (rx+62, ry+52),
    (rx+80, ry+64), (rx+80, ry+82),
    (rx+62, ry+74), (rx+60, ry+90),
    (rx+50, ry+102), (rx+38, ry+108),
    (rx+40, ry+96), (rx+34, ry+86),
    (rx+26, ry+82), (rx+12, ry+94),
    (rx+12, ry+76), (rx+26, ry+64),
    (rx+20, ry+46), (rx+20, ry+22),
]
draw.polygon(body_points, fill='#E8E8E8', outline='#B0B0B0')

draw.ellipse([rx+32, ry+44, rx+42, ry+54], fill='#FFFFFF')
draw.ellipse([rx+30, ry+42, rx+44, ry+56], outline='#64B5F6', width=2)

draw.polygon([(rx+45,ry),(rx+62,ry+28),(rx+62,ry+52),(rx+50,ry+38)], fill='#C0C0C0')

draw.polygon([(rx+26,ry+82),(rx+12,ry+94),(rx+12,ry+76),(rx+22,ry+72)], fill='#FF6B35')
draw.polygon([(rx+62,ry+74),(rx+80,ry+82),(rx+80,ry+64),(rx+68,ry+62)], fill='#FF6B35')

draw.ellipse([rx+6,  ry+92, rx+20, ry+102], fill='#FF4444')
draw.ellipse([rx+10, ry+96, rx+18, ry+104], fill='#FFAA00')
draw.ellipse([rx+76, ry+78, rx+90, ry+88],  fill='#FF4444')
draw.ellipse([rx+80, ry+82, rx+88, ry+90],  fill='#FFAA00')

for i in range(3):
    sz = 4 - i
    draw.ellipse([rx+2-i*4, ry+98+i*6, rx+2-i*4+sz*2, ry+98+i*6+sz*2],
                 fill=(255, 100+i*30, 0))

draw.ellipse([rx+36, ry+46, rx+39, ry+49], fill='#64B5F6')

draw.text((145, 55), 'HERMES WINDOWS NATIVE', fill='#E8E8E8', font=font_title)

subtitle = 'No Docker \u00b7 No WSL2 \u00b7 Pure Windows Native'
draw.text((145, 140), subtitle, fill='#8899AA', font=font_sub)

draw.line([(145, 125), (145 + 520, 125)], fill='#3D8BFD', width=3)

draw.rectangle([15, 15, 25, 25], fill='#3D8BFD')
draw.rectangle([W-25, 15, W-15, 25], fill='#3D8BFD')
draw.rectangle([15, H-25, 25, H-15], fill='#3D8BFD')
draw.rectangle([W-25, H-25, W-15, H-15], fill='#3D8BFD')

img.save('assets/banner.png', quality=95)
print(f'Done: {os.path.getsize("assets/banner.png")} bytes')
