//
//  ViewController.m
//  CCLabelDemo
//
//  Created by dengyouhua on 2019/6/28.
//  Copyright © 2019 cc | ccworld1000@gmail.com. All rights reserved.
//

#import "ViewController.h"
#import "CCTableViewCell.h"
#import "DetailVC.h"

static NSString *CCTableViewCellID = @"CCTableViewCellID";

@interface ViewController ()<CCLabelDelegate>

@property (nonatomic, strong) NSArray *espressos;
@property (weak, nonatomic) IBOutlet UITableView *list;

@end

@implementation ViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"espressos" ofType:@"txt"];
        self.espressos = [[NSString stringWithContentsOfFile:filePath usedEncoding:nil error:nil] componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"Espressos";

    [self.list registerClass:[CCTableViewCell class] forCellReuseIdentifier:CCTableViewCellID];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.espressos.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [CCTableViewCell heightForCellWithText:[self.espressos objectAtIndex:(NSUInteger)indexPath.row] availableWidth:CGRectGetWidth(self.list.frame)];
}

 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     CCTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CCTableViewCellID forIndexPath:indexPath];
     NSString *description = [self.espressos objectAtIndex:(NSUInteger)indexPath.row];
     cell.summaryText = description;
     cell.summaryLabel.delegate = self;
     cell.summaryLabel.userInteractionEnabled = YES;
     return cell;
 }

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *description = [self.espressos objectAtIndex:(NSUInteger)indexPath.row];
    DetailVC *d = [[DetailVC alloc] initWithEspressoDescription:description];
    [self.navigationController pushViewController:d animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - CCLabelDelegate

- (void)attributedLabel:(__unused CCLabel *)label
   didSelectLinkWithURL:(NSURL *)url {
    NSString *title = [url absoluteString];
    
    UIAlertController * ac = [UIAlertController alertControllerWithTitle:@"" message:title preferredStyle:UIAlertControllerStyleActionSheet];
    [ac addAction:[UIAlertAction actionWithTitle:@"Open Link in Safari" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:title] options:@{} completionHandler:nil];
    }]];
    
    [ac addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        ;
    }]];
    
    [self presentViewController:ac animated:NO completion:nil];
}

- (void)attributedLabel:(__unused CCLabel *)label didLongPressLinkWithURL:(__unused NSURL *)url atPoint:(__unused CGPoint)point {
    UIAlertController * ac = [UIAlertController alertControllerWithTitle:@"URL Long Pressed" message:@"You long-pressed a URL. Well done!" preferredStyle:UIAlertControllerStyleAlert];
    [ac addAction:[UIAlertAction actionWithTitle:@"Woohoo!"style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        ;
    }]];

    [self presentViewController:ac animated:NO completion:nil];
}

@end
