# Codes for Weakly Supervised Saliency Detection

Contact: [Kuang-Jui Hsu](https://www.citi.sinica.edu.tw/pages/kjhsu/) (Email: kuang.jui.hsu@gmail.com)

Last update: 2017/12/28

Platform: Ubuntu 14.04, MatConvnet 1.0-beta24 (http://www.vlfeat.org/matconvnet/) (We don's support any installation problem of MatConvnet.)

---

# Paper: [BMVC17] Weakly Supervised Saliency Detection with A Category-Driven Map Generator
Authors: [Kuang-Jui Hsu](https://www.citi.sinica.edu.tw/pages/kjhsu/), [Yen-Yu Lin](https://www.citi.sinica.edu.tw/pages/yylin/index_zh.html), [Yung-Yu Chuang](https://www.csie.ntu.edu.tw/~cyy/)

PDF:

Link1: https://www.csie.ntu.edu.tw/~cyy/publications/papers/Hsu2017WSS.pdf
Link2: http://cvlab.citi.sinica.edu.tw/images/paper/bmvc-Hsu17.pdf

---

## These codes are different from the original version because of the journal submission.

1. The output size of the generator is W * H * 1 after a sigmoid normalization instead of W * H * 2 after a softmax normalization.

2. In the journal submission, we introduced two addition losses which will be released until the extension version is accepted.

**In these codes, we only release the version with the losses used in [BMVC'17] and sigmoid, and the parameters for weighting the losses are not tuned. The performance may be worse than the ones in [BMVC17]. Howver, the result of all datasets reported in [BMVC17] will be released soon.**

---

## Demo for Training and test: "Run.m"

---

## The models and results in BMVC'17:


