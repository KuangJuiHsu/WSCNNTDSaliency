# [BMVC17] Weakly Supervised Saliency Detection with A Category-Driven Map Generator

## These codes are different from the original version because of the journal submission.

1. The output of the generator is W \times H \times 1 after a sigmoid normalization instead of W \times H \times 2 after a softmax normalization .

2. In the journal submission, we introduced two addition losses which will be released until the extension version is accepted.


In these codes, we only release the version with sigmoid and the losses used in [BMVC'17], and the parameters for weighting the losses are not tuned. The performance may be different from the ones in [BMVC17].

In addition, the result of all datasets reported in [BMVC17] will be released soon.
