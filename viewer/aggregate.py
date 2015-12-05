import csv
import json
import os
import glob
from PIL import Image
import numpy as np

def csv_to_json():
    for d in os.listdir('output'):
        d = os.path.join('output', d)
        if not os.path.isdir(d):
            continue
        for d2 in os.listdir(d):
            d2 = os.path.join(d,d2)
            if not os.path.isdir(d2):
                continue
            for f in glob.glob(os.path.join(d2, "*.csv")):
                out = f.replace('csv', 'json')
                with open(f,'rb') as csvfile:
                    reader = csv.reader(csvfile, delimiter=',')
                    r = reader.next()
                    with open(out, 'wb') as jsonfile:
                        json.dump({"psnr": r[0], "time": r[1]}, jsonfile, sort_keys = True)
                os.remove(f)


def aggregate_metrics():
    datasets = [ d for d in os.listdir('data') if os.path.isdir(os.path.join('data', d))]
    methods  = [ d for d in os.listdir('output') if os.path.isdir(os.path.join('output', d)) and d != "ground_truth"]

    dsets = {}
    for d in datasets:
        root = os.path.join('data', d)
        imgs = [os.path.split(f)[-1] for f in glob.glob(os.path.join(root, "*.png"))]
        dsets[d] = imgs


    msets = {}
    for m in methods:
        msets[m] = {}
        for d in datasets:
            dico = {}
            root = os.path.join('output', m, d)
            psnr = 0
            psnr_r = 0
            psnr_g = 0
            psnr_b = 0
            n    = 0
            time = 0
            jfiles = glob.glob(os.path.join(root,"*.json"))
            for f in jfiles:
                with open(f) as f_:
                    data = json.load(f_)
                    psnr += float(data['psnr'])
                    psnr_r += float(data['psnr_r'])
                    psnr_g += float(data['psnr_g'])
                    psnr_b += float(data['psnr_b'])
                    time += float(data['time'])
                    n += 1
            if n > 0:
                psnr /= n
                psnr_r /= n
                psnr_g /= n
                psnr_b /= n
                time /= n
            dico["n"] = n
            dico["psnr"] = psnr
            dico["psnr_r"] = psnr_r
            dico["psnr_g"] = psnr_g
            dico["psnr_b"] = psnr_b
            dico["time"] = time
            msets[m][d] = dico

    with open('data/methods.json', 'wb') as f:
        json.dump(msets, f, indent = 2, sort_keys = True)

    with open('data/datasets.json', 'wb') as f:
        json.dump(dsets, f, sort_keys = True)


def compute_psnr_and_diff():
    crop = 5
    datasets = [ d for d in os.listdir('data') if os.path.isdir(os.path.join('data', d))]
    methods  = [ d for d in os.listdir('output') if os.path.isdir(os.path.join('output', d)) and d != "ground_truth"]

    for dset in datasets:
        print dset
        dset_path = os.path.join('data', dset)
        imgs = [os.path.split(f)[-1] for f in glob.glob(os.path.join(dset_path, "*.png"))]
        for im in imgs:
            print "  -", im
            I = np.array(Image.open(os.path.join(dset_path, im))).astype(float)
            Icrop = I[crop:-crop, crop:-crop,:]
            for m in methods:
                method_path = os.path.join('output', m, dset, im)
                if not os.path.exists(method_path):
                    continue
                O = np.array(Image.open(method_path)).astype(float)

                diff_path = os.path.join('output', m, dset, os.path.splitext(im)[0]+"_diff"+os.path.splitext(im)[1])
                if not os.path.exists(diff_path):
                    diff = np.abs(O-I)
                    maxdiff = np.amax(diff)
                    mindiff = np.amin(diff)
                    diff = np.uint8(255*(diff-mindiff)/(maxdiff-mindiff))
                    Image.fromarray(diff).save(diff_path)

                O = O[crop:-crop, crop:-crop,:]

                mse = np.mean(np.mean(np.square(Icrop-O), axis = 0), axis = 0)
                mse_g = np.mean(mse)

                psnr = -10*np.log10(mse/(255.0*255.0))
                psnr_g = -10*np.log10(mse_g/(255.0*255.0))

                json_path = os.path.splitext(method_path)[0]+".json"
                with open(json_path, 'rb') as f:
                    h = json.load(f)
                    h['psnr'] = psnr_g
                    h['psnr_r'] = psnr[0]
                    h['psnr_g'] = psnr[1]
                    h['psnr_b'] = psnr[2]
                with open(json_path, 'wb') as f:
                    json.dump(h, f)

if __name__ == '__main__':
    print "convert csv to json"
    csv_to_json()

    compute_psnr_and_diff()

    print "aggregrate metrics"
    aggregate_metrics()

