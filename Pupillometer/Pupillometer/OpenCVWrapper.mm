//
//  OpenCVWrapper.m
//  Pupillometer
//
//  Created by Chris Hurley on 3/8/17.
//  Copyright © 2017 Chris Hurley. All rights reserved.
//
//https://www.learnopencv.com/blob-detection-using-opencv-python-c/


#include "opencv2/imgcodecs.hpp"
#include "opencv2/highgui/highgui.hpp"
#include "opencv2/imgproc/imgproc.hpp"
#include <iostream>
#import <opencv2/opencv.hpp>
#import <opencv2/imgcodecs/ios.h>

using namespace cv;
using namespace std;

NSArray *hello;
double point;
double point2;
double difference;

double areaC = 400;
double thresholdC = 200;
double circularityC = 0.1;
double convexityC = 0.4;
double inertiaC = 0.1;

@implementation OpenCVWrapper : NSObject

+(double) setArea:(double) area;
{
    areaC = area;
    
    return areaC;
}

+(double) setThresh:(double) thresholds;
{
    thresholdC = thresholds;
    
    return thresholdC;
}

+(double) setCir:(double) circularity;
{
    circularityC = circularity;
    
    return circularityC;
}

+(double) setConv:(double) convexity;
{
    convexityC = convexity;
    
    return convexityC;
}

+(double) setIner:(double) inertia;
{
    inertiaC = inertia;
    
    return inertiaC;
}
+(UIImage *) makeGrayFromImage:(UIImage *)image;
{
    
    // Read image
    Mat src, src_gray;
    cv::Mat imageMat;
    UIImageToMat(image, imageMat);
    if(imageMat.channels() == 1) return image;
    cv::Mat grayMat;
    cv::cvtColor(imageMat, grayMat, CV_BGR2GRAY);
    
    // Setup SimpleBlobDetector parameters.
    SimpleBlobDetector::Params params;
    
    // Change thresholds
    params.minThreshold = 10;
    params.maxThreshold = thresholdC;
    
    // Filter by Area.
    params.filterByArea = true;
    params.minArea = areaC;
    
    // Filter by Circularity
    params.filterByCircularity = true;
    params.minCircularity = circularityC;
    
    // Filter by Convexity
    params.filterByConvexity = true;
    params.minConvexity = convexityC;
    
    // Filter by Inertia
    params.filterByInertia = true;
    params.minInertiaRatio = inertiaC;
    
    params.filterByColor = true;
    params.blobColor = 0;
    
    params.minDistBetweenBlobs = 300;
    
    // Storage for blobs
    vector<KeyPoint> keypoints;

    // Set up detector with params
    Ptr<SimpleBlobDetector> detector = SimpleBlobDetector::create(params);
    
    // Detect blobs
    detector->detect( grayMat, keypoints);
    
    // Draw detected blobs as red circles. DrawMatchesFlags::DRAW_RICH_KEYPOINTS flag ensures the size of the circle corresponds to the size of blob
    Mat im_with_keypoints;
    drawKeypoints( grayMat, keypoints, im_with_keypoints, Scalar(0,255,0), DrawMatchesFlags::DRAW_RICH_KEYPOINTS );
    
    for(int i=0; i<keypoints.size(); i++){
        point = 0;
        point = keypoints[i].size;
        cout<<point<<endl;
    }
    cout<<point2<<endl;
    // Show blobs
    return MatToUIImage(im_with_keypoints);
}

+(double) firstResult
{
    double firstResult;
    firstResult = point;
    point = 0;
    return firstResult;
}

+(double) secondResult
{
    double secondResult;
    secondResult = point;
    return secondResult;
}

+(double) difference
{
    return difference;
}

@end

