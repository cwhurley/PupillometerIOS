//
//  OpenCVWrapper.m
//  Pupillometer
//
//  Created by Chris Hurley on 3/8/17.
//  Copyright © 2017 Chris Hurley. All rights reserved.
//

#include "opencv2/imgcodecs.hpp"
#include "opencv2/highgui/highgui.hpp"
#include "opencv2/imgproc/imgproc.hpp"
#include <iostream>
#import <opencv2/opencv.hpp>
#import <opencv2/imgcodecs/ios.h>

using namespace cv;
using namespace std;

@implementation OpenCVWrapper : NSObject

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
    params.maxThreshold = 200;
    
    // Filter by Area.
    params.filterByArea = true;
    params.minArea = 300;
    
    // Filter by Circularity
    params.filterByCircularity = true;
    params.minCircularity = 0.1;
    
    // Filter by Convexity
    params.filterByConvexity = true;
    params.minConvexity = 0.50;
    
    // Filter by Inertia
    params.filterByInertia = true;
    params.minInertiaRatio = 0.5;
    
    params.filterByColor = true;
    params.blobColor = 0;
    
    
    params.minDistBetweenBlobs = 300;
    
    
    // Storage for blobs
    vector<KeyPoint> keypoints;
    
    
    //cv::Canny(grayMat, grayMat, 30, 60);
    // Set up detector with params
    Ptr<SimpleBlobDetector> detector = SimpleBlobDetector::create(params);
    
    // Detect blobs
    detector->detect( grayMat, keypoints);
    
    
    // Draw detected blobs as red circles.
    // DrawMatchesFlags::DRAW_RICH_KEYPOINTS flag ensures
    // the size of the circle corresponds to the size of blob
    
    Mat im_with_keypoints;
    drawKeypoints( grayMat, keypoints, im_with_keypoints, Scalar(0,255,0), DrawMatchesFlags::DRAW_RICH_KEYPOINTS );
    
    for(int i=0; i<keypoints.size(); i++){
        //circle(out, keyPoints[i].pt, 20, cvScalar(255,0,0), 10);
        //cout<<keyPoints[i].response<<endl;
        //cout<<keyPoints[i].angle<<endl;
        cout<<keypoints[i].size<<endl;
        //cout<<keypoints[i].pt.x<<endl;
        //cout<<keypoints[i].pt.y<<endl;
       // cout<<keypoints[i].   <<endl;
    }
    
    
    // Show blobs
    
    return MatToUIImage(im_with_keypoints);
}

+(NSString *) Results
{
    
    return @"test";
}

@end


    /*
    //Mat src, src_gray;
    //cv::Mat imageMat;
    //UIImageToMat(image, imageMat);
    
    //if(imageMat.channels() == 1) return image;
    //cv::Mat grayMat;
    //cv::cvtColor(imageMat, grayMat, CV_BGR2GRAY);
    
    //cv::morphologyEx(grayMat, grayMat, 3, cv::getStructuringElement(cv::MORPH_DILATE,cv::Size(2,2)));
    //cv::Canny(grayMat, grayMat, 80, 80);
    //cv::GaussianBlur( grayMat, grayMat, cv::Size(7, 7), 0);
    
    //cv::GaussianBlur( matThreshed, matThreshed, cv::Size(3.0, 3.0), 2.0, 2.0 );
    //cv::medianBlur( matThreshed, matThreshed, cv::Size(3.0, 3.0));
    //cv::GaussianBlur( matThreshed, matThreshed, cv::Size(3.0, 3.0), 2.0, 2.0 );
    //cv::Canny(grayMat, grayMat, 30, 60);
    // 50 7 3
    //cv::GaussianBlur( matThreshed, matThreshed, cv::Size(3.0, 3.0), 2.0, 2.0 );
    //cv::morphologyEx(grayMat, grayMat, 1, cv::getStructuringElement(cv::MORPH_RECT,cv::Size(2,2)));
    //cv::Canny(grayMat, grayMat, 50, 150);
    
    //cv::fastNlMeansDenoising(grayMat, grayMat);
    //cv::Canny(grayMat, grayMat, 30, 90);
    //cv::Laplacian(grayMat, grayMat, 10);
    //cv::erode(grayMat, grayMat, 10);
    
    Mat src, src_gray, dst;
    cv::Mat imageMat;
    UIImageToMat(image, imageMat);
    
    if(imageMat.channels() == 1) return image;
    cv::Mat grayMat;
    cv::cvtColor(imageMat, grayMat, CV_BGR2GRAY);
    //GaussianBlur( src_gray, src_gray, Size(9, 9), 2, 2 );
    
    //cv::Mat matThreshed = Mat(grayMat);
    //cv::GaussianBlur( matThreshed, matThreshed, cv::Size(3.0, 3.0), 2.0, 2.0 );
    //cv::Canny(grayMat, grayMat, 100, 300);
    //cv::GaussianBlur( grayMat, grayMat, cv::Size(9.0, 9.0), 2.0, 2.0 );
    //cv::morphologyEx(grayMat, grayMat, 3, cv::getStructuringElement(cv::MORPH_RECT,cv::Size(2,2)));
    //cv::Canny(grayMat, grayMat, 30, 90);
    //cv::threshold(grayMat, grayMat, 5, 5, cv::THRESH_OTSU);
    
    

    
    cv::threshold(grayMat, grayMat, 50, 200, 1);
    
    
    
    cv::GaussianBlur( grayMat, grayMat, cv::Size(11, 5), 2, 2 );
    //cv::medianBlur(grayMat, grayMat, 4);
    cv::Canny(grayMat, grayMat, 10, 30);
    
    vector<Vec3f> circles;
    HoughCircles(grayMat, circles, CV_HOUGH_GRADIENT, 2, grayMat.rows / 1, 150, 75, 10, 150);
    // change the last two parameters
    // (min_radius & max_radius) to detect larger circles
    
    
    
    cv::Mat testMat;
    cv::cvtColor(grayMat, imageMat, CV_GRAY2BGR);
    
    for( size_t i = 0; i < circles.size(); i++ )
    {
        cv::Point center(cvRound(circles[i][0]), cvRound(circles[i][0]));
        int radius = cvRound(circles[i][2]);
        // circle center
        circle( imageMat, center, 3, Scalar(0,255,0), -1, 8, 0 );
        // circle outline
        circle( imageMat, center, radius, Scalar(0,0,255), 3, 8, 0 );
        
    }
    printf("%ld,", circles.size());
    return MatToUIImage(imageMat);
    //    waitKey();
    //    return 0;
}
@end

/*
 src_gray: Input image (grayscale)
 circles: A vector that stores sets of 3 values: x_{c}, y_{c}, r for each detected circle.
 CV_HOUGH_GRADIENT: Define the detection method. Currently this is the only one available in OpenCV
 dp = 1: The inverse ratio of resolution
 min_dist = src_gray.rows/8: Minimum distance between detected centers
 param_1 = 200: Upper threshold for the internal Canny edge detector
 param_2 = 100*: Threshold for center detection.
 min_radius = 0: Minimum radio to be detected. If unknown, put zero as default.
 max_radius = 0: Maximum radius to be detected. If unknown, put zero as default
 */

