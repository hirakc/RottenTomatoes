//
//  MovieCell.h
//  rottentomatoesdemo
//
//  Created by Hirak Chatterjee on 6/10/14.
//  Copyright (c) 2014 Hirak Chatterjee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *movieTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *movieSynopsisLabel;
@property (weak, nonatomic) IBOutlet UIImageView *moviePosterView;

@end
