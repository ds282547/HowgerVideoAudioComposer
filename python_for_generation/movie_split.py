from pypinyin import pinyin, Style
from moviepy.editor import VideoFileClip
import numpy as np
import math
import time

timestr = time.strftime("%Y%m%d_%H%M%S")

inp = '這我都清楚但我沒有辦法改變'
movie_source = "video.mp4"
output_filename = "result_"+timestr
postfix = ".mp4"

timepoints_filename = 'timepoints.txt'


# 縮減
shrink_front = 0.1
shrink_rear = 0.27

convs = pinyin(inp, style=Style.BOPOMOFO)
tones = ['ˊ', 'ˇ', 'ˋ', '˙']
inputs = []


i = 0
for raw in convs:
    raw = raw[0]
    spell = raw[:-1]
    tone = raw[-1]
    if tone in tones:
        # 2,3,4,輕聲
        tone = tones.index(tone) + 2
    else:
        # 1聲
        tone = 1
        spell = raw
    inputs.append((inp[i], spell, tone))
    i += 1



# 時間
fp = open(timepoints_filename, 'r', encoding='utf-8')
lines = fp.readlines()
fp.close()

tp = {}
for line in lines:
    m = line.split(',')
    tp[m[0]] = []
    for j in range(len(m)//3):
        sp = (float(m[j*3+2]) + shrink_front)
        ep = (float(m[j*3+3]) - shrink_rear)
        tp[m[0]].append([sp, ep])

stacks = []
fullClip = VideoFileClip(movie_source)
for (orig, spell, tone) in inputs:
    (sp, ep) = tp[spell][tone-1]

    fullClip.subclip(sp, ep).res.write_videofile(output_filename+"_"+orig+postfix)
    print(orig, sp, ep)





