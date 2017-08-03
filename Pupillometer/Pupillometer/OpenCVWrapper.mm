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
    
    cv::Mat imageMat;
    UIImageToMat(image, imageMat);
    
    if(imageMat.channels() == 1) return image;
    cv::Mat grayMat;
    cv::cvtColor(imageMat, grayMat, CV_BGR2GRAY);
    
    vector<Vec3f> circles;
    
    
    
    HoughCircles(grayMat, circles, HOUGH_GRADIENT, 10, 150, 250, 30, 100, 350);
    // change the last two parameters
    // (min_radius & max_radius) to detect larger circles
    cv::Mat testMat;
    cv::cvtColor(grayMat, imageMat, CV_GRAY2BGR);
    
    for( size_t i = 0; i < circles.size(); i++ )
    {
        Vec3i c = circles[i];
        circle( imageMat, cv::Point(c[0], c[1]), c[2], Scalar(0,0,255), 1, LINE_AA);
        
    }
    
    return MatToUIImage(imageMat);
    //    waitKey();
    //    return 0;
}
@end



