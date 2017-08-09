//
//  OpenCVWrapper.h
//  Pupillometer
//
//  Created by Chris Hurley on 3/8/17.
//  Copyright © 2017 Chris Hurley. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <opencv2/imgproc/imgproc_c.h>

@interface OpenCVWrapper : NSObject

+(UIImage *) makeGrayFromImage:(UIImage *)image;

@end
