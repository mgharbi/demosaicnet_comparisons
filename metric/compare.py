import os
from PIL import Image
import numpy as np

from scipy.ndimage.filters import convolve

def normalize_img(I, factor = -1):
    I = np.float32(I)
    mini = np.amin(I)
    maxi = np.amax(I)
    if factor > 0:
        I = I/factor
    else:
        I = (I-mini)/(maxi-mini+1e-10)
    I = np.uint8(255*I)
    return I

def total_variation(R):
    dx_filter = np.array([[-1,1],])
    dy_filter = np.array([[-1],[1]])
    dx_filter.shape += (1,)
    dy_filter.shape += (1,)
    dx = convolve(R, dx_filter )
    dy = convolve(R, dy_filter )

    tv = np.abs(dx)+np.abs(dy)
    return tv



path1 = "gt.png"
path2 = "ours.png"
path3 = "flexisp.png"

O = np.array(Image.open(path1)).astype(np.float32)
R = np.array(Image.open(path2)).astype(np.float32)
Risp = np.array(Image.open(path3)).astype(np.float32)

# err = np.abs(O-R)
# err_isp = np.abs(O-Risp)
# Image.fromarray(normalize_img(err,100)).save("err.png")
# Image.fromarray(normalize_img(err_isp,100)).save("err_isp.png")

Image.fromarray(normalize_img(total_variation(R),350)).save("tv_ours.png")
Image.fromarray(normalize_img(total_variation(Risp),350)).save("tv_isp.png")
Image.fromarray(normalize_img(total_variation(O),350)).save("tv_gt.png")
