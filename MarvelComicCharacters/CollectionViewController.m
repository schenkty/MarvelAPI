//
//  CollectionViewController.m
//  MarvelAPI
//
//  Created by Ty Schenk on 08/18/17.
//  Copyright © 2017 Ty Schenk. All rights reserved.
//

#import "CollectionViewController.h"
#import "DetailViewController.h"
#import "CharacterCollectionViewCell.h"
#import "FooterView.h"
#import <CommonCrypto/CommonDigest.h>

@interface CollectionViewController ()

@end

@implementation CollectionViewController

static NSString * const reuseIdentifier = @"characterCell";
static NSInteger const apiResultsLimit = 50;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Marvel Characters";
    
    [self setupGestures];
    
    [self refreshCharacters];
}

- (void)setupGestures {
    UIScreenEdgePanGestureRecognizer *swipeRight = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(handleRightSwipe:)];
    [swipeRight setEdges:UIRectEdgeLeft];
    [swipeRight setDelegate:self];
    [self.view addGestureRecognizer:swipeRight];
    
    UIScreenEdgePanGestureRecognizer *swipeLeft = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(handleLeftSwipe:)];
    [swipeLeft setEdges:UIRectEdgeRight];
    [swipeLeft setDelegate:self];
    [self.view addGestureRecognizer:swipeLeft];
}

- (void)handleRightSwipe:(UIGestureRecognizer*)sender {
    if (sender.state == UIGestureRecognizerStateEnded && self.apiPageNumber != 0) {
        [self dismissViewControllerAnimated:true completion:nil];
    }
}

- (void)handleLeftSwipe:(UIGestureRecognizer*)sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
        [self performSegueWithIdentifier:@"nextSegue" sender:nil];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"nextSegue"]) {
        UINavigationController * navController = [segue destinationViewController];
        CollectionViewController * collectionVC = [navController topViewController];
        collectionVC.apiPageNumber = self.apiPageNumber + 1;
    } else if ([segue.identifier isEqualToString:@"detailSegue"]) {
        DetailViewController * detailVC = [segue destinationViewController];
        NSIndexPath *indexPath = [self.collectionView indexPathsForSelectedItems][0];
        detailVC.characterData = self.charactersArray[indexPath.row];
    }
}

- (void)refreshCharacters {
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    // compute url parameters
    NSTimeInterval seconds = [NSDate timeIntervalSinceReferenceDate];
    double milliseconds = seconds*1000;
    NSString *timestamp = [[NSString alloc] initWithFormat:@"%.0f", milliseconds];
    NSString *privateKey = @"08a3620ce4a626fd5cc3010b34a6165449bad1b1";
    NSString *apiKey = @"d1a9ae3d012af406ffdb9793189689d8";
    NSString *timestampAndAPIKey = [[NSString alloc] initWithFormat:@"%@%@%@", timestamp, privateKey, apiKey];
    NSString *hash = [self generateMD5:timestampAndAPIKey];
    
    NSString *urlString = [[NSString alloc]initWithFormat:@"https://gateway.marvel.com:443/v1/public/characters?offset=%ld&limit=%ld&ts=%@&apikey=%@&hash=%@", (long)[self offset], (long)apiResultsLimit, timestamp, apiKey, hash];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *requst = [[NSURLRequest alloc]initWithURL:url];
    
    NSURLSessionDownloadTask *charactersTask = [session downloadTaskWithRequest:requst completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (location == nil || response == nil || error) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Network issue" message:[NSString stringWithFormat:@"%@", error] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self dismissViewControllerAnimated:true completion:nil];
            }];
            [alertController addAction:action];
            [self presentViewController:alertController animated:true completion:nil];
        } else {
            NSData *charctersData = [[NSData alloc]initWithContentsOfURL:location];
            NSDictionary *charactersResponseDict = [NSJSONSerialization JSONObjectWithData:charctersData options:kNilOptions error:nil];
            self.charactersArray = [charactersResponseDict valueForKeyPath:@"data.results"];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.collectionView reloadData];
            });
        }
    }];
    
    [charactersTask resume];
}

- (NSInteger)offset {
    return _apiPageNumber * apiResultsLimit;
}

- (NSString *) generateMD5:(NSString *) input
{
    const char *cStr = [input UTF8String];
    unsigned char digest[16];
    CC_MD5( cStr, strlen(cStr), digest );
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  output;
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.charactersArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CharacterCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    cell.photoData = [self.charactersArray[indexPath.row] valueForKey:@"thumbnail"];
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    
    if (kind == UICollectionElementKindSectionHeader) {
        return nil;
    }
    
    FooterView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footerView" forIndexPath:indexPath];
    
    return footerView;
}

#pragma mark <UICollectionViewDelegate>

@end
