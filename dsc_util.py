#!/usr/bin/env python2
# -*- coding: utf-8 -*-
"""
Created on Tue May 11 15:06:37 2021

@author: Gabriele Amorosino
"""

import nibabel as nib
import numpy as np
import math
class ConfusionMatrix(object):
    k = 1
    TPimg = None
    TP = None
    TNimg = None
    TN = None
    FNimg = None
    FN = None
    FPimg = None
    FP = None
    ALLimg = None
    accuracy = None
    Matrix = np.zeros([2, 2])
    
    def __init__(self, result, label, **kwargs):
        k = kwargs.get('k', self.k)
        result = (result == k).astype("int")
        label = (label == k).astype("int")
        sum_img = (result + label)
        self.TPimg = (sum_img == 2).astype("int")
        self.TP = np.count_nonzero(self.TPimg)
        self.TNimg = (sum_img == 0).astype("int")
        self.TN = np.count_nonzero(self.TNimg)
        diff_img = (result - label)
        self.FNimg = (diff_img == -1).astype("int")
        self.FN = np.count_nonzero(self.FNimg)
        self.FPimg = (diff_img == 1).astype("int")
        self.FP = np.count_nonzero(self.FPimg)
        self.ALLimg = self.TPimg + self.TNimg + self.FNimg + self.FPimg
        self.ALL = np.count_nonzero(self.ALLimg)
        
        self.Matrix[0, 0] = self.TP
        self.Matrix[0, 1] = self.FP
        self.Matrix[1, 0] = self.FN
        self.Matrix[1, 1] = self.TN
        
        # Derivations from the Confusion Matrix
        
        # Accuracy (ACC)
        self.accuracy = float(float(float(self.TP) + float(self.TN)) / float(self.ALL))
        # Sensitivity, recall, hit rate, or true positive rate(TPR)
        self.sensitivity = float(float(float(self.TP) )  / (float(self.TP) +float(self.FN)  ) )
        # Specificity, selectivity or true negative rate (TNR)
        self.specificity = float(float(float(self.TN) ) /  (float(self.TN) +float(self.FP)  ) )
        # Precision or positive predictive value (PPV)
        self.precision = float(float(float(self.TP) )  /   (float(self.TP) +float(self.FP)  ) )
        # Negative predictive value (NPV)
        self.NPV = float(float(float(self.TN) ) /  (float(self.TN) +float(self.FN)  ) )
        # Miss rate or false negative rate (FNR)
        self.miss_rate = 1 - self.sensitivity
        # Fall-Out or false positive rate (FPR)
        self.fall_out = 1 - self.specificity
        # False discovery rate (FDR)
        self.FDR =  1 - self.precision
        # False omission rate(FOR)
        self.FOR = 1 - self.NPV
        # F1 score is the harmonic mean of precision and sensitivity
        self.F1_score = float ( ( 2 * self.sensitivity * self.specificity ) / ( self.sensitivity + self.specificity ))
        # Youden J index or Bookmaker Informedness
        self.Youden_index = self.sensitivity + self.specificity -1
        # Matthews correlation coefficient (MCC)
        self.MCC = float (( self.TP * self.TN - self.FP * self.FN) / math.sqrt(float(self.TP+self.FP)*float(self.TP+self.FN)*float(self.TN+self.FP)*float(self.TN+self.FN)))
        # Markedness (MK)
        self.MK = self.precision + self.NPV -1
        # Dice Score 
        self.Dice_score = float( 2 * self.TP) / float( 2 * self.TP + self.FP + self.FN )
    
    def plot(self):
        labels = ["TRUE POSITIVE", "TRUE NEGATIVE", "FALSE NEGATIVE", "FALSE POSITIVE"]
        
        Total = self.TPimg + self.TNimg * 2 + self.FNimg * 3 + self.FPimg * 4
        if len(Total.shape) == 2:
              plt.figure()
              im = plt.imshow(Total, interpolation='none', cmap=plt.get_cmap("Set1"))
              values = np.unique(Total.ravel())
              colors = [im.cmap(im.norm(value)) for value in values]
              # create a patch (proxy artist) for every color
              patches = [matplotlib.patches.Patch(color=colors[i], label=labels[i]) for i in range(len(values))]
              plt.legend(handles=patches, bbox_to_anchor=(1.05, 1), loc=2, borderaxespad=0.)
              plt.grid(True)
              plt.show()
        else:
              cmap=plt.get_cmap("Set1")
              axi,sag,cor = OrtoView(Total,colormap=cmap)
              values = np.unique(Total.ravel())
              colors = [cmap(axi.norm(value)) for value in values]
              patches = [matplotlib.patches.Patch(color=colors[i], label=labels[i]) for i in range(len(values))]
              plt.legend(handles=patches, bbox_to_anchor=(0, -7),loc=2)
              #plt.grid(True)
              #plt.title("accuracy: " + str(self.accuracy))
              #plt.show()




def load_nib(T1_file):    
    T1_Struct=nib.load(T1_file);
    T1_aff=T1_Struct.get_affine(); 
    T1_header=T1_Struct.get_header();
    T1_img = T1_Struct.get_data();
    return T1_img,T1_header,T1_aff




def dice_score(predicted_file,gtruth_file ,seg_labels=None):
    
    predicted, _, _=load_nib(predicted_file)
    gtruth, _, _=load_nib(gtruth_file)
    
    if seg_labels is None:
                  seg_labels=np.unique(predicted)
                  
                  if np.any(seg_labels==0.0):
                      seg_labels=np.delete(seg_labels, 0)
                  print("labels found: "+str(seg_labels))

    if isinstance(seg_labels, list) :
                      seg_labels.sort()
    elif isinstance(seg_labels, np.ndarray):
                      np.sort(seg_labels)
    elif isinstance(seg_labels, int):               
                       seg_labels=[seg_labels]                 
    else:
                       seg_labels=[seg_labels]
    
    Dice_score=np.zeros(len(seg_labels))
    for idx,value in enumerate(seg_labels): 
        predicted_i=(predicted==value).astype(np.int)
        gtruth_i=(gtruth==value).astype(np.int)
        ConfMat = ConfusionMatrix(predicted_i, gtruth_i)
        Dice_score[idx]=ConfMat.Dice_score
    return Dice_score
