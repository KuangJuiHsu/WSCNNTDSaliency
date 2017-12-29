# Codes for Weakly Supervised Saliency Detection

Contact: [Kuang-Jui Hsu](https://www.citi.sinica.edu.tw/pages/kjhsu/) (Email: kuang.jui.hsu@gmail.com)

Last update: 2017/12/29

Platform: Ubuntu 14.04, [MatConvnet 1.0-beta24](http://www.vlfeat.org/matconvnet/) (We don's support any installation problem of MatConvnet.)

---

# Paper: [BMVC17] Weakly Supervised Saliency Detection with A Category-Driven Map Generator
Authors: [Kuang-Jui Hsu](https://www.citi.sinica.edu.tw/pages/kjhsu/), [Yen-Yu Lin](https://www.citi.sinica.edu.tw/pages/yylin/index_zh.html), [Yung-Yu Chuang](https://www.csie.ntu.edu.tw/~cyy/)

<img src="https://github.com/KuangJuiHsu/WSCNNTDSaliency/blob/master/Image/BMVC17.PNG" height="400"/>
<img src="https://github.com/KuangJuiHsu/WSCNNTDSaliency/blob/master/Image/BMVC17_Result.PNG" height="400"/>

PDF: [Link1](https://www.csie.ntu.edu.tw/~cyy/publications/papers/Hsu2017WSS.pdf), [Link2](http://cvlab.citi.sinica.edu.tw/images/paper/bmvc-Hsu17.pdf)

<p>Please cite our paper if this code is useful for your research.</p>
<pre><code>
@inproceedings{HsuBMVC17,
  author = {K.-J. Hsu and Y.-Y. Lin and Y.-Y Chuang},
  booktitle = {British Machine Vision Conference (BMVC)},
  title = {Weakly Supervised Saliency Detection with A Category-Driven Map Generator},
  year = {2017}
}
</code></pre>

---

## Demo for training and test: "Run.m"
+ This code is only for demo and different from the origianl code because some files were overwrited when I worked for the journal extension. 

+ The output size of the generator is W * H * 1 after a sigmoid normalization instead of W * H * 2 after a softmax normalization.

+ The parameters for weighting losses are not tuned.

+ The random seed and the number of total epoches may effect the performance. 

+ The results are slightly better than ones reported in [BMVC'17] for Graz02 Dataset.
  - [Link for Epoches](https://github.com/KuangJuiHsu/WSCNNTDSaliency)
  - [Link for Results](https://github.com/KuangJuiHsu/WSCNNTDSaliency)
  - Graz02 Results with the release code

| Bike  | Car | Person  | Mean |
| ------------- | ------------- | ------------- | ------------- |
| 80.4  | 63.1  | 66.5  | 70.0 |


---

## Results used in BMVC'17:  
+ [Graz02](https://drive.google.com/file/d/1Se6uKCAqfzi2AvdyXRk6j4bHH34cM-Nr/view?usp=sharing)
+ [VOC07](https://drive.google.com/file/d/19M5SY00VX-cUmqH8GQ6diGYG75ot-vnu/view?usp=sharing)
+ [VOC12](https://drive.google.com/file/d/14kXlSd2kAdnxMN0F8VdfCyOmgiWUlxZU/view?usp=sharing)

---

## [Link](https://github.com/KuangJuiHsu/WSCNNTDSaliency_Journal): Some results in the journal extension (will be released until it is accepted).
+ Faster speed: 
<img src="https://github.com/KuangJuiHsu/WSCNNTDSaliency_Journal/blob/master/Image/Speed.PNG" height="150"/>

+ Better results:
<img src="https://github.com/KuangJuiHsu/WSCNNTDSaliency_Journal/blob/master/Image/Graz02.PNG" height="300"/>
<img src="https://github.com/KuangJuiHsu/WSCNNTDSaliency_Journal/blob/master/Image/VOC.PNG" height="300"/>
