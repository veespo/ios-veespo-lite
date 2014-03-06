// NVgalleryViewController.m
//
// Copyright (c) 2013 Nazar Kanaev (nkanaev@live.com)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "VEFlickrGalleryViewController.h"
#import "VEFlickrConnection.h"
#import "MBProgressHUD.h"

static CGFloat const kImageDistance = 5;

static CGSize CGSizeResizeToHeight(CGSize size, CGFloat height) {
    size.width *= height / size.height;
    size.height = height;
    return size;
}

@interface VEFlickrGalleryViewController ()
@property (nonatomic, strong) UIScrollView *contentView;

- (void)placeImages;
- (CGSize)setFramesToImageViews:(NSArray *)imageViews toFitSize:(CGSize)frameSize;
- (void)deviceOrientationChange;
@end

@implementation VEFlickrGalleryViewController

- (id)initWithSet:(NSString *)setId
{
    if (self = [super init]) {
        self.images = nil;
    }
    
    return self;
}

- (id)initWithImages:(NSArray *)images {
    if (self = [super init]) {
        self.images = images;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
        self.navigationController.navigationBar.tintColor = UIColorFromHex(0x231F20);
    } else {
        self.navigationController.navigationBar.translucent = NO;
        self.navigationController.navigationBar.titleTextAttributes = @{UITextAttributeTextColor: [UIColor whiteColor]};
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        self.navigationController.navigationBar.barTintColor = UIColorFromHex(0x231F20);
    }
    
//    self.title = NSLocalizedString(@"ESPN Top News", nil);
    self.view.backgroundColor = [UIColor whiteColor];
    
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
}

- (void)loadView {
    [super loadView];
    self.contentView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:self.contentView];
    [self getPhotos];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(deviceOrientationChange)
                                                 name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)getPhotos
{
    VEFlickrConnection *connection = [[VEFlickrConnection alloc] init];
    
    __block NSMutableArray *photosList = [[NSMutableArray alloc] init];
    
    [connection getPhotosInSet:nil
                       success:^(NSArray *responseData) {
                           __block int i = responseData.count;
                           for (NSDictionary *dic in responseData) {
                               VEFlickrConnection *bConnection = [[VEFlickrConnection alloc] init];
                               
                               [bConnection getPhotoThumb:dic[@"id"]
                                                  success:^(NSDictionary *responseData) {
                                                      NSString *strURL = [[responseData[@"size"] objectAtIndex:0] objectForKey:@"source"];
                                                      dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                                                                     ^{
                                                                         NSURL *imageURL = [NSURL URLWithString:strURL];
                                                                         NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
                                                                         
                                                                         //This is your completion handler
                                                                         dispatch_sync(dispatch_get_main_queue(), ^{
                                                                             [photosList addObject:[UIImage imageWithData:imageData]];
                                                                             i--;
                                                                             if (i == 0) {
                                                                                 self.images = photosList;
                                                                                 [self placeImages];
                                                                                 [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
                                                                             }
                                                                         });
                                                                     });
                                                  } failure:^(id error) {
                                                      NSLog(@"error");
                                                      i--;
                                                      if (i == 0) {
                                                          self.images = photosList;
                                                          [self placeImages];
                                                          [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
                                                      }
                                                  }
                                ];
                           }
                       } failure:^(id error) {
                           NSLog(@"error");
                           [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
                       }];
}

- (void)placeImages {
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    self.imageViews = [NSMutableArray array];
    for (UIImage *image in self.images) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        [self.imageViews addObject:imageView];
    }
    
    CGSize newSize = [self setFramesToImageViews:self.imageViews toFitSize:self.contentView.frame.size];
    self.contentView.contentSize = newSize;
    int i=0;
    for (UIImageView *imageView in self.imageViews) {
        [self.contentView addSubview:imageView];
        //delegate
        [imageView setUserInteractionEnabled:YES];
        [imageView setTag:i];
        i++;
        UITapGestureRecognizer *tapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgTouchUp:)];
        tapped.numberOfTapsRequired = 1;
        [imageView addGestureRecognizer:tapped];
    }
}

-(void) imgTouchUp:(id)sender {
    UITapGestureRecognizer *gesture = (UITapGestureRecognizer *) sender;
    NSLog(@"Taped Image tag is %d", gesture.view.tag);
    
    UIImageView *imageView = [self.imageViews objectAtIndex:gesture.view.tag];
    
    [self.delegate imageSelected:imageView];
}

- (void)deviceOrientationChange {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(placeImages) object:nil];
    [self performSelector:@selector(placeImages) withObject:nil afterDelay:1];
}

#pragma mark

- (CGSize)setFramesToImageViews:(NSArray *)imageViews toFitSize:(CGSize)frameSize {
    /**
     Linear Partition
     */
    int N = imageViews.count;
    CGRect newFrames[N];
    float ideal_height = MAX(frameSize.height, frameSize.width) / 4;
    float seq[N];
    float total_width = 0;
    for (int i = 0; i < imageViews.count; i++) {
        UIImage *image = [[imageViews objectAtIndex:i] image];
        CGSize newSize = CGSizeResizeToHeight(image.size, ideal_height);
        newFrames[i] = (CGRect) {{0, 0}, newSize};
        seq[i] = newSize.width;
        total_width += seq[i];
    }
    
    int K = (int)roundf(total_width / frameSize.width);
    
    float M[N][K];
    float D[N][K];
    
    for (int i = 0 ; i < N; i++)
        for (int j = 0; j < K; j++)
            D[i][j] = 0;
    
    for (int i = 0; i < K; i++)
        M[0][i] = seq[0];
    
    for (int i = 0; i < N; i++)
        M[i][0] = seq[i] + (i ? M[i-1][0] : 0);
    
    float cost;
    for (int i = 1; i < N; i++) {
        for (int j = 1; j < K; j++) {
            M[i][j] = INT_MAX;
            
            for (int k = 0; k < i; k++) {
                cost = MAX(M[k][j-1], M[i][0]-M[k][0]);
                if (M[i][j] > cost) {
                    M[i][j] = cost;
                    D[i][j] = k;
                }
            }
        }
    }
    
    /**
     Ranges & Resizes
     */
    int k1 = K-1;
    int n1 = N-1;
    int ranges[N][2];
    while (k1 >= 0) {
        ranges[k1][0] = D[n1][k1]+1;
        ranges[k1][1] = n1;
        
        n1 = D[n1][k1];
        k1--;
    }
    ranges[0][0] = 0;
    
    float cellDistance = 5;
    float heightOffset = cellDistance, widthOffset;
    float frameWidth;
    for (int i = 0; i < K; i++) {
        float rowWidth = 0;
        frameWidth = frameSize.width - ((ranges[i][1] - ranges[i][0]) + 2) * cellDistance;
        
        for (int j = ranges[i][0]; j <= ranges[i][1]; j++) {
            rowWidth += newFrames[j].size.width;
        }
        
        float ratio = frameWidth / rowWidth;
        widthOffset = 0;
        
        for (int j = ranges[i][0]; j <= ranges[i][1]; j++) {
            newFrames[j].size.width *= ratio;
            newFrames[j].size.height *= ratio;
            newFrames[j].origin.x = widthOffset + (j - (ranges[i][0]) + 1) * cellDistance;
            newFrames[j].origin.y = heightOffset;
            
            widthOffset += newFrames[j].size.width;
        }
        heightOffset += newFrames[ranges[i][0]].size.height + cellDistance;
    }
    
    for (int i = 0; i < N; i++) {
        UIImageView *imgView = imageViews[i];
        imgView.frame = newFrames[i];
        [self.contentView addSubview:imgView];
    }
    
    return CGSizeMake(frameSize.width, heightOffset);
}


@end
