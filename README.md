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
+  This code is only for demo and different from the origianl code. The parameters for weighting the losses are not tuned, so performance may be worse than the ones in [BMVC17]. In addition, the random seed and the number of the epoches may effect the performance. 

+ The output size of the generator is W * H * 1 after a sigmoid normalization instead of W * H * 2 after a softmax normalization.

---

## Images generated in BMVC'17:  [Link](https://github.com/KuangJuiHsu/WSCNNTDSaliency)

## Some results in the journal extension:
+ Faster speed: 
<img src="https://github.com/KuangJuiHsu/WSCNNTDSaliency/blob/master/Image/Speed.PNG" height="150"/>

+ Better results:
<img src="https://github.com/KuangJuiHsu/WSCNNTDSaliency/blob/master/Image/Graz02.PNG" height="150"/>
<img src="https://github.com/KuangJuiHsu/WSCNNTDSaliency/blob/master/Image/VOC.PNG" height="150"/>
