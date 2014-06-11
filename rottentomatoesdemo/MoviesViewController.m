//
//  MoviesViewController.m
//  rottentomatoesdemo
//
//  Created by Hirak Chatterjee on 6/9/14.
//  Copyright (c) 2014 Hirak Chatterjee. All rights reserved.
//

#import "MoviesViewController.h"
#import "MovieCell.h"
#import "../Pods/AFNetworking/AFNetworking/AFHTTPRequestOperation.h"
#import "MovieDetailsViewController.h"



@interface MoviesViewController ()
@property (weak, nonatomic) IBOutlet UITableView *movieTableView;
@property (strong, nonatomic) NSArray *movies;

@end

@implementation MoviesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Movies";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.movieTableView.delegate = self;
    self.movieTableView.dataSource = self;
    
    NSString *url = @"http://api.rottentomatoes.com/api/public/v1.0/lists/dvds/top_rentals.json?apikey=xhtdvqc3qfy5za4hy6xffskf";
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        id object = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
       // NSLog(@"%@", object);
        
        self.movies = object[@"movies"];
        [self.movieTableView reloadData];
    }];
    
    [self.movieTableView registerNib:[UINib nibWithNibName: @"MovieCell" bundle:nil] forCellReuseIdentifier:@"MovieCell"];
    
    self.movieTableView.rowHeight = 150;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view methods

- (int) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    NSLog(@"called ...");
    return self.movies.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    MovieCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell"];
    
    

//    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    NSDictionary *movie = self.movies[indexPath.row];
    cell.movieTitleLabel.text = movie[@"title"];
    cell.movieSynopsisLabel.text = movie[@"synopsis"];
    
   
    NSDictionary *posters = movie[@"posters"];
    NSString *thumbnailUrl = posters[@"detailed"];
//    NSLog(@"array: %@", posters);
    
    
    NSURLRequest *imgRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:thumbnailUrl]];
    
    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest: imgRequest];
    requestOperation.responseSerializer = [AFImageResponseSerializer serializer];
    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"Response: %@", responseObject);
        cell.imageView.image = responseObject;
        [cell setNeedsLayout];
        [self.movieTableView layoutSubviews];
//        [cell.imageView setContentMode: UIViewContentModeTopLeft];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Image error: %@", error);
    }];
    [requestOperation start];
    
    
//    cell.imageView.
//    cell.movieTitleLabel.text = @"Hello";
    return cell;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    MovieDetailsViewController *vdc = [[MovieDetailsViewController alloc] init];
    
    NSLog(@"%d", indexPath.row);
    
    NSDictionary *movie = self.movies[indexPath.row];
    vdc.descriptionLabel.text = movie[@"synopsis"];
    
    NSDictionary *posters = movie[@"posters"];
    NSString *origUrl = posters[@"original"];
    
    NSURLRequest *imgRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:origUrl]];
    
    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest: imgRequest];
    requestOperation.responseSerializer = [AFImageResponseSerializer serializer];
    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        vdc.bgImageView.image = responseObject;
//        [vdc.bgImageView setNeedsLayout];

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Image error: %@", error);
    }];
    [requestOperation start];
    
    [self.navigationController pushViewController:vdc animated:YES];
    
    
}

@end
