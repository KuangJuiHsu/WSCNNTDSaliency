# Codes for Weakly Supervised Saliency Detection

Contact: [Kuang-Jui Hsu](https://www.citi.sinica.edu.tw/pages/kjhsu/) (Email: kuang.jui.hsu@gmail.com)

Last update: 2017/12/28

Platform: Ubuntu 14.04, [MatConvnet 1.0-beta24](http://www.vlfeat.org/matconvnet/) (We don's support any installation problem of MatConvnet.)

---

# Paper: [BMVC17] Weakly Supervised Saliency Detection with A Category-Driven Map Generator
Authors: [Kuang-Jui Hsu](https://www.citi.sinica.edu.tw/pages/kjhsu/), [Yen-Yu Lin](https://www.citi.sinica.edu.tw/pages/yylin/index_zh.html), [Yung-Yu Chuang](https://www.csie.ntu.edu.tw/~cyy/)

PDF:

+ Link1: https://www.csie.ntu.edu.tw/~cyy/publications/papers/Hsu2017WSS.pdf 

+ Link2: http://cvlab.citi.sinica.edu.tw/images/paper/bmvc-Hsu17.pdf

---

## Demo for Training and test: "Run.m"
+ This code is only for demo and different from the origianl code because some files were overwrited when I worked for the journal extension. 

+ The output size of the generator is W * H * 1 after a sigmoid normalization instead of W * H * 2 after a softmax normalization.

+ In addition, the random seed and the number of the epoches may effect the performance. 

---

## Results used in BMVC'17:  [Released soon](https://github.com/KuangJuiHsu/WSCNNTDSaliency)
+ Be patient because the data are downloading from Google drive

---

## Some results in the journal extension: will be released until it is accepted.
+ Faster speed: 
<img src="https://github.com/KuangJuiHsu/WSCNNTDSaliency/blob/master/Image/Speed.PNG" height="150"/>

+ Better results:
<img src="https://github.com/KuangJuiHsu/WSCNNTDSaliency/blob/master/Image/Graz02.PNG" height="300"/>
<img src="https://github.com/KuangJuiHsu/WSCNNTDSaliency/blob/master/Image/VOC.PNG" height="300"/>
