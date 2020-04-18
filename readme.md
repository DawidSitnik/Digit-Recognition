# Recognizing Handwritten Dgits From the MNIST Dataset

## Dataset
*can be downloaded from: http://yann.lecun.com/exdb/mnist*

MNIST Handwritten Digits dataset is used for this task. It contains images of digits taken from a variety of scanned documents, normalized in size and centered. Each image is a 28 by 28 pixel square (784 pixels total). The dataset contains 60,000 images for model training and 10,000 images for the evaluation of the model.

## Task Description
The aim of this excercise is to classify images using **linear classifiers**. The difficulty of using linear classifiers for classifying many classes is that those type of classifiers can only split the difference between two classes. In our case we need to differentiate 10 (numbers from 0 to 9). To succesfully solve this problem I am going to implement **one vs one** and **one vs rest** classifiers which will enable solving the issue. 

### One vs One Classifier
Considers each binary pair of classes and trains classifier on subset of data containing those classes. So it trains total *n*(n-1)/2* classes. During the classification phases each classifier predicts one class. After that, there is a voting phase which chooses the class which got one consent decision. If any of the classes doesn't get maximal number of votes, the digit is classified as undefined. 

*Choosing treshold of votes for positive classification at that high level (max number of votes) is quite conservative, so unwinding it might boost our result. Anyway, for todays task I am going to stick into conservative assumptions.*

### One vs Rest Classifier 
This approach takes one class as positive and rest all as negative and trains the classifier. So for the data having n-classes it trains n classifiers. Deciding on the same restrictions as in the previous approach, the digit get label of the class only if its probability equals to 1. If any of classifiers didn't get that high probability the digit is labeled as undefined.

*Such restrictive assumptions may produce many undefined and false labels, respecitvely in situations in which probability is high but not equal to one or when many clasifiers got probability equaled to 1. Being aware of all I am going to stick to that assumptions to stay consistent with one vs one classifier.*

### Perceptron Method of Sepparating the Plane
This is a type of binary and supervised classification so it splits samples into two classes only and needs labels for training. 
The perceptron consists of 4 parts:
-Input values of one input layer
-Weights and bias
-Net sum
-Activation function

For the proper work of classifier the weights are needed to be set first. It is done in few steps:
a. Initialize weights with random numbers
b. for each sample in the training dataset:
- make prediction
- if you have made an error increment error value
- update weights by adding alpha * error * sample weights to them.

The steps which are taken for classification are:
a. All the inputs are multiplied with their weights w.
b. The weighted sum is callculated by adding all values from previous step.
c. The activation function is applied. 

### Dataset Preparation

Before training classifiers the data was transformed with **PCA** to reduce its dimensionality to 40. 
Another modification that was made was feature expanding, which was based on adding some extra attributes which were multiplications of original features xi * xj for i <= j. So if we had F attributes at the beggining we should get F + F(F-1)/2 after the transformation. 

### Final result of the classification
Each type of classification was performed on expanded and normal version of dataset.

#### One vs One perceptron classfier

*Every classifier was trained with parameters alpha = 0.00001, epochs = 50*

| Dataset               | Correct     | Misstakes | Not Classified  |
| ----------------------| ----------- |-----------|-----------------|
| Expanded, test        | 0.7974      | 0.0652    | 0.1374          |
| Expanded, train       | 0.7894      | 0.0695    | 0.1410          |
| Not Expanded, test    | 0.8372      | 0.1455    | 0.0173          |
| Not Expanded, train   | 0.8246      | 0.1557    | 0.0195          |

Confusion Matrix for training, not expanded dataset:

<p align="center">
  <img src = "https://imgur.com/NsmNBCc.png"/>
</p>

Deducing from above, it can be stated that the classifier has the biggest problem with classification digit 5 (only 3785 positive classification), which was frequentely considered as 3 (306 cases), as 1 (270 cases) or didn't get maximum amount of votes and were not classified (265 cases).

The digit with the best result was 1 with the score of 6266 positive classifications. This digit was mostly mistaken with digit nr 8 ( 159 cases ) and 2 (96 cases).

It is hard to find any pattern in the confusion matrix, overall result of the classifier is acceptable. 

### SVM Classifier
The library *libVSM* was used to compare perceptron method with another methods of classification. The library implements SVM classifier which has voting mechanism inside, so for this part there is no need to use any of voting functions. *LibSVM* implements "one-against-one" multi-class method, so there are k(k-1)/2 binary models, where k is the number of classes.

We can consider two ways to conduct parameter selection.

- For any two classes of data, a parameter selection procedure is conducted. Finally, each decision function has its own optimal parameters.
- The same parameters are used for all k(k-1)/2 binary classification problems. We select parameters that achieve the highest overall performance.

Each has its own advantages. A single parameter set may not be uniformly good for all k(k-1)/2 decision functions. However, as the overall accuracy is the final consideration, one parameter set for one decision function may lead to over-fitting. In the paper *Chen, Lin, and Schölkopf, A tutorial on nu-support vector machines. Applied Stochastic Models in Business and Industry, 21(2005), 111-136*, they have experimentally shown that the two methods give similar performance. Therefore, currently the parameter selection in LIBSVM takes the second approach by considering the same parameters for all k(k-1)/2 models.

Classification Results:
| Dataset               | Correct     | Misstakes | Not Classified  |
| ----------------------| ----------- |-----------|-----------------|
| Expanded, test        | 0.9839      | 0.0035    | 0.0095          |
| Expanded, train       | 0.9955      | 0.0091    | 0.0098          |
| Not Expanded, test    | 0.9821      | 0.0035    | 0.0095          |
| Not Expanded, train   | 0.9910      | 0.0017    | 0.0097          |

### Result Summary

#### Perceptron vs SVM
In this type of problems the SVM outperformes Perceptron, giving 98,39% of positive classifications, when Perseptron scores only 83.72 in the best case. However, this fact doesn't mean, that Perceptron is worse in every case and I will try to explain good and bad sides of each. 

Perceptron is an online algorithm which means it can processes the data points one by one. On the other hand, SVM needs all the training data and only then starts building the classifier. So in case of a new data, we can't update the model but we need to train it once again. 

The perceptron algorithm tries to reduce error and thus, gives a good enough classification for the data points. However, since SVM looks at maximizing the margin(by reducing (1/2 * (theta)^2)) allows you to find the most optimal solution. Thus, SVM can help you classify the test data in a better way as a large margin can help you segregate it better.

Along with maximizing the margin, the SVM algorithm also provides you with the concept of slack variables(soft margin) which again helps you classify test data in a better way.

In any case, the theory doesn't works in practice, neither it was in this case. As we could see in the tables which summarizes the result, perseptron performed better on test set, not the training one. This result from some kind of a randomness connected with perceptron classifier, which isn't a deterministic algorithm.  

### Extended vs Not Extended Dataset
In case of perceptron classification it didn't brighten the result, because it usually gave 3.5% worse score. In this case, 
extending the size of the dataset didn't influence the training time too much, which is quite abvious if we look at the implementation of perceptron.

In SVM classification, extending dataset, boosted the result of one percent, but it was at the cost of the training time, which was significantly bigger.


